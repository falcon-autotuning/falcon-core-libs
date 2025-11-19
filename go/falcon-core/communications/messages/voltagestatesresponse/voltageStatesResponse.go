package voltagestatesresponse

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/voltage_states/DeviceVoltageStates_c_api.h>
#include <falcon_core/communications/messages/VoltageStatesResponse_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestates"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)

type chandle C.VoltageStatesResponseHandle

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
	C.VoltageStatesResponse_destroy(C.VoltageStatesResponseHandle(h.chandle))
	h.closed = true
	h.chandle = nil
	return nil
}

func New(message string, states *devicevoltagestates.Handle) (*Handle, error) {
	msgStr := str.New(message)
	defer msgStr.Close()
	msgPtr, err := msgStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	statesPtr, err := states.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.VoltageStatesResponse_create(
		C.StringHandle(msgPtr),
		C.DeviceVoltageStatesHandle(statesPtr),
	))
	return new(h), nil
}

func (h *Handle) Message() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("Message: handle is closed")
	}
	cStr := C.VoltageStatesResponse_message(C.VoltageStatesResponseHandle(h.chandle))
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func (h *Handle) States() (*devicevoltagestates.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("States: handle is closed")
	}
	cStates := C.VoltageStatesResponse_states(C.VoltageStatesResponseHandle(h.chandle))
	return devicevoltagestates.FromCAPI(unsafe.Pointer(cStates))
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
	val := bool(C.VoltageStatesResponse_equal(C.VoltageStatesResponseHandle(h.chandle), C.VoltageStatesResponseHandle(other.chandle)))
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
	val := bool(C.VoltageStatesResponse_not_equal(C.VoltageStatesResponseHandle(h.chandle), C.VoltageStatesResponseHandle(other.chandle)))
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.VoltageStatesResponse_to_json_string(C.VoltageStatesResponseHandle(h.chandle))
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
	h := chandle(C.VoltageStatesResponse_from_json_string(C.StringHandle(strPtr)))
	return new(h), nil
}
