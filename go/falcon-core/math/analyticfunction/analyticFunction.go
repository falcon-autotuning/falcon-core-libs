package analyticfunction

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/FArrayDouble_c_api.h>
#include <falcon_core/generic/ListString_c_api.h>
#include <falcon_core/generic/MapStringDouble_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/math/AnalyticFunction_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type analyticFunctionHandle C.AnalyticFunctionHandle

type Handle struct {
	chandle      analyticFunctionHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[analyticFunctionHandle]() {
		return nil, errors.New("CAPIHandle: AnalyticFunction is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle analyticFunctionHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(obj, func(o *Handle) { o.Close() })
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is null")
	}
	return new(analyticFunctionHandle(p)), nil
}

func New(labels *liststring.Handle, expression string) (*Handle, error) {
	if labels == nil {
		return nil, errors.New("New: labels is nil")
	}
	labelsC, err := labels.CAPIHandle()
	if err != nil {
		return nil, err
	}
	exprStr := str.New(expression)
	defer exprStr.Close()
	exprC, err := exprStr.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := analyticFunctionHandle(C.AnalyticFunction_create(
		C.ListStringHandle(labelsC),
		C.StringHandle(exprC),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewIdentity() (*Handle, error) {
	h := analyticFunctionHandle(C.AnalyticFunction_create_identity())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewConstant(value float64) (*Handle, error) {
	h := analyticFunctionHandle(C.AnalyticFunction_create_constant(C.double(value)))
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[analyticFunctionHandle]() {
		C.AnalyticFunction_destroy(C.AnalyticFunctionHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[analyticFunctionHandle]()
		return nil
	}
	return errors.New("unable to close the AnalyticFunction")
}

func (h *Handle) Labels() (*liststring.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[analyticFunctionHandle]() {
		return nil, errors.New("Labels: object is closed")
	}
	res := C.AnalyticFunction_labels(C.AnalyticFunctionHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return liststring.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Evaluate(args *mapstringdouble.Handle, time float64) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[analyticFunctionHandle]() {
		return 0, errors.New("Evaluate: object is closed")
	}
	argsC, err := args.CAPIHandle()
	if err != nil {
		return 0, err
	}
	val := float64(C.AnalyticFunction_evaluate(C.AnalyticFunctionHandle(h.chandle), C.MapStringDoubleHandle(argsC), C.double(time)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) EvaluateArraywise(args *mapstringdouble.Handle, deltaT, maxTime float64) (*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[analyticFunctionHandle]() {
		return nil, errors.New("EvaluateArraywise: object is closed")
	}
	argsC, err := args.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := C.AnalyticFunction_evaluate_arraywise(C.AnalyticFunctionHandle(h.chandle), C.MapStringDoubleHandle(argsC), C.double(deltaT), C.double(maxTime))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return farraydouble.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[analyticFunctionHandle]() {
		return false, errors.New("Equal: object is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[analyticFunctionHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.AnalyticFunction_equal(C.AnalyticFunctionHandle(h.chandle), C.AnalyticFunctionHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[analyticFunctionHandle]() {
		return false, errors.New("NotEqual: object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[analyticFunctionHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.AnalyticFunction_not_equal(C.AnalyticFunctionHandle(h.chandle), C.AnalyticFunctionHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[analyticFunctionHandle]() {
		return "", errors.New("ToJSON: object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.AnalyticFunction_to_json_string(C.AnalyticFunctionHandle(h.chandle))))
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
	h := analyticFunctionHandle(C.AnalyticFunction_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
