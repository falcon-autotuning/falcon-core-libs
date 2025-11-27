package mapconnectionquantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapConnectionQuantity_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/quantity"
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
		C.MapConnectionQuantity_destroy(C.MapConnectionQuantityHandle(ptr))
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
			return unsafe.Pointer(C.MapConnectionQuantity_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(data []*pairconnectionquantity.Handle) (*Handle, error) {
	list := make([]C.PairConnectionQuantityHandle, len(data))
	for i, v := range data {
		list[i] = C.PairConnectionQuantityHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.MapConnectionQuantity_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) InsertOrAssign(key *connection.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapConnectionQuantity_insert_or_assign(C.MapConnectionQuantityHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *connection.Handle, value *quantity.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.MapConnectionQuantity_insert(C.MapConnectionQuantityHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.QuantityHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *connection.Handle) (*quantity.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*quantity.Handle, error) {

		return quantity.FromCAPI(unsafe.Pointer(C.MapConnectionQuantity_at(C.MapConnectionQuantityHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *connection.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapConnectionQuantity_erase(C.MapConnectionQuantityHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.MapConnectionQuantity_size(C.MapConnectionQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapConnectionQuantity_empty(C.MapConnectionQuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapConnectionQuantity_clear(C.MapConnectionQuantityHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.MapConnectionQuantity_contains(C.MapConnectionQuantityHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.MapConnectionQuantity_keys(C.MapConnectionQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listquantity.Handle, error) {

		return listquantity.FromCAPI(unsafe.Pointer(C.MapConnectionQuantity_values(C.MapConnectionQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairconnectionquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairconnectionquantity.Handle, error) {

		return listpairconnectionquantity.FromCAPI(unsafe.Pointer(C.MapConnectionQuantity_items(C.MapConnectionQuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapConnectionQuantity_equal(C.MapConnectionQuantityHandle(h.CAPIHandle()), C.MapConnectionQuantityHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapConnectionQuantity_not_equal(C.MapConnectionQuantityHandle(h.CAPIHandle()), C.MapConnectionQuantityHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapConnectionQuantity_to_json_string(C.MapConnectionQuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapConnectionQuantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
