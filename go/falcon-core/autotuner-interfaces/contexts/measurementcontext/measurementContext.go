package measurementcontext

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/contexts/MeasurementContext_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/instrument_interfaces/names/InstrumentPort_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

type chandle C.MeasurementContextHandle

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

func New(connection *connection.Handle, instrumentType string) (*Handle, error) {
	connPtr, err := connection.CAPIHandle()
	if err != nil {
		return nil, err
	}
	strHandle := str.New(instrumentType)
	defer strHandle.Close()
	strPtr, err := strHandle.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.MeasurementContext_create(C.ConnectionHandle(connPtr), C.StringHandle(strPtr)))
	return new(h), nil
}

func NewFromPort(port *instrumentport.Handle) (*Handle, error) {
	portPtr, err := port.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.MeasurementContext_create_from_port(C.InstrumentPortHandle(portPtr)))
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Handle already closed")
	}
	C.MeasurementContext_destroy(C.MeasurementContextHandle(h.chandle))
	h.closed = true
	h.chandle = nil
	return nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Connection() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Connection: handle is closed")
	}
	cConn := C.MeasurementContext_connection(C.MeasurementContextHandle(h.chandle))
	return connection.FromCAPI(unsafe.Pointer(cConn))
}

func (h *Handle) InstrumentType() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("InstrumentType: handle is closed")
	}
	cStr := C.MeasurementContext_instrument_type(C.MeasurementContextHandle(h.chandle))
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
	return bool(C.MeasurementContext_equal(C.MeasurementContextHandle(h.chandle), C.MeasurementContextHandle(other.chandle))), nil
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
	return bool(C.MeasurementContext_not_equal(C.MeasurementContextHandle(h.chandle), C.MeasurementContextHandle(other.chandle))), nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.MeasurementContext_to_json_string(C.MeasurementContextHandle(h.chandle))
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
	h := chandle(C.MeasurementContext_from_json_string(C.StringHandle(strPtr)))
	return new(h), nil
}
