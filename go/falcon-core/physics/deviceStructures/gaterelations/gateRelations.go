package gaterelations

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/device_structures/GateRelations_c_api.h>
#include <falcon_core/generic/ListConnections_c_api.h>
#include <falcon_core/generic/ListPairConnectionConnections_c_api.h>
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

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairconnectionconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connections"
)

type chandle C.GateRelationsHandle

type Handle struct {
	chandle chandle
	mu      sync.RWMutex
	closed  bool
}

func new(h chandle) *Handle {
	handle := &Handle{chandle: h}
	runtime.SetFinalizer(handle, func(h *Handle) { h.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(chandle(p)), nil
}

func NewEmpty() (*Handle, error) {
	h := chandle(C.GateRelations_create_empty())
	return new(h), nil
}

func New(items *listpairconnectionconnections.Handle) (*Handle, error) {
	itemsPtr, err := items.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.GateRelations_create(C.ListPairConnectionConnectionsHandle(itemsPtr)))
	return new(h), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Handle already closed")
	}
	C.GateRelations_destroy(C.GateRelationsHandle(h.chandle))
	h.closed = true
	h.chandle = nil
	return nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) InsertOrAssign(key *connection.Handle, value *connections.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("InsertOrAssign: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return err
	}
	valPtr, err := value.CAPIHandle()
	if err != nil {
		return err
	}
	C.GateRelations_insert_or_assign(C.GateRelationsHandle(h.chandle), C.ConnectionHandle(keyPtr), C.ConnectionsHandle(valPtr))
	return nil
}

func (h *Handle) Insert(key *connection.Handle, value *connections.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Insert: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return err
	}
	valPtr, err := value.CAPIHandle()
	if err != nil {
		return err
	}
	C.GateRelations_insert(C.GateRelationsHandle(h.chandle), C.ConnectionHandle(keyPtr), C.ConnectionsHandle(valPtr))
	return nil
}

func (h *Handle) At(key *connection.Handle) (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("At: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return nil, err
	}
	cVal := C.GateRelations_at(C.GateRelationsHandle(h.chandle), C.ConnectionHandle(keyPtr))
	return connections.FromCAPI(unsafe.Pointer(cVal))
}

func (h *Handle) Erase(key *connection.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Erase: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return err
	}
	C.GateRelations_erase(C.GateRelationsHandle(h.chandle), C.ConnectionHandle(keyPtr))
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Size: handle is closed")
	}
	val := int(C.GateRelations_size(C.GateRelationsHandle(h.chandle)))
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Empty: handle is closed")
	}
	val := bool(C.GateRelations_empty(C.GateRelationsHandle(h.chandle)))
	return val, nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Clear: handle is closed")
	}
	C.GateRelations_clear(C.GateRelationsHandle(h.chandle))
	return nil
}

func (h *Handle) Contains(key *connection.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Contains: handle is closed")
	}
	keyPtr, err := key.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.GateRelations_contains(C.GateRelationsHandle(h.chandle), C.ConnectionHandle(keyPtr)))
	return val, nil
}

func (h *Handle) Keys() (*listconnections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Keys: handle is closed")
	}
	cList := C.GateRelations_keys(C.GateRelationsHandle(h.chandle))
	return listconnections.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Values() (*connections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Values: handle is closed")
	}
	cList := C.GateRelations_values(C.GateRelationsHandle(h.chandle))
	return connections.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Items() (*listpairconnectionconnections.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Items: handle is closed")
	}
	cList := C.GateRelations_items(C.GateRelationsHandle(h.chandle))
	return listpairconnectionconnections.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return false, errors.New("Equal: other handle is closed or nil")
	}
	val := bool(C.GateRelations_equal(C.GateRelationsHandle(h.chandle), C.GateRelationsHandle(other.chandle)))
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return false, errors.New("NotEqual: other handle is closed or nil")
	}
	val := bool(C.GateRelations_not_equal(C.GateRelationsHandle(h.chandle), C.GateRelationsHandle(other.chandle)))
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.GateRelations_to_json_string(C.GateRelationsHandle(h.chandle))
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func FromJSON(json string) (*Handle, error) {
	strHandle := str.New(json)
	defer strHandle.Close()
	strPtr, err := strHandle.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.GateRelations_from_json_string(C.StringHandle(strPtr)))
	return new(h), nil
}
