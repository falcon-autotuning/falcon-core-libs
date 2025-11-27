package listcoupledlabelleddomain

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListCoupledLabelledDomain_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.ListCoupledLabelledDomain_destroy(C.ListCoupledLabelledDomainHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListCoupledLabelledDomain_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func FillValue(count uint32, value *coupledlabelleddomain.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListCoupledLabelledDomain_fill_value(C.size_t(count), C.CoupledLabelledDomainHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*coupledlabelleddomain.Handle) (*Handle, error) {
	list := make([]C.CoupledLabelledDomainHandle, len(data))
	for i, v := range data {
		list[i] = C.CoupledLabelledDomainHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListCoupledLabelledDomain_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *coupledlabelleddomain.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListCoupledLabelledDomain_push_back(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()), C.CoupledLabelledDomainHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.ListCoupledLabelledDomain_size(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListCoupledLabelledDomain_empty(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListCoupledLabelledDomain_erase_at(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListCoupledLabelledDomain_clear(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*coupledlabelleddomain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*coupledlabelleddomain.Handle, error) {

		return coupledlabelleddomain.FromCAPI(unsafe.Pointer(C.ListCoupledLabelledDomain_at(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*coupledlabelleddomain.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListCoupledLabelledDomain_size(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.CoupledLabelledDomainHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListCoupledLabelledDomain_items(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*coupledlabelleddomain.Handle, dim)
	for i := range out {
		realout[i], err = coupledlabelleddomain.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *coupledlabelleddomain.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.ListCoupledLabelledDomain_contains(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()), C.CoupledLabelledDomainHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *coupledlabelleddomain.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.ListCoupledLabelledDomain_index(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()), C.CoupledLabelledDomainHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListCoupledLabelledDomain_intersection(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()), C.ListCoupledLabelledDomainHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListCoupledLabelledDomain_equal(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()), C.ListCoupledLabelledDomainHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListCoupledLabelledDomain_not_equal(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()), C.ListCoupledLabelledDomainHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListCoupledLabelledDomain_to_json_string(C.ListCoupledLabelledDomainHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListCoupledLabelledDomain_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
