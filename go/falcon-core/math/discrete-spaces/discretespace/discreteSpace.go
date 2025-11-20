package discretespace

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/instrument_interfaces/names/InstrumentPort_c_api.h>
#include <falcon_core/math/AxesCoupledLabelledDomain_c_api.h>
#include <falcon_core/math/AxesInstrumentPort_c_api.h>
#include <falcon_core/math/AxesLabelledControlArray_c_api.h>
#include <falcon_core/math/AxesMapStringBool_c_api.h>
#include <falcon_core/math/UnitSpace_c_api.h>
#include <falcon_core/math/domains/CoupledLabelledDomain_c_api.h>
#include <falcon_core/math/discrete_spaces/DiscreteSpace_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesinstrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axeslabelledcontrolarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/unitspace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type discreteSpaceHandle C.DiscreteSpaceHandle

type Handle struct {
	chandle      discreteSpaceHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func new(h discreteSpaceHandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(handle, func(_ any) { handle.Close() }, true)
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(discreteSpaceHandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[discreteSpaceHandle]() {
		C.DiscreteSpace_destroy(C.DiscreteSpaceHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[discreteSpaceHandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

func New(space *unitspace.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle) (*Handle, error) {
	spacePtr, err := space.CAPIHandle()
	if err != nil {
		return nil, err
	}
	axesPtr, err := axes.CAPIHandle()
	if err != nil {
		return nil, err
	}
	incrPtr, err := increasing.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := discreteSpaceHandle(C.DiscreteSpace_create(
		C.UnitSpaceHandle(spacePtr),
		C.AxesCoupledLabelledDomainHandle(axesPtr),
		C.AxesMapStringBoolHandle(incrPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewCartesian(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, dom *domain.Handle) (*Handle, error) {
	divPtr, err := divisions.CAPIHandle()
	if err != nil {
		return nil, err
	}
	axesPtr, err := axes.CAPIHandle()
	if err != nil {
		return nil, err
	}
	incrPtr, err := increasing.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := discreteSpaceHandle(C.DiscreteSpace_create_cartesiandiscretespace(
		C.AxesIntHandle(divPtr),
		C.AxesCoupledLabelledDomainHandle(axesPtr),
		C.AxesMapStringBoolHandle(incrPtr),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewCartesian1D(division int, sharedDomain *coupledlabelleddomain.Handle, increasing *mapstringbool.Handle, dom *domain.Handle) (*Handle, error) {
	sharedPtr, err := sharedDomain.CAPIHandle()
	if err != nil {
		return nil, err
	}
	incrPtr, err := increasing.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := discreteSpaceHandle(C.DiscreteSpace_create_cartesiandiscretespace1D(
		C.int(division),
		C.CoupledLabelledDomainHandle(sharedPtr),
		C.MapStringBoolHandle(incrPtr),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Space() (*unitspace.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return nil, errors.New("Space: handle is closed")
	}
	cSpace := C.DiscreteSpace_space(C.DiscreteSpaceHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return unitspace.FromCAPI(unsafe.Pointer(cSpace))
}

func (h *Handle) Axes() (*axescoupledlabelleddomain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return nil, errors.New("Axes: handle is closed")
	}
	cAxes := C.DiscreteSpace_axes(C.DiscreteSpaceHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return axescoupledlabelleddomain.FromCAPI(unsafe.Pointer(cAxes))
}

func (h *Handle) Increasing() (*axesmapstringbool.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return nil, errors.New("Increasing: handle is closed")
	}
	cInc := C.DiscreteSpace_increasing(C.DiscreteSpaceHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return axesmapstringbool.FromCAPI(unsafe.Pointer(cInc))
}

func (h *Handle) Knobs() (*ports.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return nil, errors.New("Knobs: handle is closed")
	}
	cKnobs := C.DiscreteSpace_knobs(C.DiscreteSpaceHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return ports.FromCAPI(unsafe.Pointer(cKnobs))
}

func (h *Handle) ValidateUnitSpaceDimensionalityMatchesKnobs() error {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return errors.New("ValidateUnitSpaceDimensionalityMatchesKnobs: handle is closed")
	}
	C.DiscreteSpace_validate_unit_space_dimensionality_matches_knobs(C.DiscreteSpaceHandle(h.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) ValidateKnobUniqueness() error {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return errors.New("ValidateKnobUniqueness: handle is closed")
	}
	C.DiscreteSpace_validate_knob_uniqueness(C.DiscreteSpaceHandle(h.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) GetAxis(knob *ports.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return 0, errors.New("GetAxis: handle is closed")
	}
	if knob == nil {
		return 0, errors.New("GetAxis: the knob is null")
	}
	knobPtr, err := knob.CAPIHandle()
	if err != nil {
		return 0, err
	}
	val := int(C.DiscreteSpace_get_axis(C.DiscreteSpaceHandle(h.chandle), C.InstrumentPortHandle(knobPtr)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return 0, capiErr
	}
	return val, nil
}

func (h *Handle) GetDomain(knob *ports.Handle) (*domain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return nil, errors.New("GetDomain: handle is closed")
	}
	if knob == nil {
		return nil, errors.New("GetAxis: the knob is null")
	}
	knobPtr, err := knob.CAPIHandle()
	if err != nil {
		return nil, err
	}
	cDom := C.DiscreteSpace_get_domain(C.DiscreteSpaceHandle(h.chandle), C.InstrumentPortHandle(knobPtr))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return domain.FromCAPI(unsafe.Pointer(cDom))
}

func (h *Handle) GetProjection(projection *axesinstrumentport.Handle) (*axeslabelledcontrolarray.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return nil, errors.New("GetProjection: handle is closed")
	}
	if projection == nil {
		return nil, errors.New("GetProjection: projection is null")
	}
	projPtr, err := projection.CAPIHandle()
	if err != nil {
		return nil, err
	}
	cProj := C.DiscreteSpace_get_projection(C.DiscreteSpaceHandle(h.chandle), C.AxesInstrumentPortHandle(projPtr))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return axeslabelledcontrolarray.FromCAPI(unsafe.Pointer(cProj))
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.DiscreteSpace_equal(C.DiscreteSpaceHandle(h.chandle), C.DiscreteSpaceHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.DiscreteSpace_not_equal(C.DiscreteSpaceHandle(h.chandle), C.DiscreteSpaceHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[discreteSpaceHandle]() {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.DiscreteSpace_to_json_string(C.DiscreteSpaceHandle(h.chandle))
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
	realJSON := str.New(json)
	defer realJSON.Close()
	capistr, err := realJSON.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := discreteSpaceHandle(C.DiscreteSpace_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
