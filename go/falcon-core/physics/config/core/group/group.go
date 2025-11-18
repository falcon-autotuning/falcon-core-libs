package group

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/names/Channel_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/physics/config/geometries/GateGeometryArray1D_c_api.h>
#include <falcon_core/physics/device_structures/Connections_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/physics/config/core/Group_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/errorhandling"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/gategeometryarray1d"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type groupHandle C.GroupHandle

type Handle struct {
	chandle      groupHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle groupHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.SetFinalizer(obj, func(o *Handle) { o.Close() })
	return obj
}

func New(
	name *channel.Handle,
	numDots int,
	screeningGates, reservoirGates, plungerGates, barrierGates, order *connections.Handle,
) (*Handle, error) {
	if name == nil || screeningGates == nil || reservoirGates == nil || plungerGates == nil || barrierGates == nil || order == nil {
		return nil, errors.New("Create: input handles are nil")
	}
	nameC, err := name.CAPIHandle()
	if err != nil {
		return nil, err
	}
	screeningC, err := screeningGates.CAPIHandle()
	if err != nil {
		return nil, err
	}
	reservoirC, err := reservoirGates.CAPIHandle()
	if err != nil {
		return nil, err
	}
	plungerC, err := plungerGates.CAPIHandle()
	if err != nil {
		return nil, err
	}
	barrierC, err := barrierGates.CAPIHandle()
	if err != nil {
		return nil, err
	}
	orderC, err := order.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := groupHandle(C.Group_create(
		C.ChannelHandle(nameC),
		C.int(numDots),
		C.ConnectionsHandle(screeningC),
		C.ConnectionsHandle(reservoirC),
		C.ConnectionsHandle(plungerC),
		C.ConnectionsHandle(barrierC),
		C.ConnectionsHandle(orderC),
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
	if !h.closed && h.chandle != utils.NilHandle[groupHandle]() {
		C.Group_destroy(C.GroupHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[groupHandle]()
		return nil
	}
	return errors.New("unable to close the Group")
}

func (h *Handle) Name() (*channel.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("Name: object is closed")
	}
	res := C.Group_name(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return channel.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) NumDots() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return 0, errors.New("NumDots: object is closed")
	}
	val := int(C.Group_num_dots(C.GroupHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Order() (*gategeometryarray1d.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("Order: object is closed")
	}
	res := C.Group_order(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return gategeometryarray1d.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) HasChannel(channelH *channel.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("HasChannel: object is closed")
	}
	ch, err := channelH.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Group_has_channel(C.GroupHandle(h.chandle), C.ChannelHandle(ch)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) IsChargeSensor() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("IsChargeSensor: object is closed")
	}
	val := bool(C.Group_is_charge_sensor(C.GroupHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) GetAllChannelGates() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetAllChannelGates: object is closed")
	}
	res := C.Group_get_all_channel_gates(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) ScreeningGates() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("ScreeningGates: object is closed")
	}
	res := C.Group_screening_gates(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) ReservoirGates() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("ReservoirGates: object is closed")
	}
	res := C.Group_reservoir_gates(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) PlungerGates() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("PlungerGates: object is closed")
	}
	res := C.Group_plunger_gates(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) BarrierGates() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("BarrierGates: object is closed")
	}
	res := C.Group_barrier_gates(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) Ohmics() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("Ohmics: object is closed")
	}
	res := C.Group_ohmics(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) DotGates() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("DotGates: object is closed")
	}
	res := C.Group_dot_gates(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

// Single connection getters
func (h *Handle) GetOhmic() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetOhmic: object is closed")
	}
	res := C.Group_get_ohmic(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetBarrierGate() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetBarrierGate: object is closed")
	}
	res := C.Group_get_barrier_gate(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetPlungerGate() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetPlungerGate: object is closed")
	}
	res := C.Group_get_plunger_gate(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetReservoirGate() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetReservoirGate: object is closed")
	}
	res := C.Group_get_reservoir_gate(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetScreeningGate() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetScreeningGate: object is closed")
	}
	res := C.Group_get_screening_gate(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetDotGate() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetDotGate: object is closed")
	}
	res := C.Group_get_dot_gate(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetGate() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetGate: object is closed")
	}
	res := C.Group_get_gate(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connection.FromCAPI(unsafe.Pointer(res))
}

// All gates/connections
func (h *Handle) GetAllGates() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetAllGates: object is closed")
	}
	res := C.Group_get_all_gates(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

func (h *Handle) GetAllConnections() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return nil, errors.New("GetAllConnections: object is closed")
	}
	res := C.Group_get_all_connections(C.GroupHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return connections.FromCAPI(unsafe.Pointer(res))
}

// Has* methods
func (h *Handle) HasOhmic(ohmic *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("HasOhmic: object is closed")
	}
	ohmC, err := ohmic.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Group_has_ohmic(C.GroupHandle(h.chandle), C.ConnectionHandle(ohmC)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) HasGate(gate *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("HasGate: object is closed")
	}
	gc, err := gate.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Group_has_gate(C.GroupHandle(h.chandle), C.ConnectionHandle(gc)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) HasBarrierGate(barrier *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("HasBarrierGate: object is closed")
	}
	bc, err := barrier.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Group_has_barrier_gate(C.GroupHandle(h.chandle), C.ConnectionHandle(bc)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) HasPlungerGate(plunger *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("HasPlungerGate: object is closed")
	}
	pc, err := plunger.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Group_has_plunger_gate(C.GroupHandle(h.chandle), C.ConnectionHandle(pc)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) HasReservoirGate(reservoir *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("HasReservoirGate: object is closed")
	}
	rc, err := reservoir.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Group_has_reservoir_gate(C.GroupHandle(h.chandle), C.ConnectionHandle(rc)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) HasScreeningGate(screening *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("HasScreeningGate: object is closed")
	}
	sc, err := screening.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Group_has_screening_gate(C.GroupHandle(h.chandle), C.ConnectionHandle(sc)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

// Equality
func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("Equal: object is closed")
	}
	if other == nil {
		return false, errors.New("Equal: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("Equal: other is closed")
	}
	val := bool(C.Group_equal(C.GroupHandle(h.chandle), C.GroupHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("NotEqual: object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual: other is nil")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[groupHandle]() {
		return false, errors.New("NotEqual: other is closed")
	}
	val := bool(C.Group_not_equal(C.GroupHandle(h.chandle), C.GroupHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

// Serialization
func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[groupHandle]() {
		return "", errors.New("ToJSON: object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Group_to_json_string(C.GroupHandle(h.chandle))))
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
	h := groupHandle(C.Group_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
