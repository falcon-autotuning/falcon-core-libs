package unitspace

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/FArrayDouble_c_api.h>
#include <falcon_core/generic/ListInt_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/AxesControlArray_c_api.h>
#include <falcon_core/math/AxesDiscretizer_c_api.h>
#include <falcon_core/math/AxesDouble_c_api.h>
#include <falcon_core/math/AxesInt_c_api.h>
#include <falcon_core/math/discrete_spaces/Discretizer_c_api.h>
#include <falcon_core/math/UnitSpace_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescontrolarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdiscretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type unitSpaceHandle C.UnitSpaceHandle

type Handle struct {
	chandle      unitSpaceHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func new(h unitSpaceHandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(handle, func(_ any) { handle.Close() }, true)
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(unitSpaceHandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[unitSpaceHandle]() {
		C.UnitSpace_destroy(C.UnitSpaceHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[unitSpaceHandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

func New(axes *axesdiscretizer.Handle, dom *domain.Handle) (*Handle, error) {
	axesPtr, err := axes.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := unitSpaceHandle(C.UnitSpace_create(
		C.AxesDiscretizerHandle(axesPtr),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewRaySpace(dr, dtheta float64, dom *domain.Handle) (*Handle, error) {
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := unitSpaceHandle(C.UnitSpace_create_rayspace(
		C.double(dr),
		C.double(dtheta),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewCartesianSpace(deltas *axesdouble.Handle, dom *domain.Handle) (*Handle, error) {
	deltasPtr, err := deltas.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := unitSpaceHandle(C.UnitSpace_create_cartesianspace(
		C.AxesDoubleHandle(deltasPtr),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewCartesian1DSpace(delta float64, dom *domain.Handle) (*Handle, error) {
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := unitSpaceHandle(C.UnitSpace_create_cartesian1Dspace(
		C.double(delta),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewCartesian2DSpace(deltas *axesdouble.Handle, dom *domain.Handle) (*Handle, error) {
	deltasPtr, err := deltas.CAPIHandle()
	if err != nil {
		return nil, err
	}
	domPtr, err := dom.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := unitSpaceHandle(C.UnitSpace_create_cartesian2Dspace(
		C.AxesDoubleHandle(deltasPtr),
		C.DomainHandle(domPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Axes() (*axesdiscretizer.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("Axes: handle is closed")
	}
	cAxes := C.UnitSpace_axes(C.UnitSpaceHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return axesdiscretizer.FromCAPI(unsafe.Pointer(cAxes))
}

func (h *Handle) Domain() (*domain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("Domain: handle is closed")
	}
	cDom := C.UnitSpace_domain(C.UnitSpaceHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return domain.FromCAPI(unsafe.Pointer(cDom))
}

func (h *Handle) Space() (*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("Space: handle is closed")
	}
	cSpace := C.UnitSpace_space(C.UnitSpaceHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return farraydouble.FromCAPI(unsafe.Pointer(cSpace))
}

func (h *Handle) Shape() (*listint.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("Shape: handle is closed")
	}
	cShape := C.UnitSpace_shape(C.UnitSpaceHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listint.FromCAPI(unsafe.Pointer(cShape))
}

func (h *Handle) Dimension() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return 0, errors.New("Dimension: handle is closed")
	}
	val := int(C.UnitSpace_dimension(C.UnitSpaceHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Compile() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return errors.New("Compile: handle is closed")
	}
	C.UnitSpace_compile(C.UnitSpaceHandle(h.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) CreateArray(axes *axesint.Handle) (*axescontrolarray.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("CreateArray: handle is closed")
	}
	axesPtr, err := axes.CAPIHandle()
	if err != nil {
		return nil, err
	}
	cArr := C.UnitSpace_create_array(C.UnitSpaceHandle(h.chandle), C.AxesIntHandle(axesPtr))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return axescontrolarray.FromCAPI(unsafe.Pointer(cArr))
}

func (h *Handle) PushBack(value *discretizer.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return errors.New("PushBack: handle is closed")
	}
	valPtr, err := value.CAPIHandle()
	if err != nil {
		return err
	}
	C.UnitSpace_push_back(C.UnitSpaceHandle(h.chandle), C.DiscretizerHandle(valPtr))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return 0, errors.New("Size: handle is closed")
	}
	val := int(C.UnitSpace_size(C.UnitSpaceHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return false, errors.New("Empty: handle is closed")
	}
	val := bool(C.UnitSpace_empty(C.UnitSpaceHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return errors.New("EraseAt: handle is closed")
	}
	C.UnitSpace_erase_at(C.UnitSpaceHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return errors.New("Clear: handle is closed")
	}
	C.UnitSpace_clear(C.UnitSpaceHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) At(idx int) (*discretizer.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("At: handle is closed")
	}
	cVal := C.UnitSpace_at(C.UnitSpaceHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return discretizer.FromCAPI(unsafe.Pointer(cVal))
}

func (h *Handle) Items() ([]*discretizer.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("Items: handle is closed")
	}
	size, err := h.Size()
	if err != nil {
		return nil, err
	}
	if size == 0 {
		return nil, nil
	}
	out := make([]C.DiscretizerHandle, size)
	C.UnitSpace_items(C.UnitSpaceHandle(h.chandle), &out[0], C.size_t(size))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	res := make([]*discretizer.Handle, size)
	for i := range out {
		res[i], err = discretizer.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, err
		}
	}
	return res, nil
}

func (h *Handle) Contains(value *discretizer.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return false, errors.New("Contains: handle is closed")
	}
	valPtr, err := value.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.UnitSpace_contains(C.UnitSpaceHandle(h.chandle), C.DiscretizerHandle(valPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Index(value *discretizer.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return 0, errors.New("Index: handle is closed")
	}
	valPtr, err := value.CAPIHandle()
	if err != nil {
		return 0, err
	}
	val := int(C.UnitSpace_index(C.UnitSpaceHandle(h.chandle), C.DiscretizerHandle(valPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("Intersection: handle is closed")
	}
	if other == nil {
		return nil, errors.New("Intersection: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[unitSpaceHandle]() {
		return nil, errors.New("Intersection: other is closed")
	}
	res := unitSpaceHandle(C.UnitSpace_intersection(C.UnitSpaceHandle(h.chandle), C.UnitSpaceHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[unitSpaceHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.UnitSpace_equal(C.UnitSpaceHandle(h.chandle), C.UnitSpaceHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[unitSpaceHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.UnitSpace_not_equal(C.UnitSpaceHandle(h.chandle), C.UnitSpaceHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[unitSpaceHandle]() {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.UnitSpace_to_json_string(C.UnitSpaceHandle(h.chandle))
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
	h := unitSpaceHandle(C.UnitSpace_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
