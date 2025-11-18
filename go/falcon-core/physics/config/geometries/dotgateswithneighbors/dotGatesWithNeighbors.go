package dotgateswithneighbors

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdotgatewithneighbors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/dotgatewithneighbors"
)

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/geometries/DotGatesWithNeighbors_c_api.h>
#include <falcon_core/generic/ListDotGateWithNeighbors_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

type chandle C.DotGatesWithNeighborsHandle

type Handle struct {
	chandle      chandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("CAPIHandle: DotGatesWithNeighbors is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(h chandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(handle, func(_ any) { handle.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is null")
	}
	return new(chandle(p)), nil
}

func CreateEmpty() (*Handle, error) {
	h := chandle(C.DotGatesWithNeighbors_create_empty())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, errors.Join(errors.New(`unable to create empty dot gate with neighbors`), err)
	}
	return new(h), nil
}

func NewList(items *listdotgatewithneighbors.Handle) (*Handle, error) {
	h := chandle(C.DotGatesWithNeighbors_create(C.ListDotGateWithNeighborsHandle(items)))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, errors.Join(errors.New(`unable to create from list of dot gate with neighbors`), err)
	}
	return new(h), nil
}

func New(items []*dotgatewithneighbors.Handle) (*Handle, error) {
	h, err := listdotgatewithneighbors.New(items)
	if err != nil {
		return nil, errors.Join(errors.New(`unable to create list of dot gate with neighbors`), err)
	}
	return NewList(h)
}

func FromJSON(json string) (*Handle, error) {
	realJSON := str.New(json)
	defer realJSON.Close()
	capistr, err := realJSON.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("failed to access capi for json"), err)
	}
	h := chandle(C.DotGatesWithNeighbors_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != nil {
		C.DotGatesWithNeighbors_destroy(C.DotGatesWithNeighborsHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = nil
		return nil
	}
	return errors.New("unable to close the Handle")
}

func (h *Handle) IsPlungerGates() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.DotGatesWithNeighbors_is_plunger_gates(C.DotGatesWithNeighborsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) IsBarrierGates() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.DotGatesWithNeighbors_is_barrier_gates(C.DotGatesWithNeighborsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return nil, errors.New("Intersection: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := chandle(C.DotGatesWithNeighbors_intersection(C.DotGatesWithNeighborsHandle(h.chandle), C.DotGatesWithNeighborsHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PushBack(value *dotgatewithneighbors.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if value == nil {
		return errors.New(`cannot pushback a null dot gate with neighbors`)
	}
	capivalue, err := value.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New(`PushBack: cannot capture capi handle`), err)
	}
	C.DotGatesWithNeighbors_push_back(C.DotGatesWithNeighborsHandle(h.chandle), C.DotGateWithNeighborsHandle(capivalue))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := int(C.DotGatesWithNeighbors_size(C.DotGatesWithNeighborsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	val := bool(C.DotGatesWithNeighbors_empty(C.DotGatesWithNeighborsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.DotGatesWithNeighbors_erase_at(C.DotGatesWithNeighborsHandle(h.chandle), C.size_t(idx))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	C.DotGatesWithNeighbors_clear(C.DotGatesWithNeighborsHandle(h.chandle))
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) ConstAt(idx int) (*dotgatewithneighbors.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.DotGatesWithNeighbors_const_at(C.DotGatesWithNeighborsHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return dotgatewithneighbors.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) At(idx int) (*dotgatewithneighbors.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.DotGatesWithNeighbors_at(C.DotGatesWithNeighborsHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return dotgatewithneighbors.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Items() (*listdotgatewithneighbors.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	res := C.DotGatesWithNeighbors_items(C.DotGatesWithNeighborsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listdotgatewithneighbors.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Contains(value *dotgatewithneighbors.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if value == nil {
		return false, errors.New(`cannot pushback a null dot gate with neighbors`)
	}
	capivalue, err := value.CAPIHandle()
	if err != nil {
		return false, errors.Join(errors.New(`PushBack: cannot capture capi handle`), err)
	}
	val := bool(C.DotGatesWithNeighbors_contains(C.DotGatesWithNeighborsHandle(h.chandle), C.DotGateWithNeighborsHandle(capivalue)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Index(value *dotgatewithneighbors.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if value == nil {
		return 0, errors.New(`cannot pushback a null dot gate with neighbors`)
	}
	capivalue, err := value.CAPIHandle()
	if err != nil {
		return 0, errors.Join(errors.New(`PushBack: cannot capture capi handle`), err)
	}
	val := int(C.DotGatesWithNeighbors_index(C.DotGatesWithNeighborsHandle(h.chandle), C.DotGateWithNeighborsHandle(capivalue)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.DotGatesWithNeighbors_equal(C.DotGatesWithNeighborsHandle(h.chandle), C.DotGatesWithNeighborsHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	otherPtr, err := other.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.DotGatesWithNeighbors_not_equal(C.DotGatesWithNeighborsHandle(h.chandle), C.DotGatesWithNeighborsHandle(otherPtr)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: DotGatesWithNeighbors is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.DotGatesWithNeighbors_to_json_string(C.DotGatesWithNeighborsHandle(h.chandle))))
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
