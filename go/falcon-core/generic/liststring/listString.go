package liststring

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListString_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"

	// no extra imports
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
		C.ListString_destroy(C.ListStringHandle(ptr))
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
			return unsafe.Pointer(C.ListString_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListString_copy(C.ListStringHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func Allocate(count uint64) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListString_allocate(C.size_t(count))), nil
		},
		construct,
		destroy,
	)
}
func FillValue(count uint64, value string) (*Handle, error) {
	realvalue := str.New(value)
	return cmemoryallocation.Read(realvalue, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListString_fill_value(C.size_t(count), C.StringHandle(realvalue.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []string) (*Handle, error) {
	nData := len(data)
	if nData == 0 {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(nil), nil
			},
			construct,
			destroy,
		)
	}
	cData := C.malloc(C.size_t(nData) * C.size_t(unsafe.Sizeof(C.StringHandle(nil))))
	if cData == nil {
		return nil, errors.New("C.malloc failed")
	}
	slicecData := (*[1 << 30]C.StringHandle)(cData)[:nData:nData]
	for i, v := range data {
		slicecData[i] = C.StringHandle(str.New(v).CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.ListString_create((*C.StringHandle)(cData), C.size_t(nData)))
			C.free(cData)
			return res, nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value string) error {
	realvalue := str.New(value)
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{realvalue}, func() error {
		C.ListString_push_back(C.ListStringHandle(h.CAPIHandle()), C.StringHandle(realvalue.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.ListString_size(C.ListStringHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListString_empty(C.ListStringHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListString_erase_at(C.ListStringHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListString_clear(C.ListStringHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListString_at(C.ListStringHandle(h.CAPIHandle()), C.size_t(idx))))
		if err != nil {
			return "", errors.New("At:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Items() ([]string, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListString_size(C.ListStringHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.StringHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListString_items(C.ListStringHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]string, dim)
	for i := range out {
		realstr, err := str.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("string: conversion from capi failed"), err)
		}
		realout[i], err = realstr.ToGoString()
		if err != nil {
			return nil, errors.Join(errors.New("string: conversion to string failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value string) (bool, error) {
	realvalue := str.New(value)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, realvalue}, func() (bool, error) {
		return bool(C.ListString_contains(C.ListStringHandle(h.CAPIHandle()), C.StringHandle(realvalue.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value string) (uint64, error) {
	realvalue := str.New(value)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, realvalue}, func() (uint64, error) {
		return uint64(C.ListString_index(C.ListStringHandle(h.CAPIHandle()), C.StringHandle(realvalue.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListString_intersection(C.ListStringHandle(h.CAPIHandle()), C.ListStringHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListString_equal(C.ListStringHandle(h.CAPIHandle()), C.ListStringHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListString_not_equal(C.ListStringHandle(h.CAPIHandle()), C.ListStringHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListString_to_json_string(C.ListStringHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListString_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
