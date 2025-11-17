package impedances

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListImpedance_c_api.h>
#include <falcon_core/physics/device_structures/Impedance_c_api.h>
#include <falcon_core/physics/device_structures/Impedances_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorHandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listImpedance"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/impedance"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type impedancesHandle C.ImpedancesHandle

type Handle struct {
	chandle      impedancesHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorHandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle impedancesHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorHandling.ErrorHandler}
	runtime.AddCleanup(obj, func(_ any) { obj.Close() }, true)
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI The pointer is null")
	}
	return new(impedancesHandle(p)), nil
}

func NewEmpty() (*Handle, error) {
	h := impedancesHandle(C.Impedances_create_empty())
	err := errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func CreateFromList(items *listImpedance.Handle) (*Handle, error) {
	if items == nil {
		return nil, errors.New("New failed: items is nil")
	}
	capi, err := items.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New failed: could not get CAPI handle for items"), err)
	}
	h := impedancesHandle(C.Impedances_create(C.ListImpedanceHandle(capi)))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func New(items []*impedance.Handle) (*Handle, error) {
	list, err := listImpedance.New(items)
	if err != nil {
		return nil, errors.Join(errors.New(`construction of list of impedance failed`), err)
	}
	return CreateFromList(list)
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[impedancesHandle]() {
		C.Impedances_destroy(C.ImpedancesHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[impedancesHandle]()
		return nil
	}
	return errors.New("unable to close the Impedances")
}

func (h *Handle) PushBack(value *impedance.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return errors.New("PushBack The object is closed")
	}
	if value == nil {
		return errors.New("PushBack value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("PushBack failed to get CAPI handle for value"), err)
	}
	C.Impedances_push_back(C.ImpedancesHandle(h.chandle), C.ImpedanceHandle(capi))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return 0, errors.New("Size The object is closed")
	}
	val := int(C.Impedances_size(C.ImpedancesHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return false, errors.New("Empty The object is closed")
	}
	val := bool(C.Impedances_empty(C.ImpedancesHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return errors.New("EraseAt The object is closed")
	}
	C.Impedances_erase_at(C.ImpedancesHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return errors.New("Clear The object is closed")
	}
	C.Impedances_clear(C.ImpedancesHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) ConstAt(idx int) (*impedance.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return nil, errors.New("ConstAt The object is closed")
	}
	cHandle := unsafe.Pointer(C.Impedances_const_at(C.ImpedancesHandle(h.chandle), C.size_t(idx)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return impedance.FromCAPI(cHandle)
}

func (h *Handle) At(idx int) (*impedance.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return nil, errors.New("At The object is closed")
	}
	cHandle := unsafe.Pointer(C.Impedances_at(C.ImpedancesHandle(h.chandle), C.size_t(idx)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return impedance.FromCAPI(cHandle)
}

func (h *Handle) Items() ([]*impedance.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return nil, errors.New("Items The object is closed")
	}
	size, err := h.Size()
	if err != nil {
		return nil, err
	}
	if size == 0 {
		return []*impedance.Handle{}, nil
	}
	out := make([]C.ImpedanceHandle, size)
	C.Impedances_items(C.ImpedancesHandle(h.chandle), &out[0], C.size_t(size))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	result := make([]*impedance.Handle, size)
	for i := range out {
		goHandle, err := impedance.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, err
		}
		result[i] = goHandle
	}
	return result, nil
}

func (h *Handle) Contains(value *impedance.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return false, errors.New("Contains The object is closed")
	}
	if value == nil {
		return false, errors.New("Contains value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return false, errors.Join(errors.New("Contains failed to get CAPI handle for value"), err)
	}
	val := bool(C.Impedances_contains(C.ImpedancesHandle(h.chandle), C.ImpedanceHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return nil, errors.New("Intersection The object is closed")
	}
	if other == nil {
		return nil, errors.New("Intersection The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[impedancesHandle]() {
		return nil, errors.New("Intersection The other object is closed")
	}
	res := impedancesHandle(C.Impedances_intersection(C.ImpedancesHandle(h.chandle), C.ImpedancesHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) Index(value *impedance.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return 0, errors.New("Index The object is closed")
	}
	if value == nil {
		return 0, errors.New("Index value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return 0, errors.Join(errors.New("Index failed to get CAPI handle for value"), err)
	}
	val := int(C.Impedances_index(C.ImpedancesHandle(h.chandle), C.ImpedanceHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return false, errors.New("Equal The object is closed")
	}
	if other == nil {
		return false, errors.New("Equal The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[impedancesHandle]() {
		return false, errors.New("Equal The other object is closed")
	}
	val := bool(C.Impedances_equal(C.ImpedancesHandle(h.chandle), C.ImpedancesHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return false, errors.New("NotEqual The object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[impedancesHandle]() {
		return false, errors.New("NotEqual The other object is closed")
	}
	val := bool(C.Impedances_not_equal(C.ImpedancesHandle(h.chandle), C.ImpedancesHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[impedancesHandle]() {
		return "", errors.New("ToJSON The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Impedances_to_json_string(C.ImpedancesHandle(h.chandle))))
	if err != nil {
		return "", errors.New("ToJSON could not convert to a String. " + err.Error())
	}
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func FromJSON(json string) (*Handle, error) {
	realJSON := str.New(json)
	defer realJSON.Close()
	capistr, err := realJSON.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("failed to access capi for json"), err)
	}
	h := impedancesHandle(C.Impedances_from_json_string(C.StringHandle(capistr)))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
