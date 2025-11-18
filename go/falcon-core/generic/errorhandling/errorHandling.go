package errorhandling

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ErrorHandling_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"fmt"
	"sync"
	"unsafe"
)

type Handle struct {
	mu sync.RWMutex
}

// ErrorHandler the global error handling system
var ErrorHandler = &Handle{}

// CheckCapiError returns a Go error based on the last error code and message.
// If code is 0, returns nil. If 1, error is recoverable. If 2, not recoverable.
func (h *Handle) CheckCapiError() error {
	h.mu.RLock()
	code := int(C.get_last_error_code())
	var msg string
	if code != 0 {
		msg = C.GoString(C.get_last_error_msg())
	}
	h.mu.RUnlock()

	if code == 0 {
		return nil
	}
	h.ResetError()
	switch code {
	case 1:
		return fmt.Errorf("non fatal error: %s", msg)
	case 2:
		return fmt.Errorf("fatal error: %s", msg)
	default:
		return fmt.Errorf("unknown error %d: %s", code, msg)
	}
}

// ResetError clears the last error code and message.
func (h *Handle) ResetError() {
	h.set_last_error(0, "")
}

func (h *Handle) set_last_error(code int, msg string) {
	h.mu.Lock()
	defer h.mu.Unlock()
	cmsg := C.CString(msg)
	defer C.free(unsafe.Pointer(cmsg))
	C.set_last_error(C.int(code), cmsg)
}
