package waveform

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListPortTransform_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/instrument_interfaces/port_transforms/PortTransform_c_api.h>
#include <falcon_core/math/AxesCoupledLabelledDomain_c_api.h>
#include <falcon_core/math/AxesInt_c_api.h>
#include <falcon_core/math/AxesMapStringBool_c_api.h>
#include <falcon_core/math/discrete_spaces/DiscreteSpace_c_api.h>
#include <falcon_core/instrument_interfaces/Waveform_c_api.h>
#include <falcon_core/math/domains/Domain_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretespace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type waveformHandle C.WaveformHandle

type Handle struct {
	chandle      waveformHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func new(h waveformHandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(handle, func(_ any) { handle.Close() }, true)
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(waveformHandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[waveformHandle]() {
		C.Waveform_destroy(C.WaveformHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[waveformHandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

// Constructors

func New(space *discretespace.Handle, transforms *listporttransform.Handle) (*Handle, error) {
	spacePtr, err := space.CAPIHandle()
	if err != nil {
		return nil, err
	}
	transPtr, err := transforms.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := waveformHandle(C.Waveform_create(
		C.DiscreteSpaceHandle(spacePtr),
		C.ListPortTransformHandle(transPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewCartesian(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, transforms *listporttransform.Handle, dom *domain.Handle) (*Handle, error) {
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
	transPtr, err := transforms.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := waveformHandle(C.Waveform_create_cartesianwaveform(
		C.AxesIntHandle(divPtr),
		C.AxesCoupledLabelledDomainHandle(axesPtr),
		C.AxesMapStringBoolHandle(incrPtr),
		C.ListPortTransformHandle(transPtr),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewCartesianIdentity(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, dom *domain.Handle) (*Handle, error) {
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
	h := waveformHandle(C.Waveform_create_cartesianidentitywaveform(
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

func NewCartesian2D(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, transforms *listporttransform.Handle, dom *domain.Handle) (*Handle, error) {
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
	transPtr, err := transforms.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := waveformHandle(C.Waveform_create_cartesianwaveform2D(
		C.AxesIntHandle(divPtr),
		C.AxesCoupledLabelledDomainHandle(axesPtr),
		C.AxesMapStringBoolHandle(incrPtr),
		C.ListPortTransformHandle(transPtr),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewCartesianIdentity2D(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, dom *domain.Handle) (*Handle, error) {
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
	h := waveformHandle(C.Waveform_create_cartesianidentitywaveform2D(
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

func NewCartesian1D(division int, sharedDomain *coupledlabelleddomain.Handle, increasing *mapstringbool.Handle, transforms *listporttransform.Handle, dom *domain.Handle) (*Handle, error) {
	sharedPtr, err := sharedDomain.CAPIHandle()
	if err != nil {
		return nil, err
	}
	incrPtr, err := increasing.CAPIHandle()
	if err != nil {
		return nil, err
	}
	transPtr, err := transforms.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := waveformHandle(C.Waveform_create_cartesianwaveform1D(
		C.int(division),
		C.CoupledLabelledDomainHandle(sharedPtr),
		C.MapStringBoolHandle(incrPtr),
		C.ListPortTransformHandle(transPtr),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewCartesianIdentity1D(division int, sharedDomain *coupledlabelleddomain.Handle, increasing *mapstringbool.Handle, dom *domain.Handle) (*Handle, error) {
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
	h := waveformHandle(C.Waveform_create_cartesianidentitywaveform1D(
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

// Methods

func (h *Handle) Space() (*discretespace.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return nil, errors.New("Space: handle is closed")
	}
	cSpace := C.Waveform_space(C.WaveformHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return discretespace.FromCAPI(unsafe.Pointer(cSpace))
}

func (h *Handle) Transforms() (*listporttransform.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return nil, errors.New("Transforms: handle is closed")
	}
	cList := C.Waveform_transforms(C.WaveformHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listporttransform.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) PushBack(value *porttransform.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return errors.New("PushBack: handle is closed")
	}
	if value == nil {
		return errors.New("PushBack: value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("PushBack failed to get CAPI handle for value"), err)
	}
	C.Waveform_push_back(C.WaveformHandle(h.chandle), C.PortTransformHandle(capi))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return 0, errors.New("Size: handle is closed")
	}
	val := int(C.Waveform_size(C.WaveformHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return false, errors.New("Empty: handle is closed")
	}
	val := bool(C.Waveform_empty(C.WaveformHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return errors.New("EraseAt: handle is closed")
	}
	C.Waveform_erase_at(C.WaveformHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return errors.New("Clear: handle is closed")
	}
	C.Waveform_clear(C.WaveformHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) At(idx int) (*porttransform.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return nil, errors.New("At: handle is closed")
	}
	cHandle := unsafe.Pointer(C.Waveform_at(C.WaveformHandle(h.chandle), C.size_t(idx)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return porttransform.FromCAPI(cHandle)
}

func (h *Handle) Items() ([]*porttransform.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return nil, errors.New("Items: handle is closed")
	}
	cList := C.Waveform_items(C.WaveformHandle(h.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	listHandle, err := listporttransform.FromCAPI(unsafe.Pointer(cList))
	if err != nil {
		return nil, err
	}
	defer listHandle.Close()
	return listHandle.Items()
}

func (h *Handle) Contains(value *porttransform.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return false, errors.New("Contains: handle is closed")
	}
	if value == nil {
		return false, errors.New("Contains: value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return false, errors.Join(errors.New("Contains failed to get CAPI handle for value"), err)
	}
	val := bool(C.Waveform_contains(C.WaveformHandle(h.chandle), C.PortTransformHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Index(value *porttransform.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return 0, errors.New("Index: handle is closed")
	}
	if value == nil {
		return 0, errors.New("Index: value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return 0, errors.Join(errors.New("Index failed to get CAPI handle for value"), err)
	}
	val := int(C.Waveform_index(C.WaveformHandle(h.chandle), C.PortTransformHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return nil, errors.New("Intersection: handle is closed")
	}
	if other == nil {
		return nil, errors.New("Intersection: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[waveformHandle]() {
		return nil, errors.New("Intersection: other is closed")
	}
	res := waveformHandle(C.Waveform_intersection(C.WaveformHandle(h.chandle), C.WaveformHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[waveformHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.Waveform_equal(C.WaveformHandle(h.chandle), C.WaveformHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[waveformHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.Waveform_not_equal(C.WaveformHandle(h.chandle), C.WaveformHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[waveformHandle]() {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.Waveform_to_json_string(C.WaveformHandle(h.chandle))
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
	h := waveformHandle(C.Waveform_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
