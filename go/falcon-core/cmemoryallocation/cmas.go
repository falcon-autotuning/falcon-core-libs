/*
Package cmemoryallocation provides a central memory allocation and access system for Go wrappers of C/C++ resources.
It ensures thread-safe access, lifecycle management, and cleanup of memory stacks that represent C-API objects.
Each memory stack is uniquely identified by the memory address of the underlying C object (as a uint32 key).

Features:
  - Thread-safe allocation, access, and deallocation of C resources.
  - Usage counting and deletion marking for safe concurrent access and cleanup.
  - Background cleaner goroutine for automatic removal of unused/deleted stacks.
  - Generic wrappers for allocation, deallocation, read, and write operations on any Go type implementing HasCAPIHandle.
  - Integration with Go's runtime finalizer system for automatic resource cleanup.

Typical usage involves wrapping a C pointer in a Go struct implementing HasCAPIHandle, and using the provided wrappers to safely allocate, access, and free the underlying C resource.
*/
package cmemoryallocation

import (
	"errors"
	"fmt"
	"runtime"
	"sort"
	"sync"
	"time"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
)

/*
CMAS is the central memory allocation system

This controls the access to all the memory stacks and ensures thread safety
Memory stacks are identified by a unique uint32 number (mNum)
This pointer used by the CPP implementation to uniquely identify memory resources

  - cacheMu: mutex to protect the cache. Hold this mutex only when accessing the cache.
  - cacheCond: condition variable to signal cache changes
  - memoryStacks: map of memory stacks
  - usageStacks: map of usage counts for each memory stack. The usage count indicates how many active references exist to a memory stack
  - cache: sorted slice of mNums currently being accessed
  - stopCleaner: channel to stop the cleaner goroutine
*/
type CMAS struct {
	cacheMu      sync.Mutex
	cacheCond    *sync.Cond
	memoryStacks map[uint32]*MemoryStack
	usageStacks  map[uint32]int
	cache        []uint32
	stopCleaner  chan struct{}
}

/*
MemoryStack represents a single chunk of memory allocated to the C-API.

This single chunk of memory can be accessed concurrently and thread-safely.

  - mu: mutex to protect access to the memory stack
  - deleted: flag indicating if the memory stack has been deleted
*/
type MemoryStack struct {
	mu      sync.RWMutex
	deleted bool
}

type HasCAPIHandle interface {
	CAPIHandle() unsafe.Pointer // a method to get the C-API handle
	ResetHandle()               // a method to reset the C-API handle
}

func NewCMAS() *CMAS {
	cmas := &CMAS{
		memoryStacks: make(map[uint32]*MemoryStack),
		usageStacks:  make(map[uint32]int),
		cache:        make([]uint32, 0),
		stopCleaner:  make(chan struct{}),
	}
	cmas.cacheCond = sync.NewCond(&cmas.cacheMu)
	go cmas.cleaner()
	return cmas
}

// binary search for mNum in cache
func (cmas *CMAS) cacheHas(mNum uint32) bool {
	i := sort.Search(len(cmas.cache), func(i int) bool { return cmas.cache[i] >= mNum })
	return i < len(cmas.cache) && cmas.cache[i] == mNum
}

// insert mNum into cache (sorted)
func (cmas *CMAS) cacheInsert(mNum uint32) {
	i := sort.Search(len(cmas.cache), func(i int) bool { return cmas.cache[i] >= mNum })
	if i < len(cmas.cache) && cmas.cache[i] == mNum {
		return // already present
	}
	cmas.cache = append(cmas.cache, 0)
	copy(cmas.cache[i+1:], cmas.cache[i:])
	cmas.cache[i] = mNum
}

// remove mNum from cache
func (cmas *CMAS) cacheDelete(mNum uint32) {
	i := sort.Search(len(cmas.cache), func(i int) bool { return cmas.cache[i] >= mNum })
	if i < len(cmas.cache) && cmas.cache[i] == mNum {
		cmas.cache = append(cmas.cache[:i], cmas.cache[i+1:]...)
	}
}

