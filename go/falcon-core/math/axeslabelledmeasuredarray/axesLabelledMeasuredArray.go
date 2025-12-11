package axeslabelledmeasuredarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AxesLabelledMeasuredArray_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledmeasuredarray"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.AxesLabelledMeasuredArray_destroy(C.AxesLabelledMeasuredArrayHandle(ptr))
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
			return unsafe.Pointer(C.AxesLabelledMeasuredArray_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesLabelledMeasuredArray_copy(C.AxesLabelledMeasuredArrayHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(items []*labelledmeasuredarray.Handle) (*Handle, error) {
	list, err := listlabelledmeasuredarray.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of labelledmeasuredarray failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(data *listlabelledmeasuredarray.Handle) (*Handle, error) {
	return cmemoryallocation.Read(data, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesLabelledMeasuredArray_create(C.ListLabelledMeasuredArrayHandle(data.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *labelledmeasuredarray.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.AxesLabelledMeasuredArray_push_back(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.AxesLabelledMeasuredArray_size(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesLabelledMeasuredArray_empty(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesLabelledMeasuredArray_erase_at(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesLabelledMeasuredArray_clear(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*labelledmeasuredarray.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelledmeasuredarray.Handle, error) {

		return labelledmeasuredarray.FromCAPI(unsafe.Pointer(C.AxesLabelledMeasuredArray_at(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*labelledmeasuredarray.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.AxesLabelledMeasuredArray_size(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.LabelledMeasuredArrayHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.AxesLabelledMeasuredArray_items(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*labelledmeasuredarray.Handle, dim)
	for i := range out {
		realout[i], err = labelledmeasuredarray.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *labelledmeasuredarray.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.AxesLabelledMeasuredArray_contains(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *labelledmeasuredarray.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.AxesLabelledMeasuredArray_index(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.AxesLabelledMeasuredArray_intersection(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()), C.AxesLabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.AxesLabelledMeasuredArray_equal(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()), C.AxesLabelledMeasuredArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.AxesLabelledMeasuredArray_not_equal(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()), C.AxesLabelledMeasuredArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AxesLabelledMeasuredArray_to_json_string(C.AxesLabelledMeasuredArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AxesLabelledMeasuredArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
