package str

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type stringHandle C.StringHandle

type Handle struct {
	chandle stringHandle
	mu      sync.RWMutex
	closed  bool
}

// CAPIHandle provides access to the underlying CAPI handle for the String
func (s *Handle) CAPIHandle() (unsafe.Pointer, error) {
	if s.closed || s.chandle == utils.NilHandle[stringHandle]() {
		return nil, errors.New("String:Close The string is already closed")
	}
	return unsafe.Pointer(s.chandle), nil
}

// newString adds an auto cleanup whenever added to a constructor
func new(h stringHandle) *Handle {
	str := &Handle{chandle: h}
	// NOTE: The following AddCleanup/finalizer is not covered by tests because
	// Go's garbage collector does not guarantee finalizer execution during tests.
	// This is a known limitation of Go's coverage tooling and is safe to ignore.
	runtime.AddCleanup(str, func(_ any) { str.Close() }, true)
	return str
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`StringFromCAPI The pointer is null`)
	}
	return new(stringHandle(p)), nil
}

func New(raw string) *Handle {
	craw := C.CString(raw)
	defer C.free(unsafe.Pointer(craw))
	h := stringHandle(C.String_create(craw, C.size_t(len(raw))))
	return new(h)
}

func (s *Handle) Close() error {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.closed || s.chandle == utils.NilHandle[stringHandle]() {
		return errors.New("String:Close The string is already closed")
	}
	C.String_destroy(C.StringHandle(s.chandle))
	s.closed = true
	s.chandle = nil
	return nil
}

func (s *Handle) ToGoString() (string, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	if s.closed || s.chandle == nil {
		return "", errors.New("String:Raw The string is closed")
	}
	sh := (*C.struct_string)(unsafe.Pointer(s.chandle))
	return C.GoStringN(sh.raw, C.int(sh.length)), nil
}
