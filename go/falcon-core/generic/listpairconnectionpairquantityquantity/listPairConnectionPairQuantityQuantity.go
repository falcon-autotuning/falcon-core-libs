package listpairconnectionpairquantityquantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListPairConnectionPairQuantityQuantity_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionpairquantityquantity"
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
		C.ListPairConnectionPairQuantityQuantity_destroy(C.ListPairConnectionPairQuantityQuantityHandle(ptr))
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
			return unsafe.Pointer(C.ListPairConnectionPairQuantityQuantity_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListPairConnectionPairQuantityQuantity_copy(C.ListPairConnectionPairQuantityQuantityHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func FillValue(count uint64, value *pairconnectionpairquantityquantity.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListPairConnectionPairQuantityQuantity_fill_value(C.size_t(count), C.PairConnectionPairQuantityQuantityHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairconnectionpairquantityquantity.Handle) (*Handle, error) {
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
	size := C.size_t(n) * C.size_t(unsafe.Sizeof(C.PairConnectionPairQuantityQuantityHandle(nil)))
	cList := C.malloc(size)
	if cList == nil {
		return nil, errors.New("C.malloc failed")
	}
	// Copy Go data to C memory
	slice := (*[1 << 30]C.PairConnectionPairQuantityQuantityHandle)(cList)[:n:n]
	for i, v := range data {
		slice[i] = C.PairConnectionPairQuantityQuantityHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.ListPairConnectionPairQuantityQuantity_create((*C.PairConnectionPairQuantityQuantityHandle)(cList), C.size_t(n)))
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
func (h *Handle) PushBack(value *pairconnectionpairquantityquantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListPairConnectionPairQuantityQuantity_push_back(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.PairConnectionPairQuantityQuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.ListPairConnectionPairQuantityQuantity_size(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListPairConnectionPairQuantityQuantity_empty(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListPairConnectionPairQuantityQuantity_erase_at(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListPairConnectionPairQuantityQuantity_clear(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*pairconnectionpairquantityquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*pairconnectionpairquantityquantity.Handle, error) {

		return pairconnectionpairquantityquantity.FromCAPI(unsafe.Pointer(C.ListPairConnectionPairQuantityQuantity_at(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*pairconnectionpairquantityquantity.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListPairConnectionPairQuantityQuantity_size(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.PairConnectionPairQuantityQuantityHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListPairConnectionPairQuantityQuantity_items(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*pairconnectionpairquantityquantity.Handle, dim)
	for i := range out {
		realout[i], err = pairconnectionpairquantityquantity.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *pairconnectionpairquantityquantity.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.ListPairConnectionPairQuantityQuantity_contains(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.PairConnectionPairQuantityQuantityHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *pairconnectionpairquantityquantity.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.ListPairConnectionPairQuantityQuantity_index(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.PairConnectionPairQuantityQuantityHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListPairConnectionPairQuantityQuantity_intersection(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.ListPairConnectionPairQuantityQuantityHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListPairConnectionPairQuantityQuantity_equal(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.ListPairConnectionPairQuantityQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListPairConnectionPairQuantityQuantity_not_equal(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.ListPairConnectionPairQuantityQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListPairConnectionPairQuantityQuantity_to_json_string(C.ListPairConnectionPairQuantityQuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListPairConnectionPairQuantityQuantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
