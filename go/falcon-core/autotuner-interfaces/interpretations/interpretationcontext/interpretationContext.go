package interpretationcontext

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/contexts/MeasurementContext_c_api.h>
#include <falcon_core/generic/ListMeasurementContext_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/AxesMeasurementContext_c_api.h>
#include <falcon_core/physics/units/SymbolUnit_c_api.h>
#include <falcon_core/autotuner_interfaces/interpretations/InterpretationContext_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/measurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmeasurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

type chandle C.InterpretationContextHandle

type Handle struct {
	chandle      chandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func new(h chandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
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
	C.InterpretationContext_destroy(C.InterpretationContextHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	h.closed = true
	h.chandle = nil
	return nil
}

func New(indep *axesmeasurementcontext.Handle, dep *listmeasurementcontext.Handle, unit *symbolunit.Handle) (*Handle, error) {
	indepPtr, err := indep.CAPIHandle()
	if err != nil {
		return nil, err
	}
	depPtr, err := dep.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitPtr, err := unit.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.InterpretationContext_create(
		C.AxesMeasurementContextHandle(indepPtr),
		C.ListMeasurementContextHandle(depPtr),
		C.SymbolUnitHandle(unitPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) IndependentVariables() (*axesmeasurementcontext.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("IndependentVariables: handle is closed")
	}
	cAxes := C.InterpretationContext_independent_variables(C.InterpretationContextHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return axesmeasurementcontext.FromCAPI(unsafe.Pointer(cAxes))
}

func (h *Handle) DependentVariables() (*listmeasurementcontext.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DependentVariables: handle is closed")
	}
	cList := C.InterpretationContext_dependent_variables(C.InterpretationContextHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listmeasurementcontext.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Unit() (*symbolunit.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Unit: handle is closed")
	}
	cUnit := C.InterpretationContext_unit(C.InterpretationContextHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return symbolunit.FromCAPI(unsafe.Pointer(cUnit))
}

func (h *Handle) Dimension() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Dimension: handle is closed")
	}
	val := int(C.InterpretationContext_dimension(C.InterpretationContextHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) AddDependentVariable(variable *measurementcontext.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("AddDependentVariable: handle is closed")
	}
	varPtr, err := variable.CAPIHandle()
	if err != nil {
		return err
	}
	C.InterpretationContext_dependent_variable(C.InterpretationContextHandle(h.chandle), C.MeasurementContextHandle(varPtr))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) ReplaceDependentVariable(index int, variable *measurementcontext.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("ReplaceDependentVariable: handle is closed")
	}
	varPtr, err := variable.CAPIHandle()
	if err != nil {
		return err
	}
	C.InterpretationContext_replace_dependent_variable(C.InterpretationContextHandle(h.chandle), C.int(index), C.MeasurementContextHandle(varPtr))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) GetIndependentVariable(index int) (*measurementcontext.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("GetIndependentVariable: handle is closed")
	}
	cVar := C.InterpretationContext_get_independent_variables(C.InterpretationContextHandle(h.chandle), C.int(index))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return measurementcontext.FromCAPI(unsafe.Pointer(cVar))
}

func (h *Handle) WithUnit(unit *symbolunit.Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("WithUnit: handle is closed")
	}
	unitPtr, err := unit.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.InterpretationContext_with_unit(C.InterpretationContextHandle(h.chandle), C.SymbolUnitHandle(unitPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
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
	val := bool(C.InterpretationContext_equal(C.InterpretationContextHandle(h.chandle), C.InterpretationContextHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
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
	val := bool(C.InterpretationContext_not_equal(C.InterpretationContextHandle(h.chandle), C.InterpretationContextHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.InterpretationContext_to_json_string(C.InterpretationContextHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return "", err
	}
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
	h := chandle(C.InterpretationContext_from_json_string(C.StringHandle(strPtr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
