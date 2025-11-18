package voltageconstraints

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/FArrayDouble_c_api.h>
#include <falcon_core/generic/PairDoubleDouble_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/physics/config/core/Adjacency_c_api.h>
#include <falcon_core/physics/config/core/VoltageConstraints_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairdoubledouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/adjacency"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type voltageConstraintsHandle C.VoltageConstraintsHandle

type Handle struct {
	chandle      voltageConstraintsHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[voltageConstraintsHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle voltageConstraintsHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(obj, func(o *Handle) { o.Close() })
	return obj
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`FromCAPI The pointer is null`)
	}
	return new(voltageConstraintsHandle(p)), nil
}

func New(adj *adjacency.Handle, maxSafeDiff float64, bounds *pairdoubledouble.Handle) (*Handle, error) {
	if adj == nil || bounds == nil {
		return nil, errors.New("New: input handles are nil")
	}
	adjC, err := adj.CAPIHandle()
	if err != nil {
		return nil, err
	}
	boundsC, err := bounds.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := voltageConstraintsHandle(C.VoltageConstraints_create(
		C.AdjacencyHandle(adjC),
		C.double(maxSafeDiff),
		C.PairDoubleDoubleHandle(boundsC),
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
	if !h.closed && h.chandle != utils.NilHandle[voltageConstraintsHandle]() {
		C.VoltageConstraints_destroy(C.VoltageConstraintsHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[voltageConstraintsHandle]()
		return nil
	}
	return errors.New("unable to close the VoltageConstraints")
}

func (h *Handle) Matrix() (*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[voltageConstraintsHandle]() {
		return nil, errors.New("Matrix: object is closed")
	}
	res := C.VoltageConstraints_matrix(C.VoltageConstraintsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return farraydouble.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Adjacency() (*adjacency.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[voltageConstraintsHandle]() {
		return nil, errors.New("Adjacency: object is closed")
	}
	res := C.VoltageConstraints_adjacency(C.VoltageConstraintsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return adjacency.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Limits() (*farraydouble.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[voltageConstraintsHandle]() {
		return nil, errors.New("Limits: object is closed")
	}
	res := C.VoltageConstraints_limits(C.VoltageConstraintsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return farraydouble.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[voltageConstraintsHandle]() {
		return false, errors.New("Equal: object is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[voltageConstraintsHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.VoltageConstraints_equal(C.VoltageConstraintsHandle(h.chandle), C.VoltageConstraintsHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[voltageConstraintsHandle]() {
		return false, errors.New("NotEqual: object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[voltageConstraintsHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.VoltageConstraints_not_equal(C.VoltageConstraintsHandle(h.chandle), C.VoltageConstraintsHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[voltageConstraintsHandle]() {
		return "", errors.New("ToJSON: object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.VoltageConstraints_to_json_string(C.VoltageConstraintsHandle(h.chandle))))
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
	h := voltageConstraintsHandle(C.VoltageConstraints_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
