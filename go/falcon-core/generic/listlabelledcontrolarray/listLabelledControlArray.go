package listlabelledcontrolarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListLabelledControlArray_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledcontrolarray"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.ListLabelledControlArray_destroy(C.ListLabelledControlArrayHandle(ptr))
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
			return unsafe.Pointer(C.ListLabelledControlArray_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func FillValue(count uint32, value *labelledcontrolarray.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListLabelledControlArray_fill_value(C.size_t(count), C.LabelledControlArrayHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*labelledcontrolarray.Handle) (*Handle, error) {
	list := make([]C.LabelledControlArrayHandle, len(data))
	for i, v := range data {
		list[i] = C.LabelledControlArrayHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListLabelledControlArray_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *labelledcontrolarray.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListLabelledControlArray_push_back(C.ListLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.ListLabelledControlArray_size(C.ListLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListLabelledControlArray_empty(C.ListLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListLabelledControlArray_erase_at(C.ListLabelledControlArrayHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListLabelledControlArray_clear(C.ListLabelledControlArrayHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*labelledcontrolarray.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelledcontrolarray.Handle, error) {

		return labelledcontrolarray.FromCAPI(unsafe.Pointer(C.ListLabelledControlArray_at(C.ListLabelledControlArrayHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*labelledcontrolarray.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListLabelledControlArray_size(C.ListLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.LabelledControlArrayHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListLabelledControlArray_items(C.ListLabelledControlArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*labelledcontrolarray.Handle, dim)
	for i := range out {
		realout[i], err = labelledcontrolarray.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *labelledcontrolarray.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.ListLabelledControlArray_contains(C.ListLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *labelledcontrolarray.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.ListLabelledControlArray_index(C.ListLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListLabelledControlArray_intersection(C.ListLabelledControlArrayHandle(h.CAPIHandle()), C.ListLabelledControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListLabelledControlArray_equal(C.ListLabelledControlArrayHandle(h.CAPIHandle()), C.ListLabelledControlArrayHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListLabelledControlArray_not_equal(C.ListLabelledControlArrayHandle(h.CAPIHandle()), C.ListLabelledControlArrayHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListLabelledControlArray_to_json_string(C.ListLabelledControlArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListLabelledControlArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
