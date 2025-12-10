package coupledlabelleddomain

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/domains/CoupledLabelledDomain_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/labelleddomain"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.CoupledLabelledDomain_destroy(C.CoupledLabelledDomainHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.CoupledLabelledDomain_copy(C.CoupledLabelledDomainHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.CoupledLabelledDomain_equal(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.CoupledLabelledDomainHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.CoupledLabelledDomain_not_equal(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.CoupledLabelledDomainHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.CoupledLabelledDomain_to_json_string(C.CoupledLabelledDomainHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("ToJSON:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func FromJSON(json string) (*Handle, error) {
	realjson := str.New(json)
	return cmemoryallocation.Read(realjson, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.CoupledLabelledDomain_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.CoupledLabelledDomain_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*labelleddomain.Handle) (*Handle, error) {
	list, err := listlabelleddomain.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of labelleddomain failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(items *listlabelleddomain.Handle) (*Handle, error) {
	return cmemoryallocation.Read(items, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.CoupledLabelledDomain_create(C.ListLabelledDomainHandle(items.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Domains() (*listlabelleddomain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlabelleddomain.Handle, error) {

		return listlabelleddomain.FromCAPI(unsafe.Pointer(C.CoupledLabelledDomain_domains(C.CoupledLabelledDomainHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Labels() (*ports.Handle, error) {
	return cmemoryallocation.Read(h, func() (*ports.Handle, error) {

		return ports.FromCAPI(unsafe.Pointer(C.CoupledLabelledDomain_labels(C.CoupledLabelledDomainHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetDomain(search *instrumentport.Handle) (*labelleddomain.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, search}, func() (*labelleddomain.Handle, error) {

		return labelleddomain.FromCAPI(unsafe.Pointer(C.CoupledLabelledDomain_get_domain(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.InstrumentPortHandle(search.CAPIHandle()))))
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.CoupledLabelledDomain_intersection(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.CoupledLabelledDomainHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PushBack(value *labelleddomain.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.CoupledLabelledDomain_push_back(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.LabelledDomainHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.CoupledLabelledDomain_size(C.CoupledLabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.CoupledLabelledDomain_empty(C.CoupledLabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.CoupledLabelledDomain_erase_at(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.CoupledLabelledDomain_clear(C.CoupledLabelledDomainHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) ConstAt(idx uint64) (*labelleddomain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelleddomain.Handle, error) {

		return labelleddomain.FromCAPI(unsafe.Pointer(C.CoupledLabelledDomain_const_at(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) At(idx uint64) (*labelleddomain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelleddomain.Handle, error) {

		return labelleddomain.FromCAPI(unsafe.Pointer(C.CoupledLabelledDomain_at(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() (*listlabelleddomain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlabelleddomain.Handle, error) {

		return listlabelleddomain.FromCAPI(unsafe.Pointer(C.CoupledLabelledDomain_items(C.CoupledLabelledDomainHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Contains(value *labelleddomain.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.CoupledLabelledDomain_contains(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.LabelledDomainHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *labelleddomain.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.CoupledLabelledDomain_index(C.CoupledLabelledDomainHandle(h.CAPIHandle()), C.LabelledDomainHandle(value.CAPIHandle()))), nil
	})
}
