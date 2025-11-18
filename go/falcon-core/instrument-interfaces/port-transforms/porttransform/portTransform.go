package porttransform

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/FArrayDouble_c_api.h>
#include <falcon_core/generic/ListString_c_api.h>
#include <falcon_core/generic/MapStringDouble_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/instrument_interfaces/names/InstrumentPort_c_api.h>
#include <falcon_core/math/AnalyticFunction_c_api.h>
#include <falcon_core/instrument_interfaces/port_transforms/PortTransform_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/analyticfunction"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type portTransformHandle C.PortTransformHandle

type Handle struct {
	chandle      portTransformHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[portTransformHandle]() {
		return nil, errors.New("CAPIHandle: PortTransform is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle portTransformHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(obj, func(o *Handle) { o.Close() })
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is null")
	}
	return new(portTransformHandle(p)), nil
}

func New(port *instrumentport.Handle, transform *analyticfunction.Handle) (*Handle, error) {
	if port == nil || transform == nil {
		return nil, errors.New("Create: input handles are nil")
	}
	portC, err := port.CAPIHandle()
	if err != nil {
		return nil, err
	}
	transformC, err := transform.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := portTransformHandle(C.PortTransform_create(
		C.InstrumentPortHandle(portC),
		C.AnalyticFunctionHandle(transformC),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewConstantTransform(port *instrumentport.Handle, value float64) (*Handle, error) {
	if port == nil {
		return nil, errors.New("CreateConstantTransform: port is nil")
	}
	portC, err := port.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := portTransformHandle(C.PortTransform_create_constant_transform(
		C.InstrumentPortHandle(portC),
		C.double(value),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewIdentityTransform(port *instrumentport.Handle) (*Handle, error) {
	if port == nil {
		return nil, errors.New("CreateIdentityTransform: port is nil")
	}
	portC, err := port.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := portTransformHandle(C.PortTransform_create_identity_transform(
		C.InstrumentPortHandle(portC),
	))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[portTransformHandle]() {
		C.PortTransform_destroy(C.PortTransformHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[portTransformHandle]()
		return nil
	}
	return errors.New("unable to close the PortTransform")
}

func (h *Handle) Port() (*instrumentport.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[portTransformHandle]() {
		return nil, errors.New("Port: object is closed")
	}
	res := C.PortTransform_port(C.PortTransformHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return instrumentport.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Labels() (*liststring.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[portTransformHandle]() {
		return nil, errors.New("Labels: object is closed")
	}
	res := C.PortTransform_labels(C.PortTransformHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return liststring.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Evaluate(args *mapstringdouble.Handle, time float64) (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[portTransformHandle]() {
		return 0, errors.New("Evaluate: object is closed")
	}
	argsC, err := args.CAPIHandle()
	if err != nil {
		return 0, err
	}
	val := float64(C.PortTransform_evaluate(C.PortTransformHandle(h.chandle), C.MapStringDoubleHandle(argsC), C.double(time)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) EvaluateArraywise(args *mapstringdouble.Handle, deltaT, maxTime float64) (*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[portTransformHandle]() {
		return nil, errors.New("EvaluateArraywise: object is closed")
	}
	argsC, err := args.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := C.PortTransform_evaluate_arraywise(C.PortTransformHandle(h.chandle), C.MapStringDoubleHandle(argsC), C.double(deltaT), C.double(maxTime))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return farraydouble.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[portTransformHandle]() {
		return false, errors.New("Equal: object is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[portTransformHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.PortTransform_equal(C.PortTransformHandle(h.chandle), C.PortTransformHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[portTransformHandle]() {
		return false, errors.New("NotEqual: object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[portTransformHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.PortTransform_not_equal(C.PortTransformHandle(h.chandle), C.PortTransformHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[portTransformHandle]() {
		return "", errors.New("ToJSON: object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.PortTransform_to_json_string(C.PortTransformHandle(h.chandle))))
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
	h := portTransformHandle(C.PortTransform_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
