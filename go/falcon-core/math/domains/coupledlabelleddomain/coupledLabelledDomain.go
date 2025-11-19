package coupledlabelleddomain

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListLabelledDomain_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/instrument_interfaces/names/Ports_c_api.h>
#include <falcon_core/math/domains/LabelledDomain_c_api.h>
#include <falcon_core/math/domains/CoupledLabelledDomain_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
)

type chandle C.CoupledLabelledDomainHandle

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
	C.CoupledLabelledDomain_destroy(C.CoupledLabelledDomainHandle(h.chandle))
	h.closed = true
	h.chandle = nil
	return nil
}

func NewEmpty() (*Handle, error) {
	h := chandle(C.CoupledLabelledDomain_create_empty())
	return new(h), nil
}

func CreateFromList(items *listlabelleddomain.Handle) (*Handle, error) {
	if items == nil {
		return nil, errors.New("CreateFromList: items is nil")
	}
	capi, err := items.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.CoupledLabelledDomain_create(C.ListLabelledDomainHandle(capi)))
	return new(h), nil
}

// New creates a CoupledLabelledDomain handle from a Go slice of *labelleddomain.Handle
func New(items []*labelleddomain.Handle) (*Handle, error) {
	list, err := listlabelleddomain.New(items)
	if err != nil {
		return nil, err
	}
	return CreateFromList(list)
}

func (h *Handle) Domains() (*listlabelleddomain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Domains: handle is closed")
	}
	cList := C.CoupledLabelledDomain_domains(C.CoupledLabelledDomainHandle(h.chandle))
	return listlabelleddomain.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Labels() (*ports.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Labels: handle is closed")
	}
	cPorts := C.CoupledLabelledDomain_labels(C.CoupledLabelledDomainHandle(h.chandle))
	return ports.FromCAPI(unsafe.Pointer(cPorts))
}

func (h *Handle) GetDomain(search *instrumentport.Handle) (*labelleddomain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("GetDomain: handle is closed")
	}
	if search == nil {
		return nil, errors.New("GetDomain: search is nil")
	}
	capi, err := search.CAPIHandle()
	if err != nil {
		return nil, err
	}
	cDom := C.CoupledLabelledDomain_get_domain(C.CoupledLabelledDomainHandle(h.chandle), C.InstrumentPortHandle(capi))
	return labelleddomain.FromCAPI(unsafe.Pointer(cDom))
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
	res := chandle(C.CoupledLabelledDomain_intersection(C.CoupledLabelledDomainHandle(h.chandle), C.CoupledLabelledDomainHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) PushBack(value *labelleddomain.Handle) error {
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
	C.CoupledLabelledDomain_push_back(C.CoupledLabelledDomainHandle(h.chandle), C.LabelledDomainHandle(capi))
	return nil
}

func (h *Handle) Size() (int, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Size: handle is closed")
	}
	val := int(C.CoupledLabelledDomain_size(C.CoupledLabelledDomainHandle(h.chandle)))
	return val, nil
}

func (h *Handle) Empty() (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Empty: handle is closed")
	}
	val := bool(C.CoupledLabelledDomain_empty(C.CoupledLabelledDomainHandle(h.chandle)))
	return val, nil
}

func (h *Handle) EraseAt(idx int) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("EraseAt: handle is closed")
	}
	C.CoupledLabelledDomain_erase_at(C.CoupledLabelledDomainHandle(h.chandle), C.size_t(idx))
	return nil
}

func (h *Handle) Clear() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Clear: handle is closed")
	}
	C.CoupledLabelledDomain_clear(C.CoupledLabelledDomainHandle(h.chandle))
	return nil
}

func (h *Handle) ConstAt(idx int) (*labelleddomain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("ConstAt: handle is closed")
	}
	cDom := C.CoupledLabelledDomain_const_at(C.CoupledLabelledDomainHandle(h.chandle), C.size_t(idx))
	return labelleddomain.FromCAPI(unsafe.Pointer(cDom))
}

func (h *Handle) At(idx int) (*labelleddomain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("At: handle is closed")
	}
	cDom := C.CoupledLabelledDomain_at(C.CoupledLabelledDomainHandle(h.chandle), C.size_t(idx))
	return labelleddomain.FromCAPI(unsafe.Pointer(cDom))
}

func (h *Handle) Items() (*listlabelleddomain.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Items: handle is closed")
	}
	cList := C.CoupledLabelledDomain_items(C.CoupledLabelledDomainHandle(h.chandle))
	return listlabelleddomain.FromCAPI(unsafe.Pointer(cList))
}

func (h *Handle) Contains(value *labelleddomain.Handle) (bool, error) {
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
	val := bool(C.CoupledLabelledDomain_contains(C.CoupledLabelledDomainHandle(h.chandle), C.LabelledDomainHandle(capi)))
	return val, nil
}

func (h *Handle) Index(value *labelleddomain.Handle) (int, error) {
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
	val := int(C.CoupledLabelledDomain_index(C.CoupledLabelledDomainHandle(h.chandle), C.LabelledDomainHandle(capi)))
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
	val := bool(C.CoupledLabelledDomain_equal(C.CoupledLabelledDomainHandle(h.chandle), C.CoupledLabelledDomainHandle(other.chandle)))
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
	val := bool(C.CoupledLabelledDomain_not_equal(C.CoupledLabelledDomainHandle(h.chandle), C.CoupledLabelledDomainHandle(other.chandle)))
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.CoupledLabelledDomain_to_json_string(C.CoupledLabelledDomainHandle(h.chandle))
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
	h := chandle(C.CoupledLabelledDomain_from_json_string(C.StringHandle(strPtr)))
	return new(h), nil
}
