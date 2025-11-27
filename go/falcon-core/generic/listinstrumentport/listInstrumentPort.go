package listinstrumentport

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListInstrumentPort_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.ListInstrumentPort_destroy(C.ListInstrumentPortHandle(ptr))
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
			return unsafe.Pointer(C.ListInstrumentPort_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func FillValue(count uint32, value *instrumentport.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListInstrumentPort_fill_value(C.size_t(count), C.InstrumentPortHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*instrumentport.Handle) (*Handle, error) {
	list := make([]C.InstrumentPortHandle, len(data))
	for i, v := range data {
		list[i] = C.InstrumentPortHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListInstrumentPort_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *instrumentport.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListInstrumentPort_push_back(C.ListInstrumentPortHandle(h.CAPIHandle()), C.InstrumentPortHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.ListInstrumentPort_size(C.ListInstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListInstrumentPort_empty(C.ListInstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListInstrumentPort_erase_at(C.ListInstrumentPortHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListInstrumentPort_clear(C.ListInstrumentPortHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*instrumentport.Handle, error) {
	return cmemoryallocation.Read(h, func() (*instrumentport.Handle, error) {

		return instrumentport.FromCAPI(unsafe.Pointer(C.ListInstrumentPort_at(C.ListInstrumentPortHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*instrumentport.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListInstrumentPort_size(C.ListInstrumentPortHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.InstrumentPortHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListInstrumentPort_items(C.ListInstrumentPortHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*instrumentport.Handle, dim)
	for i := range out {
		realout[i], err = instrumentport.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *instrumentport.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.ListInstrumentPort_contains(C.ListInstrumentPortHandle(h.CAPIHandle()), C.InstrumentPortHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *instrumentport.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.ListInstrumentPort_index(C.ListInstrumentPortHandle(h.CAPIHandle()), C.InstrumentPortHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListInstrumentPort_intersection(C.ListInstrumentPortHandle(h.CAPIHandle()), C.ListInstrumentPortHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListInstrumentPort_equal(C.ListInstrumentPortHandle(h.CAPIHandle()), C.ListInstrumentPortHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListInstrumentPort_not_equal(C.ListInstrumentPortHandle(h.CAPIHandle()), C.ListInstrumentPortHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListInstrumentPort_to_json_string(C.ListInstrumentPortHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListInstrumentPort_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
