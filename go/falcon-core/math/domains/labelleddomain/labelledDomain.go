package labelleddomain

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/domains/LabelledDomain_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/instrument_interfaces/names/InstrumentPort_c_api.h>
#include <falcon_core/math/domains/Domain_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

type chandle C.LabelledDomainHandle

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
	C.LabelledDomain_destroy(C.LabelledDomainHandle(h.chandle))
	h.closed = true
	h.chandle = nil
	return nil
}

func NewPrimitiveKnob(defaultName string, minVal, maxVal float64, pseudoName *connection.Handle, instrumentType string, lesserBoundContained, greaterBoundContained bool, units *symbolunit.Handle, description string) (*Handle, error) {
	defNameStr := str.New(defaultName)
	defer defNameStr.Close()
	defNamePtr, err := defNameStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	instTypeStr := str.New(instrumentType)
	defer instTypeStr.Close()
	instTypePtr, err := instTypeStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	descStr := str.New(description)
	defer descStr.Close()
	descPtr, err := descStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	pseudoPtr, err := pseudoName.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitsPtr, err := units.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.LabelledDomain_create_primitive_knob(
		C.StringHandle(defNamePtr),
		C.double(minVal),
		C.double(maxVal),
		C.ConnectionHandle(pseudoPtr),
		C.StringHandle(instTypePtr),
		C.bool(lesserBoundContained),
		C.bool(greaterBoundContained),
		C.SymbolUnitHandle(unitsPtr),
		C.StringHandle(descPtr),
	))
	return new(h), nil
}

func NewPrimitiveMeter(defaultName string, minVal, maxVal float64, pseudoName *connection.Handle, instrumentType string, lesserBoundContained, greaterBoundContained bool, units *symbolunit.Handle, description string) (*Handle, error) {
	defNameStr := str.New(defaultName)
	defer defNameStr.Close()
	defNamePtr, err := defNameStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	instTypeStr := str.New(instrumentType)
	defer instTypeStr.Close()
	instTypePtr, err := instTypeStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	descStr := str.New(description)
	defer descStr.Close()
	descPtr, err := descStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	pseudoPtr, err := pseudoName.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitsPtr, err := units.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.LabelledDomain_create_primitive_meter(
		C.StringHandle(defNamePtr),
		C.double(minVal),
		C.double(maxVal),
		C.ConnectionHandle(pseudoPtr),
		C.StringHandle(instTypePtr),
		C.bool(lesserBoundContained),
		C.bool(greaterBoundContained),
		C.SymbolUnitHandle(unitsPtr),
		C.StringHandle(descPtr),
	))
	return new(h), nil
}

func NewPrimitivePort(defaultName string, minVal, maxVal float64, pseudoName *connection.Handle, instrumentType string, lesserBoundContained, greaterBoundContained bool, units *symbolunit.Handle, description string) (*Handle, error) {
	defNameStr := str.New(defaultName)
	defer defNameStr.Close()
	defNamePtr, err := defNameStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	instTypeStr := str.New(instrumentType)
	defer instTypeStr.Close()
	instTypePtr, err := instTypeStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	descStr := str.New(description)
	defer descStr.Close()
	descPtr, err := descStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	pseudoPtr, err := pseudoName.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitsPtr, err := units.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.LabelledDomain_create_primitive_port(
		C.StringHandle(defNamePtr),
		C.double(minVal),
		C.double(maxVal),
		C.ConnectionHandle(pseudoPtr),
		C.StringHandle(instTypePtr),
		C.bool(lesserBoundContained),
		C.bool(greaterBoundContained),
		C.SymbolUnitHandle(unitsPtr),
		C.StringHandle(descPtr),
	))
	return new(h), nil
}

func NewFromPort(minVal, maxVal float64, instrumentType string, port *instrumentport.Handle, lesserBoundContained, greaterBoundContained bool) (*Handle, error) {
	instTypeStr := str.New(instrumentType)
	defer instTypeStr.Close()
	instTypePtr, err := instTypeStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	portPtr, err := port.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.LabelledDomain_create_from_port(
		C.double(minVal),
		C.double(maxVal),
		C.StringHandle(instTypePtr),
		C.InstrumentPortHandle(portPtr),
		C.bool(lesserBoundContained),
		C.bool(greaterBoundContained),
	))
	return new(h), nil
}

func NewFromPortAndDomain(port *instrumentport.Handle, dom *domain.Handle) (*Handle, error) {
	portPtr, err := port.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.LabelledDomain_create_from_port_and_domain(
		C.InstrumentPortHandle(portPtr),
		C.DomainHandle(domPtr),
	))
	return new(h), nil
}

