package gategeometryarray1d

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/physics/config/geometries/DotGatesWithNeighbors_c_api.h>
#include <falcon_core/physics/config/geometries/LeftReservoirWithImplantedOhmic_c_api.h>
#include <falcon_core/physics/config/geometries/RightReservoirWithImplantedOhmic_c_api.h>
#include <falcon_core/physics/device_structures/Connections_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/physics/config/geometries/GateGeometryArray1D_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/dotgateswithneighbors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/leftreservoirwithimplantedohmic"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/rightreservoirwithimplantedohmic"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type gateGeometryArray1DHandle C.GateGeometryArray1DHandle

type Handle struct {
	chandle      gateGeometryArray1DHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle gateGeometryArray1DHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(obj, func(o *Handle) { o.Close() })
	return obj
}

// FromCAPI provides a constructor directly from the CAPI
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New(`FromCAPI The pointer is null`)
	}
	return new(gateGeometryArray1DHandle(p)), nil
}

func New(lineararray, screeningGates *connections.Handle) (*Handle, error) {
	if lineararray == nil || screeningGates == nil {
		return nil, errors.New("New: input handles are nil")
	}
	laC, err := lineararray.CAPIHandle()
	if err != nil {
		return nil, err
	}
	sgC, err := screeningGates.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := gateGeometryArray1DHandle(C.GateGeometryArray1D_create(
		C.ConnectionsHandle(laC),
		C.ConnectionsHandle(sgC),
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
	if !h.closed && h.chandle != utils.NilHandle[gateGeometryArray1DHandle]() {
		C.GateGeometryArray1D_destroy(C.GateGeometryArray1DHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[gateGeometryArray1DHandle]()
		return nil
	}
	return errors.New("unable to close the GateGeometryArray1D")
}

func (h *Handle) AppendCentralGate(left, selected, right *connection.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return errors.New("AppendCentralGate: object is closed")
	}
	lc, err := left.CAPIHandle()
	if err != nil {
		return err
	}
	sc, err := selected.CAPIHandle()
	if err != nil {
		return err
	}
	rc, err := right.CAPIHandle()
	if err != nil {
		return err
	}
	C.GateGeometryArray1D_append_central_gate(
		C.GateGeometryArray1DHandle(h.chandle),
		C.ConnectionHandle(lc),
		C.ConnectionHandle(sc),
		C.ConnectionHandle(rc),
	)
	return h.errorHandler.CheckCapiError()
}

func (h *Handle) AllDotGates() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("AllDotGates: object is closed")
	}
	res := C.GateGeometryArray1D_all_dot_gates(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return unsafe.Pointer(res), nil
}

func (h *Handle) QueryNeighbors(gate *connection.Handle) (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("QueryNeighbors: object is closed")
	}
	gc, err := gate.CAPIHandle()
	if err != nil {
		return nil, err
	}
	res := C.GateGeometryArray1D_query_neighbors(C.GateGeometryArray1DHandle(h.chandle), C.ConnectionHandle(gc))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) LeftReservoir() (*leftreservoirwithimplantedohmic.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("LeftReservoir: object is closed")
	}
	res := C.GateGeometryArray1D_left_reservoir(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return leftreservoirwithimplantedohmic.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) RightReservoir() (*rightreservoirwithimplantedohmic.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("RightReservoir: object is closed")
	}
	res := C.GateGeometryArray1D_right_reservoir(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return rightreservoirwithimplantedohmic.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) LeftBarrier() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("LeftBarrier: object is closed")
	}
	res := C.GateGeometryArray1D_left_barrier(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) RightBarrier() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("RightBarrier: object is closed")
	}
	res := C.GateGeometryArray1D_right_barrier(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) LinearArray() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("LinearArray: object is closed")
	}
	res := C.GateGeometryArray1D_lineararray(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) ScreeningGates() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("ScreeningGates: object is closed")
	}
	res := C.GateGeometryArray1D_screening_gates(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) RawCentralGates() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("RawCentralGates: object is closed")
	}
	res := C.GateGeometryArray1D_raw_central_gates(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) CentralDotGates() (*dotgateswithneighbors.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("CentralDotGates: object is closed")
	}
	res := C.GateGeometryArray1D_central_dot_gates(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return dotgateswithneighbors.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Ohmics() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return nil, errors.New("Ohmics: object is closed")
	}
	res := C.GateGeometryArray1D_ohmics(C.GateGeometryArray1DHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return false, errors.New("Equal: object is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.GateGeometryArray1D_equal(C.GateGeometryArray1DHandle(h.chandle), C.GateGeometryArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return false, errors.New("NotEqual: object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.GateGeometryArray1D_not_equal(C.GateGeometryArray1DHandle(h.chandle), C.GateGeometryArray1DHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[gateGeometryArray1DHandle]() {
		return "", errors.New("ToJSON: object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.GateGeometryArray1D_to_json_string(C.GateGeometryArray1DHandle(h.chandle))))
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
	h := gateGeometryArray1DHandle(C.GateGeometryArray1D_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
