package pairconnectionpairquantityquantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/PairConnectionPairQuantityQuantity_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairquantityquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.PairConnectionPairQuantityQuantity_destroy(C.PairConnectionPairQuantityQuantityHandle(ptr))
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
func New(first *connection.Handle, second *pairquantityquantity.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{first, second}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PairConnectionPairQuantityQuantity_create(C.ConnectionHandle(first.CAPIHandle()), C.PairQuantityQuantityHandle(second.CAPIHandle()))), nil
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
				return unsafe.Pointer(C.PairConnectionPairQuantityQuantity_copy(C.PairConnectionPairQuantityQuantityHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) First() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.PairConnectionPairQuantityQuantity_first(C.PairConnectionPairQuantityQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Second() (*pairquantityquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*pairquantityquantity.Handle, error) {

		return pairquantityquantity.FromCAPI(unsafe.Pointer(C.PairConnectionPairQuantityQuantity_second(C.PairConnectionPairQuantityQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.PairConnectionPairQuantityQuantity_equal(C.PairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.PairConnectionPairQuantityQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.PairConnectionPairQuantityQuantity_not_equal(C.PairConnectionPairQuantityQuantityHandle(h.CAPIHandle()), C.PairConnectionPairQuantityQuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.PairConnectionPairQuantityQuantity_to_json_string(C.PairConnectionPairQuantityQuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.PairConnectionPairQuantityQuantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
