package listlabelledmeasuredarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListLabelledMeasuredArray_c_api.h>
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
		C.ListLabelledMeasuredArray_destroy(C.ListLabelledMeasuredArrayHandle(ptr))
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
			return unsafe.Pointer(C.ListLabelledMeasuredArray_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListLabelledMeasuredArray_copy(C.ListLabelledMeasuredArrayHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func FillValue(count uint64, value *labelledmeasuredarray.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListLabelledMeasuredArray_fill_value(C.size_t(count), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*labelledmeasuredarray.Handle) (*Handle, error) {
	n := len(data)
	if n == 0 {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(nil), nil
			},
			construct,
			destroy,
		)
	}
	size := C.size_t(n) * C.size_t(unsafe.Sizeof(C.LabelledMeasuredArrayHandle(nil)))
	cList := C.malloc(size)
	if cList == nil {
		return nil, errors.New("C.malloc failed")
	}
	// Copy Go data to C memory
	slice := (*[1 << 30]C.LabelledMeasuredArrayHandle)(cList)[:n:n]
	for i, v := range data {
		slice[i] = C.LabelledMeasuredArrayHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.ListLabelledMeasuredArray_create((*C.LabelledMeasuredArrayHandle)(cList), C.size_t(n)))
			C.free(cList)
			return res, nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *labelledmeasuredarray.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListLabelledMeasuredArray_push_back(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.ListLabelledMeasuredArray_size(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListLabelledMeasuredArray_empty(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListLabelledMeasuredArray_erase_at(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListLabelledMeasuredArray_clear(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*labelledmeasuredarray.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelledmeasuredarray.Handle, error) {

		return labelledmeasuredarray.FromCAPI(unsafe.Pointer(C.ListLabelledMeasuredArray_at(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*labelledmeasuredarray.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListLabelledMeasuredArray_size(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.LabelledMeasuredArrayHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListLabelledMeasuredArray_items(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
		return bool(C.ListLabelledMeasuredArray_contains(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *labelledmeasuredarray.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.ListLabelledMeasuredArray_index(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListLabelledMeasuredArray_intersection(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()), C.ListLabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListLabelledMeasuredArray_equal(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()), C.ListLabelledMeasuredArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListLabelledMeasuredArray_not_equal(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()), C.ListLabelledMeasuredArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListLabelledMeasuredArray_to_json_string(C.ListLabelledMeasuredArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListLabelledMeasuredArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
