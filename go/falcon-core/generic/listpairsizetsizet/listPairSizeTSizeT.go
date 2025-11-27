package listpairsizetsizet

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListPairSizeTSizeT_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairsizetsizet"
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
		C.ListPairSizeTSizeT_destroy(C.ListPairSizeTSizeTHandle(ptr))
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
			return unsafe.Pointer(C.ListPairSizeTSizeT_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func FillValue(count uint32, value *pairsizetsizet.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListPairSizeTSizeT_fill_value(C.size_t(count), C.PairSizeTSizeTHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairsizetsizet.Handle) (*Handle, error) {
	list := make([]C.PairSizeTSizeTHandle, len(data))
	for i, v := range data {
		list[i] = C.PairSizeTSizeTHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListPairSizeTSizeT_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *pairsizetsizet.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListPairSizeTSizeT_push_back(C.ListPairSizeTSizeTHandle(h.CAPIHandle()), C.PairSizeTSizeTHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.ListPairSizeTSizeT_size(C.ListPairSizeTSizeTHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListPairSizeTSizeT_empty(C.ListPairSizeTSizeTHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListPairSizeTSizeT_erase_at(C.ListPairSizeTSizeTHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListPairSizeTSizeT_clear(C.ListPairSizeTSizeTHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*pairsizetsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*pairsizetsizet.Handle, error) {

		return pairsizetsizet.FromCAPI(unsafe.Pointer(C.ListPairSizeTSizeT_at(C.ListPairSizeTSizeTHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*pairsizetsizet.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListPairSizeTSizeT_size(C.ListPairSizeTSizeTHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.PairSizeTSizeTHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListPairSizeTSizeT_items(C.ListPairSizeTSizeTHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*pairsizetsizet.Handle, dim)
	for i := range out {
		realout[i], err = pairsizetsizet.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *pairsizetsizet.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.ListPairSizeTSizeT_contains(C.ListPairSizeTSizeTHandle(h.CAPIHandle()), C.PairSizeTSizeTHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *pairsizetsizet.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.ListPairSizeTSizeT_index(C.ListPairSizeTSizeTHandle(h.CAPIHandle()), C.PairSizeTSizeTHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListPairSizeTSizeT_intersection(C.ListPairSizeTSizeTHandle(h.CAPIHandle()), C.ListPairSizeTSizeTHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListPairSizeTSizeT_equal(C.ListPairSizeTSizeTHandle(h.CAPIHandle()), C.ListPairSizeTSizeTHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListPairSizeTSizeT_not_equal(C.ListPairSizeTSizeTHandle(h.CAPIHandle()), C.ListPairSizeTSizeTHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListPairSizeTSizeT_to_json_string(C.ListPairSizeTSizeTHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListPairSizeTSizeT_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
