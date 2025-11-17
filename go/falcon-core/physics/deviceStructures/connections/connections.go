package connections

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListConnection_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/physics/device_structures/Connections_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/utils"
)

type connectionsHandle C.ConnectionsHandle

type Handle struct {
	chandle      connectionsHandle
	mu           sync.RWMutex
	closed       bool
	errorHandler *errorhandling.Handle
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return nil, errors.New("CAPIHandle The object is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func new(handle connectionsHandle) *Handle {
	obj := &Handle{chandle: handle, errorHandler: errorhandling.ErrorHandler}
	runtime.AddCleanup(obj, func(_ any) { obj.Close() }, true)
	return obj
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI The pointer is null")
	}
	return new(connectionsHandle(p)), nil
}

func NewEmpty() (*Handle, error) {
	h := connectionsHandle(C.Connections_create_empty())
	err := errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func CreateFromList(items *listconnection.Handle) (*Handle, error) {
	if items == nil {
		return nil, errors.New("New failed: items is nil")
	}
	capi, err := items.CAPIHandle()
	if err != nil {
		return nil, errors.Join(errors.New("New failed: could not get CAPI handle for items"), err)
	}
	h := connectionsHandle(C.Connections_create(C.ListConnectionHandle(capi)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}

func New(items []*connection.Handle) (*Handle, error) {
	list, err := listconnection.New(items)
	if err != nil {
		return nil, errors.Join(errors.New(`construction of list of connection failed`), err)
	}
	return CreateFromList(list)
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if !h.closed && h.chandle != utils.NilHandle[connectionsHandle]() {
		C.Connections_destroy(C.ConnectionsHandle(h.chandle))
		err := h.errorHandler.CheckCapiError()
		if err != nil {
			return err
		}
		h.closed = true
		h.chandle = utils.NilHandle[connectionsHandle]()
		return nil
	}
	return errors.New("unable to close the Connections")
}

func (h *Handle) IsGates() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("IsGates The object is closed")
	}
	val := bool(C.Connections_is_gates(C.ConnectionsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsOhmics() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("IsOhmics The object is closed")
	}
	val := bool(C.Connections_is_ohmics(C.ConnectionsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsDotGates() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("IsDotGates The object is closed")
	}
	val := bool(C.Connections_is_dot_gates(C.ConnectionsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsPlungerGates() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("IsPlungerGates The object is closed")
	}
	val := bool(C.Connections_is_plunger_gates(C.ConnectionsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsBarrierGates() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("IsBarrierGates The object is closed")
	}
	val := bool(C.Connections_is_barrier_gates(C.ConnectionsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsReservoirGates() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("IsReservoirGates The object is closed")
	}
	val := bool(C.Connections_is_reservoir_gates(C.ConnectionsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) IsScreeningGates() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("IsScreeningGates The object is closed")
	}
	val := bool(C.Connections_is_screening_gates(C.ConnectionsHandle(h.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return nil, errors.New("Intersection The object is closed")
	}
	if other == nil {
		return nil, errors.New("Intersection The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[connectionsHandle]() {
		return nil, errors.New("Intersection The other object is closed")
	}
	res := connectionsHandle(C.Connections_intersection(C.ConnectionsHandle(h.chandle), C.ConnectionsHandle(other.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(res), nil
}

func (h *Handle) PushBack(value *connection.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return errors.New("PushBack The object is closed")
	}
	if value == nil {
		return errors.New("PushBack value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return errors.Join(errors.New("PushBack failed to get CAPI handle for value"), err)
	}
	C.Connections_push_back(C.ConnectionsHandle(h.chandle), C.ConnectionHandle(capi))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return 0, errors.New("Size The object is closed")
	}
	val := int(C.Connections_size(C.ConnectionsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("Empty The object is closed")
	}
	val := bool(C.Connections_empty(C.ConnectionsHandle(h.chandle)))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return errors.New("EraseAt The object is closed")
	}
	C.Connections_erase_at(C.ConnectionsHandle(h.chandle), C.size_t(idx))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return errors.New("Clear The object is closed")
	}
	C.Connections_clear(C.ConnectionsHandle(h.chandle))
	err := h.errorHandler.CheckCapiError()
	if err != nil {
		return err
	}
	return nil
}

func (h *Handle) At(idx int) (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return nil, errors.New("At The object is closed")
	}
	cHandle := unsafe.Pointer(C.Connections_at(C.ConnectionsHandle(h.chandle), C.size_t(idx)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	return connection.FromCAPI(cHandle)
}

func (h *Handle) Items() ([]*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return nil, errors.New("Items The object is closed")
	}
	cList := C.Connections_items(C.ConnectionsHandle(h.chandle))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return nil, capiErr
	}
	listHandle, err := listconnection.FromCAPI(unsafe.Pointer(cList))
	if err != nil {
		return nil, err
	}
	defer listHandle.Close()
	return listHandle.Items()
}

func (h *Handle) Contains(value *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("Contains The object is closed")
	}
	if value == nil {
		return false, errors.New("Contains value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return false, errors.Join(errors.New("Contains failed to get CAPI handle for value"), err)
	}
	val := bool(C.Connections_contains(C.ConnectionsHandle(h.chandle), C.ConnectionHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return false, err
	}
	return val, nil
}

func (h *Handle) Index(value *connection.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return 0, errors.New("Index The object is closed")
	}
	if value == nil {
		return 0, errors.New("Index value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return 0, errors.Join(errors.New("Index failed to get CAPI handle for value"), err)
	}
	val := int(C.Connections_index(C.ConnectionsHandle(h.chandle), C.ConnectionHandle(capi)))
	err = h.errorHandler.CheckCapiError()
	if err != nil {
		return 0, err
	}
	return val, nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("Equal The object is closed")
	}
	if other == nil {
		return false, errors.New("Equal The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("Equal The other object is closed")
	}
	val := bool(C.Connections_equal(C.ConnectionsHandle(h.chandle), C.ConnectionsHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("NotEqual The object is closed")
	}
	if other == nil {
		return false, errors.New("NotEqual The other object is null")
	}
	other.mu.RLock()
	defer other.mu.RUnlock()
	if other.closed || other.chandle == utils.NilHandle[connectionsHandle]() {
		return false, errors.New("NotEqual The other object is closed")
	}
	val := bool(C.Connections_not_equal(C.ConnectionsHandle(h.chandle), C.ConnectionsHandle(other.chandle)))
	capiErr := h.errorHandler.CheckCapiError()
	if capiErr != nil {
		return false, capiErr
	}
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == utils.NilHandle[connectionsHandle]() {
		return "", errors.New("ToJSON The object is closed")
	}
	strHandle, err := str.FromCAPI(unsafe.Pointer(C.Connections_to_json_string(C.ConnectionsHandle(h.chandle))))
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
	h := connectionsHandle(C.Connections_from_json_string(C.StringHandle(capistr)))
	err = errorhandling.ErrorHandler.CheckCapiError()
	if err != nil {
		return nil, err
	}
	return new(h), nil
}
