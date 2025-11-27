package axeslabelledmeasuredarray1d

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AxesLabelledMeasuredArray1D_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelledmeasuredarray1d"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledmeasuredarray1d"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.AxesLabelledMeasuredArray1D_destroy(C.AxesLabelledMeasuredArray1DHandle(ptr))
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
			return unsafe.Pointer(C.AxesLabelledMeasuredArray1D_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*labelledmeasuredarray1d.Handle) (*Handle, error) {
	list, err := listlabelledmeasuredarray1d.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of labelledmeasuredarray1d failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(data *listlabelledmeasuredarray1d.Handle) (*Handle, error) {
	return cmemoryallocation.Read(data, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesLabelledMeasuredArray1D_create(C.ListLabelledMeasuredArray1DHandle(data.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *labelledmeasuredarray1d.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.AxesLabelledMeasuredArray1D_push_back(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.AxesLabelledMeasuredArray1D_size(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesLabelledMeasuredArray1D_empty(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesLabelledMeasuredArray1D_erase_at(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesLabelledMeasuredArray1D_clear(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*labelledmeasuredarray1d.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelledmeasuredarray1d.Handle, error) {

		return labelledmeasuredarray1d.FromCAPI(unsafe.Pointer(C.AxesLabelledMeasuredArray1D_at(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*labelledmeasuredarray1d.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.AxesLabelledMeasuredArray1D_size(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.LabelledMeasuredArray1DHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.AxesLabelledMeasuredArray1D_items(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*labelledmeasuredarray1d.Handle, dim)
	for i := range out {
		realout[i], err = labelledmeasuredarray1d.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *labelledmeasuredarray1d.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.AxesLabelledMeasuredArray1D_contains(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *labelledmeasuredarray1d.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.AxesLabelledMeasuredArray1D_index(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.AxesLabelledMeasuredArray1D_intersection(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()), C.AxesLabelledMeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesLabelledMeasuredArray1D_equal(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()), C.AxesLabelledMeasuredArray1DHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesLabelledMeasuredArray1D_not_equal(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()), C.AxesLabelledMeasuredArray1DHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AxesLabelledMeasuredArray1D_to_json_string(C.AxesLabelledMeasuredArray1DHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AxesLabelledMeasuredArray1D_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