// wait until mNum not present, then insert
func (cmas *CMAS) waitAndInsertCache(mNum uint32) {
	cmas.cacheMu.Lock()
	for {
		if !cmas.cacheHas(mNum) {
			cmas.cacheInsert(mNum)
			break
		}
		cmas.cacheCond.Wait()
	}
	cmas.cacheMu.Unlock()
}

// remove mNum from cache and broadcast
func (cmas *CMAS) removeCacheAndBroadcast(mNum uint32) {
	cmas.cacheMu.Lock()
	cmas.cacheDelete(mNum)
	cmas.cacheCond.Broadcast()
	cmas.cacheMu.Unlock()
}

/*
FromCAPI is a wrapper to perform a memory assignment through the C-API.

Go does not directly allocate memory for C resources, so we need to use a factory function to maintain our records and ensure thread safety.

  - p: unsafe.Pointer to the C-API memory resource
  - constructHandle: function to construct the Go handle from the C-API pointer
  - deallocMem: function to deallocate the C-API memory resource

This method returns a Go handle to the C-API memory resource and an error if any.
*/
func FromCAPI[T any, PT interface {
	HasCAPIHandle
	*T
}](p unsafe.Pointer,
	constructHandle func(unsafe.Pointer) PT,
	deallocMem func(unsafe.Pointer),
) (PT, error) {
	var zero PT
	if p == nil {
		return zero, errors.New(`FromCAPI: the pointer is null`)
	}
	mNum := uint32(uintptr(p))
	cmas := GetCMAS()
	cmas.waitAndInsertCache(mNum)

	stack, exists := cmas.memoryStacks[mNum]
	if !exists {
		cmas.memoryStacks[mNum] = &MemoryStack{mu: sync.RWMutex{}, deleted: false}
		cmas.usageStacks[mNum] = 1
	} else {
		stack.mu.Lock()
		if stack.deleted {
			stack.mu.Unlock()
			cmas.removeCacheAndBroadcast(mNum)
			return zero, errors.Join(fmt.Errorf(`FromCAPI: memory address  %x was found to be deleted: `, mNum), ErrStackDeleted)
		}
		cmas.usageStacks[mNum]++
		stack.mu.Unlock()
	}
	cmas.removeCacheAndBroadcast(mNum)
	obj := constructHandle(p)
	// NOTE: The following AddCleanup/finalizer is not covered by tests because
	// Go's garbage collector does not guarantee finalizer execution during tests.
	// This is a known limitation of Go's coverage tooling and is safe to ignore.
	runtime.AddCleanup(obj, func(_ any) { CloseAllocation(obj, deallocMem) }, true)
	return obj, nil
}

/*
NewAllocation is a wrapper to perform a new memory allocation through the C-API.

Go does not directly allocate memory for C resources, so we need to use a factory function to maintain our records and ensure thread safety.

  - allocMem: function to allocate the C-API memory resource
  - constructHandle: function to construct the Go handle from the C-API pointer
  - deallocMem: function to deallocate the C-API memory resource

This method returns a Go handle to the C-API memory resource and an error if any.
*/
func NewAllocation[T any, PT interface {
	HasCAPIHandle
	*T
}](
	allocMem func() (unsafe.Pointer, error),
	constructHandle func(unsafe.Pointer) PT,
	deallocMem func(unsafe.Pointer),
) (PT, error) {
	var zero PT
	mem, err := allocMem()
	if err != nil {
		return zero, err
	}
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return zero, errors.Join(errors.New(`could not allocate memory from C-API`), err)
	}
	obj := constructHandle(mem)
	// NOTE: The following AddCleanup/finalizer is not covered by tests because
	// Go's garbage collector does not guarantee finalizer execution during tests.
	// This is a known limitation of Go's coverage tooling and is safe to ignore.
	runtime.AddCleanup(obj, func(_ any) { CloseAllocation(obj, deallocMem) }, true)
	mNum := uint32(uintptr(obj.CAPIHandle()))
	cmas := GetCMAS()
	cmas.waitAndInsertCache(mNum)
	cmas.memoryStacks[mNum] = &MemoryStack{mu: sync.RWMutex{}, deleted: false}
	cmas.usageStacks[mNum] = 1
	cmas.removeCacheAndBroadcast(mNum)
	return obj, nil
}

