package dotgatewithneighbors

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/geometries/DotGateWithNeighbors_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type dotGateWithNeighborsHandle C.DotGateWithNeighborsHandle

type Handle struct {
	chandle      dotGateWithNeighborsHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorHandling.Handle
}

// CAPIHandle provides access to the underlying CAPI handle for the DotGateWithNeighbors
func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return nil, errors.New(`CAPIHandle The DotGateWithNeighbors is closed`)
	}
	return unsafe.Pointer(h.chandle), nil
}

// new adds an auto cleanup whenever added to a constructor
func new(i dotGateWithNeighborsHandle) *Handle {
	handle := &Handle{chandle: i, errorHandler: errorHandling.ErrorHandler}
	runtime.AddCleanup(handle, func(_ any) { handle.Close() }, true)
	return handle
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`DotGateWithNeighborsFromCAPI The pointer is null`)
	}
	return new(dotGateWithNeighborsHandle(p)), nil
}

func NewPlungerGateWithNeighbors(name string, left, right *connection.Handle) (*Handle, error) {
	if left == nil || right == nil {
		return nil, errors.New(`NewPlungerGateWithNeighbors failed since neighbor connection is null`)
	}
	nameStr := str.New(name)
	defer nameStr.Close()
	nameCapi, err := nameStr.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("NewPlungerGateWithNeighbors failed from illegal name"), err)
	}
	leftCapi, err := left.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("NewPlungerGateWithNeighbors failed from illegal left connection"), err)
	}
	rightCapi, err := right.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("NewPlungerGateWithNeighbors failed from illegal right connection"), err)
	}
	h := dotGateWithNeighborsHandle(C.DotGateWithNeighbors_create_plungergatewithneighbors(
		C.StringHandle(nameCapi),
		C.ConnectionHandle(leftCapi),
		C.ConnectionHandle(rightCapi),
	))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func NewBarrierGateWithNeighbors(name string, left, right *connection.Handle) (*Handle, error) {
	if left == nil || right == nil {
		return nil, errors.New(`NewBarrierGateWithNeighbors failed since neighbor connection is null`)
	}
	nameStr := str.New(name)
	defer nameStr.Close()
	nameCapi, err := nameStr.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("NewBarrierGateWithNeighbors failed from illegal name"), err)
	}
	leftCapi, err := left.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("NewBarrierGateWithNeighbors failed from illegal left connection"), err)
	}
	rightCapi, err := right.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("NewBarrierGateWithNeighbors failed from illegal right connection"), err)
	}
	h := dotGateWithNeighborsHandle(C.DotGateWithNeighbors_create_barriergatewithneighbors(
		C.StringHandle(nameCapi),
		C.ConnectionHandle(leftCapi),
		C.ConnectionHandle(rightCapi),
	))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[dotGateWithNeighborsHandle]() {
		C.DotGateWithNeighbors_destroy(C.DotGateWithNeighborsHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[dotGateWithNeighborsHandle]()
		return nil
	}
	return errors.New("unable to close the DotGateWithNeighbors")
}

func (h *Handle) Name() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return "", errors.New(`Name The DotGateWithNeighbors is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.DotGateWithNeighbors_name(C.DotGateWithNeighborsHandle(h.chandle))))
	if err != nil {
		return "", errors.New(`Name could not convert to a String. ` + err.Error())
	}
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func (h *Handle) Type() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return "", errors.New(`Type The DotGateWithNeighbors is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.DotGateWithNeighbors_type(C.DotGateWithNeighborsHandle(h.chandle))))
	if err != nil {
		return "", errors.New(`Type could not convert to a String. ` + err.Error())
	}
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func (h *Handle) LeftNeighbor() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return nil, errors.New(`LeftNeighbor The DotGateWithNeighbors is closed`)
	}
	cHandle := unsafe.Pointer(C.DotGateWithNeighbors_left_neighbor(C.DotGateWithNeighborsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return connection.FromCAPI(cHandle)
}

func (h *Handle) RightNeighbor() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return nil, errors.New(`RightNeighbor The DotGateWithNeighbors is closed`)
	}
	cHandle := unsafe.Pointer(C.DotGateWithNeighbors_right_neighbor(C.DotGateWithNeighborsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return connection.FromCAPI(cHandle)
}

func (h *Handle) IsBarrierGate() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return false, errors.New(`IsBarrierGate The DotGateWithNeighbors is closed`)
	}
	val := bool(C.DotGateWithNeighbors_is_barrier_gate(C.DotGateWithNeighborsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsPlungerGate() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return false, errors.New(`IsPlungerGate The DotGateWithNeighbors is closed`)
	}
	val := bool(C.DotGateWithNeighbors_is_plunger_gate(C.DotGateWithNeighborsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return false, errors.New(`Equal The DotGateWithNeighbors is closed`)
	}
	if other == nil {
		return false, errors.New(`Equal The other DotGateWithNeighbors is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return false, errors.New(`Equal The other DotGateWithNeighbors is closed`)
	}
	val := bool(C.DotGateWithNeighbors_equal(C.DotGateWithNeighborsHandle(h.chandle), C.DotGateWithNeighborsHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return false, errors.New(`NotEqual The DotGateWithNeighbors is closed`)
	}
	if other == nil {
		return false, errors.New(`NotEqual The other DotGateWithNeighbors is null`)
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return false, errors.New(`NotEqual The other DotGateWithNeighbors is closed`)
	}
	val := bool(C.DotGateWithNeighbors_not_equal(C.DotGateWithNeighborsHandle(h.chandle), C.DotGateWithNeighborsHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[dotGateWithNeighborsHandle]() {
		return "", errors.New(`ToJSON The DotGateWithNeighbors is closed`)
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.DotGateWithNeighbors_to_json_string(C.DotGateWithNeighborsHandle(h.chandle))))
	if err != nil {
		return "", errors.New(`ToJSON could not convert to a String. ` + err.Error())
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
		return nil, errors.Join(errors.New(`failed to access capi for json`), err)
	}
	h := dotGateWithNeighborsHandle(C.DotGateWithNeighbors_from_json_string(C.StringHandle(capistr)))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
