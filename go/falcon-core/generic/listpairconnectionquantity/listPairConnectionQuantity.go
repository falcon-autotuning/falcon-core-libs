package listpairconnectionquantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListPairConnectionQuantity_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.ListPairConnectionQuantity_destroy(C.ListPairConnectionQuantityHandle(ptr))
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
			return unsafe.Pointer(C.ListPairConnectionQuantity_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func FillValue(count uint32, value *pairconnectionquantity.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListPairConnectionQuantity_fill_value(C.size_t(count), C.PairConnectionQuantityHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairconnectionquantity.Handle) (*Handle, error) {
	list := make([]C.PairConnectionQuantityHandle, len(data))
	for i, v := range data {
		list[i] = C.PairConnectionQuantityHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListPairConnectionQuantity_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *pairconnectionquantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListPairConnectionQuantity_push_back(C.ListPairConnectionQuantityHandle(h.CAPIHandle()), C.PairConnectionQuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.ListPairConnectionQuantity_size(C.ListPairConnectionQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListPairConnectionQuantity_empty(C.ListPairConnectionQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListPairConnectionQuantity_erase_at(C.ListPairConnectionQuantityHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListPairConnectionQuantity_clear(C.ListPairConnectionQuantityHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*pairconnectionquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*pairconnectionquantity.Handle, error) {

		return pairconnectionquantity.FromCAPI(unsafe.Pointer(C.ListPairConnectionQuantity_at(C.ListPairConnectionQuantityHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*pairconnectionquantity.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListPairConnectionQuantity_size(C.ListPairConnectionQuantityHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.PairConnectionQuantityHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListPairConnectionQuantity_items(C.ListPairConnectionQuantityHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*pairconnectionquantity.Handle, dim)
	for i := range out {
		realout[i], err = pairconnectionquantity.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *pairconnectionquantity.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.ListPairConnectionQuantity_contains(C.ListPairConnectionQuantityHandle(h.CAPIHandle()), C.PairConnectionQuantityHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *pairconnectionquantity.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.ListPairConnectionQuantity_index(C.ListPairConnectionQuantityHandle(h.CAPIHandle()), C.PairConnectionQuantityHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListPairConnectionQuantity_intersection(C.ListPairConnectionQuantityHandle(h.CAPIHandle()), C.ListPairConnectionQuantityHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListPairConnectionQuantity_equal(C.ListPairConnectionQuantityHandle(h.CAPIHandle()), C.ListPairConnectionQuantityHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListPairConnectionQuantity_not_equal(C.ListPairConnectionQuantityHandle(h.CAPIHandle()), C.ListPairConnectionQuantityHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListPairConnectionQuantity_to_json_string(C.ListPairConnectionQuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListPairConnectionQuantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