func NewFromDomain(dom *domain.Handle, defaultName string, pseudoName *connection.Handle, instrumentType string, units *symbolunit.Handle, description string) (*Handle, error) {
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	defNameStr := str.New(defaultName)
	defer defNameStr.Close()
	defNamePtr, err := defNameStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	pseudoPtr, err := pseudoName.CAPIHandle()
	if err != nil {
		return nil, err
	}
	instTypeStr := str.New(instrumentType)
	defer instTypeStr.Close()
	instTypePtr, err := instTypeStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitsPtr, err := units.CAPIHandle()
	if err != nil {
		return nil, err
	}
	descStr := str.New(description)
	defer descStr.Close()
	descPtr, err := descStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.LabelledDomain_create_from_domain(
		C.DomainHandle(domPtr),
		C.StringHandle(defNamePtr),
		C.ConnectionHandle(pseudoPtr),
		C.StringHandle(instTypePtr),
		C.SymbolUnitHandle(unitsPtr),
		C.StringHandle(descPtr),
	))
	return new(h), nil
}

func (h *Handle) Port() (*instrumentport.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Port: handle is closed")
	}
	cPort := C.LabelledDomain_port(C.LabelledDomainHandle(h.chandle))
	return instrumentport.FromCAPI(unsafe.Pointer(cPort))
}

func (h *Handle) Domain() (*domain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Domain: handle is closed")
	}
	cDom := C.LabelledDomain_domain(C.LabelledDomainHandle(h.chandle))
	return domain.FromCAPI(unsafe.Pointer(cDom))
}

func (h *Handle) MatchingPort(port *instrumentport.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("MatchingPort: handle is closed")
	}
	portPtr, err := port.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.LabelledDomain_matching_port(C.LabelledDomainHandle(h.chandle), C.InstrumentPortHandle(portPtr)))
	return val, nil
}

func (h *Handle) LesserBound() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("LesserBound: handle is closed")
	}
	val := float64(C.LabelledDomain_lesser_bound(C.LabelledDomainHandle(h.chandle)))
	return val, nil
}

func (h *Handle) GreaterBound() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("GreaterBound: handle is closed")
	}
	val := float64(C.LabelledDomain_greater_bound(C.LabelledDomainHandle(h.chandle)))
	return val, nil
}

func (h *Handle) LesserBoundContained() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("LesserBoundContained: handle is closed")
	}
	val := bool(C.LabelledDomain_lesser_bound_contained(C.LabelledDomainHandle(h.chandle)))
	return val, nil
}

func (h *Handle) GreaterBoundContained() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("GreaterBoundContained: handle is closed")
	}
	val := bool(C.LabelledDomain_greater_bound_contained(C.LabelledDomainHandle(h.chandle)))
	return val, nil
}

func (h *Handle) In(value float64) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("In: handle is closed")
	}
	val := bool(C.LabelledDomain_in(C.LabelledDomainHandle(h.chandle), C.double(value)))
	return val, nil
}

func (h *Handle) Range() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Range: handle is closed")
	}
	val := float64(C.LabelledDomain_range(C.LabelledDomainHandle(h.chandle)))
	return val, nil
}

func (h *Handle) Center() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Center: handle is closed")
	}
	val := float64(C.LabelledDomain_center(C.LabelledDomainHandle(h.chandle)))
	return val, nil
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Intersection: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("Intersection: other handle is closed or nil")
	}
	res := chandle(C.LabelledDomain_intersection(C.LabelledDomainHandle(h.chandle), C.LabelledDomainHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) Union(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Union: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("Union: other handle is closed or nil")
	}
	res := chandle(C.LabelledDomain_union(C.LabelledDomainHandle(h.chandle), C.LabelledDomainHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) IsEmpty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("IsEmpty: handle is closed")
	}
	val := bool(C.LabelledDomain_is_empty(C.LabelledDomainHandle(h.chandle)))
	return val, nil
}

func (h *Handle) ContainsDomain(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("ContainsDomain: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return false, errors.New("ContainsDomain: other handle is closed or nil")
	}
	val := bool(C.LabelledDomain_contains_domain(C.LabelledDomainHandle(h.chandle), C.LabelledDomainHandle(other.chandle)))
	return val, nil
}

func (h *Handle) Shift(offset float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Shift: handle is closed")
	}
	res := chandle(C.LabelledDomain_shift(C.LabelledDomainHandle(h.chandle), C.double(offset)))
	return new(res), nil
}

func (h *Handle) Scale(scale float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Scale: handle is closed")
	}
	res := chandle(C.LabelledDomain_scale(C.LabelledDomainHandle(h.chandle), C.double(scale)))
	return new(res), nil
}

func (h *Handle) Transform(other *Handle, value float64) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Transform: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return 0, errors.New("Transform: other handle is closed or nil")
	}
	val := float64(C.LabelledDomain_transform(C.LabelledDomainHandle(h.chandle), C.LabelledDomainHandle(other.chandle), C.double(value)))
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
	val := bool(C.LabelledDomain_equal(C.LabelledDomainHandle(h.chandle), C.LabelledDomainHandle(other.chandle)))
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
	val := bool(C.LabelledDomain_not_equal(C.LabelledDomainHandle(h.chandle), C.LabelledDomainHandle(other.chandle)))
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.LabelledDomain_to_json_string(C.LabelledDomainHandle(h.chandle))
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
	h := chandle(C.LabelledDomain_from_json_string(C.StringHandle(strPtr)))
	return new(h), nil
}
