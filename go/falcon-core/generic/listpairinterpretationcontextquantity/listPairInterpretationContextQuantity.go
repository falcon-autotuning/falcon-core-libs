package listpairinterpretationcontextquantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListPairInterpretationContextQuantity_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairinterpretationcontextquantity"
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
		C.ListPairInterpretationContextQuantity_destroy(C.ListPairInterpretationContextQuantityHandle(ptr))
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
			return unsafe.Pointer(C.ListPairInterpretationContextQuantity_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListPairInterpretationContextQuantity_copy(C.ListPairInterpretationContextQuantityHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func FillValue(count uint64, value *pairinterpretationcontextquantity.Handle) (*Handle, error) {
	return cmemoryallocation.Read(value, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListPairInterpretationContextQuantity_fill_value(C.size_t(count), C.PairInterpretationContextQuantityHandle(value.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairinterpretationcontextquantity.Handle) (*Handle, error) {
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
	cData := C.malloc(C.size_t(nData) * C.size_t(unsafe.Sizeof(C.PairInterpretationContextQuantityHandle(nil))))
	if cData == nil {
		return nil, errors.New("C.malloc failed")
	}
	slicecData := (*[1 << 30]C.PairInterpretationContextQuantityHandle)(cData)[:nData:nData]
	for i, v := range data {
		slicecData[i] = C.PairInterpretationContextQuantityHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.ListPairInterpretationContextQuantity_create((*C.PairInterpretationContextQuantityHandle)(cData), C.size_t(nData)))
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
func (h *Handle) PushBack(value *pairinterpretationcontextquantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.ListPairInterpretationContextQuantity_push_back(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()), C.PairInterpretationContextQuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.ListPairInterpretationContextQuantity_size(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListPairInterpretationContextQuantity_empty(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListPairInterpretationContextQuantity_erase_at(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListPairInterpretationContextQuantity_clear(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*pairinterpretationcontextquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*pairinterpretationcontextquantity.Handle, error) {

		return pairinterpretationcontextquantity.FromCAPI(unsafe.Pointer(C.ListPairInterpretationContextQuantity_at(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*pairinterpretationcontextquantity.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListPairInterpretationContextQuantity_size(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.PairInterpretationContextQuantityHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListPairInterpretationContextQuantity_items(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*pairinterpretationcontextquantity.Handle, dim)
	for i := range out {
		realout[i], err = pairinterpretationcontextquantity.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *pairinterpretationcontextquantity.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.ListPairInterpretationContextQuantity_contains(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()), C.PairInterpretationContextQuantityHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *pairinterpretationcontextquantity.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.ListPairInterpretationContextQuantity_index(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()), C.PairInterpretationContextQuantityHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListPairInterpretationContextQuantity_intersection(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()), C.ListPairInterpretationContextQuantityHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListPairInterpretationContextQuantity_equal(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()), C.ListPairInterpretationContextQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListPairInterpretationContextQuantity_not_equal(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()), C.ListPairInterpretationContextQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListPairInterpretationContextQuantity_to_json_string(C.ListPairInterpretationContextQuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListPairInterpretationContextQuantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
