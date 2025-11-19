package standardresponse

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/messages/StandardResponse_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)

type chandle C.StandardResponseHandle

type Handle struct {
	chandle chandle
	mu      sync.RWMutex
	closed  bool
}

func new(h chandle) *Handle {
	handle := &Handle{chandle: h}
	runtime.SetFinalizer(handle, func(h *Handle) { h.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(chandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Handle already closed")
	}
	C.StandardResponse_destroy(C.StandardResponseHandle(h.chandle))
	h.closed = true
	h.chandle = nil
	return nil
}

func New(message string) (*Handle, error) {
	msgStr := str.New(message)
	defer msgStr.Close()
	msgPtr, err := msgStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.StandardResponse_create(C.StringHandle(msgPtr)))
	return new(h), nil
}

func (h *Handle) Message() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("Message: handle is closed")
	}
	cStr := C.StandardResponse_message(C.StandardResponseHandle(h.chandle))
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return false, errors.New("Equal: other handle is closed or nil")
	}
	val := bool(C.StandardResponse_equal(C.StandardResponseHandle(h.chandle), C.StandardResponseHandle(other.chandle)))
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return false, errors.New("NotEqual: other handle is closed or nil")
	}
	val := bool(C.StandardResponse_not_equal(C.StandardResponseHandle(h.chandle), C.StandardResponseHandle(other.chandle)))
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.StandardResponse_to_json_string(C.StandardResponseHandle(h.chandle))
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func FromJSON(json string) (*Handle, error) {
	strHandle := str.New(json)
	defer strHandle.Close()
	strPtr, err := strHandle.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.StandardResponse_from_json_string(C.StringHandle(strPtr)))
	return new(h), nil
}
