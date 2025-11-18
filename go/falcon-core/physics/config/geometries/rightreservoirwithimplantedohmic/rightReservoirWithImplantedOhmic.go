package rightreservoirwithimplantedohmic

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/geometries/RightReservoirWithImplantedOhmic_c_api.h>
#include <falcon_core/generic/String_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type rightReservoirWithImplantedOhmicHandle C.RightReservoirWithImplantedOhmicHandle

type Handle struct {
	chandle      rightReservoirWithImplantedOhmicHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle rightReservoirWithImplantedOhmicHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(obj, func(_ any) { obj.Close() }, true)
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI The pointer is null")
	}
	return new(rightReservoirWithImplantedOhmicHandle(p)), nil
}

func New(name string, leftNeighbor, ohmic *connection.Handle) (*Handle, error) {
	if leftNeighbor == nil || ohmic == nil {
		return nil, errors.New("New failed: leftNeighbor or ohmic is nil")
	}
	nameStr := str.New(name)
	defer nameStr.Close()
	nameCapi, err := nameStr.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New failed: could not get CAPI handle for name"), err)
	}
	leftCapi, err := leftNeighbor.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New failed: could not get CAPI handle for leftNeighbor"), err)
	}
	ohmicCapi, err := ohmic.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New failed: could not get CAPI handle for ohmic"), err)
	}
	h := rightReservoirWithImplantedOhmicHandle(C.RightReservoirWithImplantedOhmic_create(
		C.StringHandle(nameCapi),
		C.ConnectionHandle(leftCapi),
		C.ConnectionHandle(ohmicCapi),
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
	if !h.closed && h.chandle != utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		C.RightReservoirWithImplantedOhmic_destroy(C.RightReservoirWithImplantedOhmicHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[rightReservoirWithImplantedOhmicHandle]()
		return nil
	}
	return errors.New("unable to close the RightReservoirWithImplantedOhmic")
}

func (h *Handle) Name() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return "", errors.New("Name The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.RightReservoirWithImplantedOhmic_name(C.RightReservoirWithImplantedOhmicHandle(h.chandle))))
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
	if h.closed || h.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return "", errors.New("Type The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.RightReservoirWithImplantedOhmic_type(C.RightReservoirWithImplantedOhmicHandle(h.chandle))))
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
	if h.closed || h.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return nil, errors.New("Ohmic The object is closed")
	}
	cHandle := unsafe.Pointer(C.RightReservoirWithImplantedOhmic_ohmic(C.RightReservoirWithImplantedOhmicHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return connection.FromCAPI(cHandle)
}

func (h *Handle) LeftNeighbor() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return nil, errors.New("LeftNeighbor The object is closed")
	}
	cHandle := unsafe.Pointer(C.RightReservoirWithImplantedOhmic_left_neighbor(C.RightReservoirWithImplantedOhmicHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return connection.FromCAPI(cHandle)
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return false, errors.New("Equal The object is closed")
	}
	if other == nil {
		return false, errors.New("Equal The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return false, errors.New("Equal The other object is closed")
	}
	val := bool(C.RightReservoirWithImplantedOhmic_equal(
		C.RightReservoirWithImplantedOhmicHandle(h.chandle),
		C.RightReservoirWithImplantedOhmicHandle(other.chandle),
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
	if h.closed || h.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return false, errors.New("NotEqual The object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return false, errors.New("NotEqual The other object is closed")
	}
	val := bool(C.RightReservoirWithImplantedOhmic_not_equal(
		C.RightReservoirWithImplantedOhmicHandle(h.chandle),
		C.RightReservoirWithImplantedOhmicHandle(other.chandle),
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
	if h.closed || h.chandle == utils.NilHandle[rightReservoirWithImplantedOhmicHandle]() {
		return "", errors.New("ToJSON The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.RightReservoirWithImplantedOhmic_to_json_string(C.RightReservoirWithImplantedOhmicHandle(h.chandle))))
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
	h := rightReservoirWithImplantedOhmicHandle(C.RightReservoirWithImplantedOhmic_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
