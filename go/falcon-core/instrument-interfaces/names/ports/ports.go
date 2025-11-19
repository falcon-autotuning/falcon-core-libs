package ports

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListInstrumentPort_c_api.h>
#include <falcon_core/generic/ListString_c_api.h>
#include <falcon_core/generic/ListConnection_c_api.h>
#include <falcon_core/instrument_interfaces/names/InstrumentPort_c_api.h>
#include <falcon_core/instrument_interfaces/names/Ports_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listinstrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
)

type portsHandle C.PortsHandle

type Handle struct {
	chandle portsHandle
	mu      sync.RWMutex
	closed  bool
}

func new(h portsHandle) *Handle {
	handle := &Handle{chandle: h}
	runtime.SetFinalizer(handle, func(h *Handle) { h.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(portsHandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Handle already closed")
	}
	C.Ports_destroy(C.PortsHandle(h.chandle))
	h.closed = true
	h.chandle = nil
	return nil
}

func NewEmpty() (*Handle, error) {
	h := portsHandle(C.Ports_create_empty())
	return new(h), nil
}

func CreateFromList(items *listinstrumentport.Handle) (*Handle, error) {
	if items == nil {
		return nil, errors.New("CreateFromList: items is nil")
	}
	capi, err := items.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := portsHandle(C.Ports_create(C.ListInstrumentPortHandle(capi)))
	return new(h), nil
}

// New creates a Ports handle from a Go slice of *instrumentport.Handle
func New(items []*instrumentport.Handle) (*Handle, error) {
	list, err := listinstrumentport.New(items)
	if err != nil {
		return nil, err
	}
	return CreateFromList(list)
}

func (h *Handle) Ports() (*listinstrumentport.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Ports: handle is closed")
	}
	cList := C.Ports_ports(C.PortsHandle(h.chandle))
	return listinstrumentport.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) DefaultNames() (*liststring.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DefaultNames: handle is closed")
	}
	cList := C.Ports_default_names(C.PortsHandle(h.chandle))
	return liststring.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) GetPsuedoNames() (*listconnection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("GetPsuedoNames: handle is closed")
	}
	cList := C.Ports_get_psuedo_names(C.PortsHandle(h.chandle))
	return listconnection.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) GetRawNames() (*liststring.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("GetRawNames: handle is closed")
	}
	cList := C.Ports__get_raw_names(C.PortsHandle(h.chandle))
	return liststring.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) GetInstrumentFacingNames() (*liststring.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("GetInstrumentFacingNames: handle is closed")
	}
	cList := C.Ports__get_instrument_facing_names(C.PortsHandle(h.chandle))
	return liststring.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) GetPsuedonameMatchingPort(name *connection.Handle) (*instrumentport.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("GetPsuedonameMatchingPort: handle is closed")
	}
	if name == nil {
		return nil, errors.New("GetPsuedonameMatchingPort: name is nil")
	}
	capi, err := name.CAPIHandle()
	if err != nil {
		return nil, err
	}
	cPort := C.Ports__get_psuedoname_matching_port(C.PortsHandle(h.chandle), C.ConnectionHandle(capi))
	return instrumentport.FromCAPI(unsafe.Pointer(cPort))
}

func (h *Handle) GetInstrumentTypeMatchingPort(typeStr string) (*instrumentport.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("GetInstrumentTypeMatchingPort: handle is closed")
	}
	s := str.New(typeStr)
	defer s.Close()
	capi, err := s.CAPIHandle()
	if err != nil {
		return nil, err
	}
	cPort := C.Ports__get_instrument_type_matching_port(C.PortsHandle(h.chandle), C.StringHandle(capi))
	return instrumentport.FromCAPI(unsafe.Pointer(cPort))
}

func (h *Handle) IsKnobs() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("IsKnobs: handle is closed")
	}
	val := bool(C.Ports_is_knobs(C.PortsHandle(h.chandle)))
	return val, nil
}

func (h *Handle) IsMeters() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("IsMeters: handle is closed")
	}
	val := bool(C.Ports_is_meters(C.PortsHandle(h.chandle)))
	return val, nil
}

func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Intersection: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("Intersection: other handle is closed or nil")
	}
	res := portsHandle(C.Ports_intersection(C.PortsHandle(h.chandle), C.PortsHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) PushBack(value *instrumentport.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("PushBack: handle is closed")
	}
	if value == nil {
		return errors.New("PushBack: value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return err
	}
	C.Ports_push_back(C.PortsHandle(h.chandle), C.InstrumentPortHandle(capi))
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Size: handle is closed")
	}
	val := int(C.Ports_size(C.PortsHandle(h.chandle)))
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Empty: handle is closed")
	}
	val := bool(C.Ports_empty(C.PortsHandle(h.chandle)))
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("EraseAt: handle is closed")
	}
	C.Ports_erase_at(C.PortsHandle(h.chandle), C.size_t(idx))
	return nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Clear: handle is closed")
	}
	C.Ports_clear(C.PortsHandle(h.chandle))
	return nil
}

func (h *Handle) ConstAt(idx int) (*instrumentport.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("ConstAt: handle is closed")
	}
	cPort := C.Ports_const_at(C.PortsHandle(h.chandle), C.size_t(idx))
	return instrumentport.FromCAPI(unsafe.Pointer(cPort))
}

func (h *Handle) At(idx int) (*instrumentport.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("At: handle is closed")
	}
	cPort := C.Ports_at(C.PortsHandle(h.chandle), C.size_t(idx))
	return instrumentport.FromCAPI(unsafe.Pointer(cPort))
}

func (h *Handle) Items() (*liststring.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Items: handle is closed")
	}
	cList := C.Ports_items(C.PortsHandle(h.chandle))
	return liststring.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Contains(value *instrumentport.Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Contains: handle is closed")
	}
	if value == nil {
		return false, errors.New("Contains: value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return false, err
	}
	val := bool(C.Ports_contains(C.PortsHandle(h.chandle), C.InstrumentPortHandle(capi)))
	return val, nil
}

func (h *Handle) Index(value *instrumentport.Handle) (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Index: handle is closed")
	}
	if value == nil {
		return 0, errors.New("Index: value is nil")
	}
	capi, err := value.CAPIHandle()
	if err != nil {
		return 0, err
	}
	val := int(C.Ports_index(C.PortsHandle(h.chandle), C.InstrumentPortHandle(capi)))
	return val, nil
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
	val := bool(C.Ports_equal(C.PortsHandle(h.chandle), C.PortsHandle(other.chandle)))
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
	val := bool(C.Ports_not_equal(C.PortsHandle(h.chandle), C.PortsHandle(other.chandle)))
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.Ports_to_json_string(C.PortsHandle(h.chandle))
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
	h := portsHandle(C.Ports_from_json_string(C.StringHandle(strPtr)))
	return new(h), nil
}
