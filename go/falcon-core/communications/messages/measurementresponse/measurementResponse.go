package measurementresponse

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/arrays/LabelledArraysLabelledMeasuredArray_c_api.h>
#include <falcon_core/communications/messages/MeasurementResponse_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledarrayslabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type measurementResponseHandle C.MeasurementResponseHandle

type Handle struct {
	chandle      measurementResponseHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func new(h measurementResponseHandle) *Handle {
	handle := &Handle{chandle: h, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(handle, func(obj *Handle) { obj.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(measurementResponseHandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementResponseHandle]() {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[measurementResponseHandle]() {
		C.MeasurementResponse_destroy(C.MeasurementResponseHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[measurementResponseHandle]()
		return nil
	}
	return errors.New("unable to close the Handle")
}

// Constructors

func New(arrays *labelledarrayslabelledmeasuredarray.Handle) (*Handle, error) {
	arraysPtr, err := arrays.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := measurementResponseHandle(C.MeasurementResponse_create(
		C.LabelledArraysLabelledMeasuredArrayHandle(arraysPtr),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

// Methods

func (h *Handle) Arrays() (*labelledarrayslabelledmeasuredarray.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementResponseHandle]() {
		return nil, errors.New("Arrays: handle is closed")
	}
	cArrays := C.MeasurementResponse_arrays(C.MeasurementResponseHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return labelledarrayslabelledmeasuredarray.FromCAPI(unsafe.Pointer(cArrays))
}

func (h *Handle) Message() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementResponseHandle]() {
		return "", errors.New("Message: handle is closed")
	}
	cStr := C.MeasurementResponse_message(C.MeasurementResponseHandle(h.chandle))
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

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementResponseHandle]() {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[measurementResponseHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.MeasurementResponse_equal(C.MeasurementResponseHandle(h.chandle), C.MeasurementResponseHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementResponseHandle]() {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[measurementResponseHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.MeasurementResponse_not_equal(C.MeasurementResponseHandle(h.chandle), C.MeasurementResponseHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[measurementResponseHandle]() {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.MeasurementResponse_to_json_string(C.MeasurementResponseHandle(h.chandle))
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
	h := measurementResponseHandle(C.MeasurementResponse_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