/*
CloseAllocation is a wrapper to perform the thread safe deallocation of memory through the c-api.

Go does not directly control memory for C resources, so we need to use a factory function to maintain our records and ensure thread safety.

  - obj: HasCAPIHandle object to be deallocated
  - deallocMem: function to deallocate the C-API memory resource. This is a function that must call the _destroy method of the C-API.

This method returns an error if any during the destroy process.
*/
func CloseAllocation(
	obj HasCAPIHandle,
	deallocMem func(unsafe.Pointer),
) error {
	if obj == nil || obj.CAPIHandle() == nil {
		return errors.New(`CloseAllocation: the object is nil`)
	}
	mNum := uint32(uintptr(obj.CAPIHandle()))
	cmas := GetCMAS()
	stack, exists := cmas.memoryStacks[mNum]
	if !exists {
		return ErrStackNotFound
	}

	stack.mu.Lock()
	defer stack.mu.Unlock()

	cmas.waitAndInsertCache(mNum)

	if cmas.usageStacks[mNum] >= 1 {
		cmas.usageStacks[mNum]--
	}
	if cmas.usageStacks[mNum] == 0 {
		stack.deleted = true
	}

	cmas.removeCacheAndBroadcast(mNum)

	deallocMem(obj.CAPIHandle())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return errors.Join(errors.New(`could not destroy after memory was deallocated`), err)
	}
	obj.ResetHandle()
	return nil
}

/*
Read is a wrapper to perform read operations on the memory stack.

Go does not directly control memory for C resources, so we need to use a factory function to maintain our records and ensure thread safety.

  - obj: HasCAPIHandle object to read from
  - fn: function to perform the read operation

This method returns the output of the read function and an error if any.
*/
func Read[T any](obj HasCAPIHandle, fn func() (T, error)) (T, error) {
	if obj == nil || obj.CAPIHandle() == nil {
		var zero T
		return zero, errors.New(`Read: the object is nil`)
	}
	mNum := uint32(uintptr(obj.CAPIHandle()))
	cmas := GetCMAS()
	stack, exists := cmas.memoryStacks[mNum]
	if !exists {
		var zero T
		return zero, ErrStackNotFound
	}
	stack.mu.RLock()
	defer stack.mu.RUnlock()
	if stack.deleted {
		var zero T
		return zero, ErrStackDeleted
	}
	out, err := fn()
	if err != nil {
		var zero T
		return zero, errors.Join(errors.New(`Read function failed`), err)
	}
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		var zero T
		return zero, errors.Join(errors.New(`C-API error during Read operation`), err)
	}
	return out, nil
}

/*
MultiRead is a wrapper to perform many read operations on the memory stack.

Go does not directly control memory for C resources, so we need to use a factory function to maintain our records and ensure thread safety.

  - objs: many HasCAPIHandle objects to read from
  - fn: function to perform the read operation

This method returns the output of the read function and an error if any.
*/
func MultiRead[T any](objs []HasCAPIHandle, fn func() (T, error)) (T, error) {
	type lockInfo struct {
		stack *MemoryStack
		mNum  uint32
	}
	cmas := GetCMAS()
	infos := make([]lockInfo, len(objs))
	for i, obj := range objs {
		if obj == nil || obj.CAPIHandle() == nil {
			var zero T
			return zero, errors.New(`MultiRead: the object is nil`)
		}
		mNum := uint32(uintptr(obj.CAPIHandle()))
		stack, exists := cmas.memoryStacks[mNum]
		if !exists {
			var zero T
			return zero, ErrStackNotFound
		}
		infos[i] = lockInfo{stack, mNum}
	}
	for _, info := range infos {
		info.stack.mu.RLock()
		defer info.stack.mu.RUnlock()
		if info.stack.deleted {
			var zero T
			return zero, ErrStackDeleted
		}
	}
	out, err := fn()
	if err != nil {
		var zero T
		return zero, errors.Join(errors.New(`MultiRead function failed`), err)
	}
	capiErr := errorhandling.ErrorHandler.CheckCapiError()
	if capiErr != nil {
		var zero T
		return zero, errors.Join(errors.New(`C-API error during MultiRead operation`), capiErr)
	}
	return out, nil
}

