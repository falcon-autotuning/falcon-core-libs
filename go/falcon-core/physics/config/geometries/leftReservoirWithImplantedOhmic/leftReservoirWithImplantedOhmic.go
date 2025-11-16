package leftreservoirwithimplantedohmic

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/geometries/LeftReservoirWithImplantedOhmic_c_api.h>
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

type leftReservoirWithImplantedOhmicHandle C.LeftReservoirWithImplantedOhmicHandle

type Handle struct {
	chandle      leftReservoirWithImplantedOhmicHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorHandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle leftReservoirWithImplantedOhmicHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorHandling.ErrorHandler}
	runtime.AddCleanup(obj, func(_ any) { obj.Close() }, true)
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI The pointer is null")
	}
	return new(leftReservoirWithImplantedOhmicHandle(p)), nil
}

func New(name string, rightNeighbor, ohmic *connection.Handle) (*Handle, error) {
	if rightNeighbor == nil || ohmic == nil {
		return nil, errors.New("New failed: rightNeighbor or ohmic is nil")
	}
	nameStr := str.New(name)
	defer nameStr.Close()
	nameCapi, err := nameStr.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New failed: could not get CAPI handle for name"), err)
	}
	rightCapi, err := rightNeighbor.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New failed: could not get CAPI handle for rightNeighbor"), err)
	}
	ohmicCapi, err := ohmic.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New failed: could not get CAPI handle for ohmic"), err)
	}
	h := leftReservoirWithImplantedOhmicHandle(C.LeftReservoirWithImplantedOhmic_create(
		C.StringHandle(nameCapi),
		C.ConnectionHandle(rightCapi),
		C.ConnectionHandle(ohmicCapi),
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
	if !h.closed && h.chandle != utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		C.LeftReservoirWithImplantedOhmic_destroy(C.LeftReservoirWithImplantedOhmicHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[leftReservoirWithImplantedOhmicHandle]()
		return nil
	}
	return errors.New("unable to close the LeftReservoirWithImplantedOhmic")
}

func (h *Handle) Name() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return "", errors.New("Name The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_name(C.LeftReservoirWithImplantedOhmicHandle(h.chandle))))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	return strHandle.ToGoString()
}

func (h *Handle) Type() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return "", errors.New("Type The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_type(C.LeftReservoirWithImplantedOhmicHandle(h.chandle))))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return "", capiErr
	}
	return strHandle.ToGoString()
}

func (h *Handle) Ohmic() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return nil, errors.New("Ohmic The object is closed")
	}
	cHandle := unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_ohmic(C.LeftReservoirWithImplantedOhmicHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return connection.FromCAPI(cHandle)
}

func (h *Handle) RightNeighbor() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return nil, errors.New("RightNeighbor The object is closed")
	}
	cHandle := unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_right_neighbor(C.LeftReservoirWithImplantedOhmicHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return connection.FromCAPI(cHandle)
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return false, errors.New("Equal The object is closed")
	}
	if other == nil {
		return false, errors.New("Equal The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return false, errors.New("Equal The other object is closed")
	}
	val := bool(C.LeftReservoirWithImplantedOhmic_equal(
		C.LeftReservoirWithImplantedOhmicHandle(h.chandle),
		C.LeftReservoirWithImplantedOhmicHandle(other.chandle),
	))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return false, errors.New("NotEqual The object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return false, errors.New("NotEqual The other object is closed")
	}
	val := bool(C.LeftReservoirWithImplantedOhmic_not_equal(
		C.LeftReservoirWithImplantedOhmicHandle(h.chandle),
		C.LeftReservoirWithImplantedOhmicHandle(other.chandle),
	))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[leftReservoirWithImplantedOhmicHandle]() {
		return "", errors.New("ToJSON The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_to_json_string(C.LeftReservoirWithImplantedOhmicHandle(h.chandle))))
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
	h := leftReservoirWithImplantedOhmicHandle(C.LeftReservoirWithImplantedOhmic_from_json_string(C.StringHandle(capistr)))
	err = errorHandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
