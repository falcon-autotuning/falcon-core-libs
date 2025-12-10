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
	"runtime"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
)

type HasCAPIHandle interface {
	CAPIHandle() unsafe.Pointer // a method to get the C-API handle
	ResetHandle()               // a method to reset the C-API handle
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
	if obj == nil {
		return errors.New(`CloseAllocation: the object is nil`)
	}
	if obj.CAPIHandle() == nil {
		return errors.New(`CloseAllocation: the object contains nil`)
	}
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
	if obj == nil {
		var zero T
		return zero, errors.New(`Read: the object is nil`)
	}
	if obj.CAPIHandle() == nil {
		var zero T
		return zero, errors.New(`Read: the object contains nil`)
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
	for _, obj := range objs {
		if obj == nil {
			var zero T
			return zero, errors.New(`MultiRead: the object is nil`)
		}
		if obj.CAPIHandle() == nil {
			var zero T
			return zero, errors.New(`MultiRead: the object contains nil`)
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
	if obj == nil {
		return errors.New(`Write: the object is nil`)
	}
	if obj.CAPIHandle() == nil {
		return errors.New(`Write: the object contains nil`)
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
	for _, obj := range objs {
		if obj == nil {
			return errors.New(`ReadWrite: the object is nil`)
		}
		if obj.CAPIHandle() == nil {
			return errors.New(`ReadWrite: the object contains nil`)
		}
	}
	if write == nil || write.CAPIHandle() == nil {
		return errors.New(`ReadWrite: the write object is nil`)
	}
	err := fn()
	if err != nil {
		return errors.Join(errors.New(`ReadWrite function failed`), err)
	}
	return errorhandling.ErrorHandler.CheckCapiError()
}