/*
Write is a wrapper to perform write operations on the memory stack.

Go does not directly control memory for C resources, so we need to use a factory function to maintain our records and ensure thread safety.

  - obj: HasCAPIHandle object to write to
  - fn: function to perform the write operation

This method returns an error if any.
*/
func Write(obj HasCAPIHandle, fn func() error) error {
	if obj == nil || obj.CAPIHandle() == nil {
		return errors.New(`Write: the object is nil`)
	}
	mNum := uint32(uintptr(obj.CAPIHandle()))
	cmas := GetCMAS()
	stack, exists := cmas.memoryStacks[mNum]
	if !exists {
		return ErrStackNotFound
	}
	stack.mu.Lock()
	defer stack.mu.Unlock()
	if stack.deleted {
		return ErrStackDeleted
	}
	err := fn()
	if err != nil {
		return errors.Join(errors.New(`Write function failed`), err)
	}
	return errorhandling.ErrorHandler.CheckCapiError()
}

/*
ReadWrite is a wrapper to perform many reads and a write operation on the memory stack.

Go does not directly control memory for C resources, so we need to use a factory function to maintain our records and ensure thread safety.

  - obj: HasCAPIHandle object to write to
  - fn: function to perform the write operation

This method returns an error if any.
*/
func ReadWrite(write HasCAPIHandle, objs []HasCAPIHandle, fn func() error) error {
	type lockInfo struct {
		stack *MemoryStack
		mNum  uint32
	}
	cmas := GetCMAS()
	infos := make([]lockInfo, len(objs))
	for i, obj := range objs {
		if obj == nil || obj.CAPIHandle() == nil {
			return errors.New(`ReadWrite: the object is nil`)
		}
		mNum := uint32(uintptr(obj.CAPIHandle()))
		stack, exists := cmas.memoryStacks[mNum]
		if !exists {
			return ErrStackNotFound
		}
		infos[i] = lockInfo{stack, mNum}
	}
	for _, info := range infos {
		info.stack.mu.RLock()
		defer info.stack.mu.RUnlock()
		if info.stack.deleted {
			return ErrStackDeleted
		}
	}
	if write == nil || write.CAPIHandle() == nil {
		return errors.New(`ReadWrite: the write object is nil`)
	}
	mNum := uint32(uintptr(write.CAPIHandle()))
	stack, exists := cmas.memoryStacks[mNum]
	if !exists {
		return ErrStackNotFound
	}
	stack.mu.Lock()
	defer stack.mu.Unlock()
	if stack.deleted {
		return ErrStackDeleted
	}
	err := fn()
	if err != nil {
		return errors.Join(errors.New(`ReadWrite function failed`), err)
	}
	return errorhandling.ErrorHandler.CheckCapiError()
}

// Cleaner goroutine: periodically removes deleted stacks with zero usage
func (cmas *CMAS) cleaner() {
	ticker := time.NewTicker(1 * time.Second)
	defer ticker.Stop()
	for {
		select {
		case <-ticker.C:
			cmas.cacheMu.Lock()
			for mNum, stack := range cmas.memoryStacks {
				if stack.deleted && cmas.usageStacks[mNum] == 0 {
					fmt.Printf("D:qeleting stack mNum=%x\n", mNum)
					delete(cmas.memoryStacks, mNum)
					delete(cmas.usageStacks, mNum)
				}
			}
			cmas.cacheMu.Unlock()
		case <-cmas.stopCleaner:
			return
		}
	}
}

// StopCleaner stop the cleaner goroutine
func (cmas *CMAS) StopCleaner() {
	close(cmas.stopCleaner)
}

// Error definitions
var (
	ErrStackNotFound = &StackError{"stack not found"}
	ErrStackDeleted  = &StackError{"stack deleted"}
)

type StackError struct {
	msg string
}

func (e *StackError) Error() string {
	return e.msg
}
