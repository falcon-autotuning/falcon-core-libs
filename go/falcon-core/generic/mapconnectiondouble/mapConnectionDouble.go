package mapconnectiondouble

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapConnectionDouble_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairconnectiondouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectiondouble"
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
		C.MapConnectionDouble_destroy(C.MapConnectionDoubleHandle(ptr))
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
			return unsafe.Pointer(C.MapConnectionDouble_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(data []*pairconnectiondouble.Handle) (*Handle, error) {
	list := make([]C.PairConnectionDoubleHandle, len(data))
	for i, v := range data {
		list[i] = C.PairConnectionDoubleHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.MapConnectionDouble_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) InsertOrAssign(key *connection.Handle, value float64) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapConnectionDouble_insert_or_assign(C.MapConnectionDoubleHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.double(value))
		return nil
	})
}
func (h *Handle) Insert(key *connection.Handle, value float64) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapConnectionDouble_insert(C.MapConnectionDoubleHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.double(value))
		return nil
	})
}
func (h *Handle) At(key *connection.Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (float64, error) {
		return float64(C.MapConnectionDouble_at(C.MapConnectionDoubleHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Erase(key *connection.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapConnectionDouble_erase(C.MapConnectionDoubleHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.MapConnectionDouble_size(C.MapConnectionDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapConnectionDouble_empty(C.MapConnectionDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapConnectionDouble_clear(C.MapConnectionDoubleHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.MapConnectionDouble_contains(C.MapConnectionDoubleHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.MapConnectionDouble_keys(C.MapConnectionDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listdouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listdouble.Handle, error) {

		return listdouble.FromCAPI(unsafe.Pointer(C.MapConnectionDouble_values(C.MapConnectionDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairconnectiondouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairconnectiondouble.Handle, error) {

		return listpairconnectiondouble.FromCAPI(unsafe.Pointer(C.MapConnectionDouble_items(C.MapConnectionDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapConnectionDouble_equal(C.MapConnectionDoubleHandle(h.CAPIHandle()), C.MapConnectionDoubleHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapConnectionDouble_not_equal(C.MapConnectionDoubleHandle(h.CAPIHandle()), C.MapConnectionDoubleHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapConnectionDouble_to_json_string(C.MapConnectionDoubleHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapConnectionDouble_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
