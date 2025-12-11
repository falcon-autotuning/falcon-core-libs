package axescontrolarray1d

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AxesControlArray1D_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listcontrolarray1d"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray1d"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.AxesControlArray1D_destroy(C.AxesControlArray1DHandle(ptr))
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
			return unsafe.Pointer(C.AxesControlArray1D_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesControlArray1D_copy(C.AxesControlArray1DHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(items []*controlarray1d.Handle) (*Handle, error) {
	list, err := listcontrolarray1d.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of controlarray1d failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(data *listcontrolarray1d.Handle) (*Handle, error) {
	return cmemoryallocation.Read(data, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesControlArray1D_create(C.ListControlArray1DHandle(data.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *controlarray1d.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.AxesControlArray1D_push_back(C.AxesControlArray1DHandle(h.CAPIHandle()), C.ControlArray1DHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.AxesControlArray1D_size(C.AxesControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesControlArray1D_empty(C.AxesControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesControlArray1D_erase_at(C.AxesControlArray1DHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesControlArray1D_clear(C.AxesControlArray1DHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*controlarray1d.Handle, error) {
	return cmemoryallocation.Read(h, func() (*controlarray1d.Handle, error) {

		return controlarray1d.FromCAPI(unsafe.Pointer(C.AxesControlArray1D_at(C.AxesControlArray1DHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*controlarray1d.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.AxesControlArray1D_size(C.AxesControlArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.ControlArray1DHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.AxesControlArray1D_items(C.AxesControlArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*controlarray1d.Handle, dim)
	for i := range out {
		realout[i], err = controlarray1d.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *controlarray1d.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.AxesControlArray1D_contains(C.AxesControlArray1DHandle(h.CAPIHandle()), C.ControlArray1DHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *controlarray1d.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.AxesControlArray1D_index(C.AxesControlArray1DHandle(h.CAPIHandle()), C.ControlArray1DHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.AxesControlArray1D_intersection(C.AxesControlArray1DHandle(h.CAPIHandle()), C.AxesControlArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.AxesControlArray1D_equal(C.AxesControlArray1DHandle(h.CAPIHandle()), C.AxesControlArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.AxesControlArray1D_not_equal(C.AxesControlArray1DHandle(h.CAPIHandle()), C.AxesControlArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AxesControlArray1D_to_json_string(C.AxesControlArray1DHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AxesControlArray1D_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
