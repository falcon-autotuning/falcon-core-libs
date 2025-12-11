package pairquantityquantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/PairQuantityQuantity_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.PairQuantityQuantity_destroy(C.PairQuantityQuantityHandle(ptr))
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
func New(first *quantity.Handle, second *quantity.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{first, second}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PairQuantityQuantity_create(C.QuantityHandle(first.CAPIHandle()), C.QuantityHandle(second.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PairQuantityQuantity_copy(C.PairQuantityQuantityHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) First() (*quantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*quantity.Handle, error) {

		return quantity.FromCAPI(unsafe.Pointer(C.PairQuantityQuantity_first(C.PairQuantityQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Second() (*quantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*quantity.Handle, error) {

		return quantity.FromCAPI(unsafe.Pointer(C.PairQuantityQuantity_second(C.PairQuantityQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.PairQuantityQuantity_equal(C.PairQuantityQuantityHandle(h.CAPIHandle()), C.PairQuantityQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.PairQuantityQuantity_not_equal(C.PairQuantityQuantityHandle(h.CAPIHandle()), C.PairQuantityQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.PairQuantityQuantity_to_json_string(C.PairQuantityQuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.PairQuantityQuantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
