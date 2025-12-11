package axeslabelledcontrolarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AxesLabelledControlArray_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelledcontrolarray"
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
		C.AxesLabelledControlArray_destroy(C.AxesLabelledControlArrayHandle(ptr))
	}
)

func (h *Handle) IsNil() bool { return h == nil }
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
			return unsafe.Pointer(C.AxesLabelledControlArray_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesLabelledControlArray_copy(C.AxesLabelledControlArrayHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(items []*labelledcontrolarray.Handle) (*Handle, error) {
	list, err := listlabelledcontrolarray.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of labelledcontrolarray failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(data *listlabelledcontrolarray.Handle) (*Handle, error) {
	return cmemoryallocation.Read(data, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesLabelledControlArray_create(C.ListLabelledControlArrayHandle(data.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *labelledcontrolarray.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.AxesLabelledControlArray_push_back(C.AxesLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.AxesLabelledControlArray_size(C.AxesLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesLabelledControlArray_empty(C.AxesLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesLabelledControlArray_erase_at(C.AxesLabelledControlArrayHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesLabelledControlArray_clear(C.AxesLabelledControlArrayHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*labelledcontrolarray.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelledcontrolarray.Handle, error) {

		return labelledcontrolarray.FromCAPI(unsafe.Pointer(C.AxesLabelledControlArray_at(C.AxesLabelledControlArrayHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*labelledcontrolarray.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.AxesLabelledControlArray_size(C.AxesLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.LabelledControlArrayHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.AxesLabelledControlArray_items(C.AxesLabelledControlArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
		return bool(C.AxesLabelledControlArray_contains(C.AxesLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *labelledcontrolarray.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.AxesLabelledControlArray_index(C.AxesLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.AxesLabelledControlArray_intersection(C.AxesLabelledControlArrayHandle(h.CAPIHandle()), C.AxesLabelledControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.AxesLabelledControlArray_equal(C.AxesLabelledControlArrayHandle(h.CAPIHandle()), C.AxesLabelledControlArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.AxesLabelledControlArray_not_equal(C.AxesLabelledControlArrayHandle(h.CAPIHandle()), C.AxesLabelledControlArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AxesLabelledControlArray_to_json_string(C.AxesLabelledControlArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AxesLabelledControlArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
