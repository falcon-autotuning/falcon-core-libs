package acquisitioncontext

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/contexts/AcquisitionContext_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/instrument_interfaces/names/InstrumentPort_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/physics/units/SymbolUnit_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

type chandle C.AcquisitionContextHandle

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
	C.AcquisitionContext_destroy(C.AcquisitionContextHandle(h.chandle))
	h.closed = true
	h.chandle = nil
	return nil
}

func New(connection *connection.Handle, instrumentType string, units *symbolunit.Handle) (*Handle, error) {
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
	unitsPtr, err := units.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.AcquisitionContext_create(
		C.ConnectionHandle(connPtr),
		C.StringHandle(strPtr),
		C.SymbolUnitHandle(unitsPtr),
	))
	return new(h), nil
}

func NewFromPort(port *instrumentport.Handle) (*Handle, error) {
	portPtr, err := port.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.AcquisitionContext_create_from_port(C.InstrumentPortHandle(portPtr)))
	return new(h), nil
}

func (h *Handle) Connection() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Connection: handle is closed")
	}
	cConn := C.AcquisitionContext_connection(C.AcquisitionContextHandle(h.chandle))
	return connection.FromCAPI(unsafe.Pointer(cConn))
}

func (h *Handle) InstrumentType() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("InstrumentType: handle is closed")
	}
	cStr := C.AcquisitionContext_instrument_type(C.AcquisitionContextHandle(h.chandle))
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func (h *Handle) Units() (*symbolunit.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Units: handle is closed")
	}
	cUnits := C.AcquisitionContext_units(C.AcquisitionContextHandle(h.chandle))
	return symbolunit.FromCAPI(unsafe.Pointer(cUnits))
}

func (h *Handle) DivisionUnit(other *symbolunit.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DivisionUnit: handle is closed")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.AcquisitionContext_division_unit(C.AcquisitionContextHandle(h.chandle), C.SymbolUnitHandle(otherPtr)))
	return new(res), nil
}

func (h *Handle) Division(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Division: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("Division: other handle is closed or nil")
	}
	res := chandle(C.AcquisitionContext_division(C.AcquisitionContextHandle(h.chandle), C.AcquisitionContextHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) MatchConnection(other *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("MatchConnection: handle is closed")
	}
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.AcquisitionContext_match_connection(C.AcquisitionContextHandle(h.chandle), C.ConnectionHandle(otherPtr)))
	return val, nil
}

func (h *Handle) MatchInstrumentType(other string) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("MatchInstrumentType: handle is closed")
	}
	otherStr := str.New(other)
	defer otherStr.Close()
	otherPtr, err := otherStr.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.AcquisitionContext_match_instrument_type(C.AcquisitionContextHandle(h.chandle), C.StringHandle(otherPtr)))
	return val, nil
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
	val := bool(C.AcquisitionContext_equal(C.AcquisitionContextHandle(h.chandle), C.AcquisitionContextHandle(other.chandle)))
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
	val := bool(C.AcquisitionContext_not_equal(C.AcquisitionContextHandle(h.chandle), C.AcquisitionContextHandle(other.chandle)))
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.AcquisitionContext_to_json_string(C.AcquisitionContextHandle(h.chandle))
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
	h := chandle(C.AcquisitionContext_from_json_string(C.StringHandle(strPtr)))
	return new(h), nil
}
