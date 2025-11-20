package porttransforms

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListPortTransform_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/instrument_interfaces/port_transforms/PortTransform_c_api.h>
#include <falcon_core/instrument_interfaces/port_transforms/PortTransforms_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
)

type portTransformsHandle C.PortTransformsHandle

type Handle struct {
	chandle      portTransformsHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func new(handle portTransformsHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(obj, func(h *Handle) { h.Close() })
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(portTransformsHandle(p)), nil
}

func NewEmpty() (*Handle, error) {
	h := portTransformsHandle(C.PortTransforms_create_empty())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewFromList(list *listporttransform.Handle) (*Handle, error) {
	if list == nil {
		return nil, errors.New("NewFromList: list is nil")
	}
	capi, err := list.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("NewFromList: could not get CAPI handle for list"), err)
	}
	h := portTransformsHandle(C.PortTransforms_create(C.ListPortTransformHandle(capi)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewRaw(items []*porttransform.Handle) (*Handle, error) {
	if len(items) == 0 {
		return NewEmpty()
	}
	ptrs := make([]C.PortTransformHandle, len(items))
	for i, item := range items {
		capi, err := item.CAPIHandle()
		if err != nil {
			return nil, errors.Join(errors.New("NewRaw: failed to get CAPI handle for item"), err)
		}
		ptrs[i] = C.PortTransformHandle(capi)
	}
	h := portTransformsHandle(C.PortTransforms_create_raw(&ptrs[0], C.size_t(len(ptrs))))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
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
	C.PortTransforms_destroy(C.PortTransformsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	h.closed = true
	h.chandle = nil
	return nil
}

func (h *Handle) Transforms() (*listporttransform.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Transforms: handle is closed")
	}
	cList := C.PortTransforms_transforms(C.PortTransformsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listporttransform.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) PushBack(value *porttransform.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("PushBack: handle is closed")
	}
	if value == nil {
		return errors.New("PushBack: value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("PushBack: failed to get CAPI handle for value"), err)
	}
	C.PortTransforms_push_back(C.PortTransformsHandle(h.chandle), C.PortTransformHandle(capi))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Size: handle is closed")
	}
	val := int(C.PortTransforms_size(C.PortTransformsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Empty: handle is closed")
	}
	val := bool(C.PortTransforms_empty(C.PortTransformsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("EraseAt: handle is closed")
	}
	C.PortTransforms_erase_at(C.PortTransformsHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Clear: handle is closed")
	}
	C.PortTransforms_clear(C.PortTransformsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) At(idx int) (*porttransform.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("At: handle is closed")
	}
	cHandle := C.PortTransforms_at(C.PortTransformsHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return porttransform.FromCAPI(unsafe.Pointer(cHandle))
}

func (h *Handle) Items() (*listporttransform.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Items: handle is closed")
	}
	cList := C.PortTransforms_items(C.PortTransformsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return listporttransform.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Contains(value *porttransform.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Contains: handle is closed")
	}
	if value == nil {
		return false, errors.New("Contains: value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return false, errors.Join(errors.New("Contains: failed to get CAPI handle for value"), err)
	}
	val := bool(C.PortTransforms_contains(C.PortTransformsHandle(h.chandle), C.PortTransformHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Index(value *porttransform.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Index: handle is closed")
	}
	if value == nil {
		return 0, errors.New("Index: value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return 0, errors.Join(errors.New("Index: failed to get CAPI handle for value"), err)
	}
	val := int(C.PortTransforms_index(C.PortTransformsHandle(h.chandle), C.PortTransformHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Intersection: handle is closed")
	}
	if other == nil {
		return nil, errors.New("Intersection: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == nil {
		return nil, errors.New("Intersection: other is closed")
	}
	res := portTransformsHandle(C.PortTransforms_intersection(C.PortTransformsHandle(h.chandle), C.PortTransformsHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
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
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == nil {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.PortTransforms_equal(C.PortTransformsHandle(h.chandle), C.PortTransformsHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == nil {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.PortTransforms_not_equal(C.PortTransformsHandle(h.chandle), C.PortTransformsHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.PortTransforms_to_json_string(C.PortTransformsHandle(h.chandle))))
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
	h := portTransformsHandle(C.PortTransforms_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
