package mapconnectionfloat

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapConnectionFloat_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listfloat"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairconnectionfloat"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionfloat"
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
		C.MapConnectionFloat_destroy(C.MapConnectionFloatHandle(ptr))
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
			return unsafe.Pointer(C.MapConnectionFloat_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(data []*pairconnectionfloat.Handle) (*Handle, error) {
	list := make([]C.PairConnectionFloatHandle, len(data))
	for i, v := range data {
		list[i] = C.PairConnectionFloatHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.MapConnectionFloat_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) InsertOrAssign(key *connection.Handle, value float32) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapConnectionFloat_insert_or_assign(C.MapConnectionFloatHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.float(value))
		return nil
	})
}
func (h *Handle) Insert(key *connection.Handle, value float32) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapConnectionFloat_insert(C.MapConnectionFloatHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.float(value))
		return nil
	})
}
func (h *Handle) At(key *connection.Handle) (float32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (float32, error) {
		return float32(C.MapConnectionFloat_at(C.MapConnectionFloatHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Erase(key *connection.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.MapConnectionFloat_erase(C.MapConnectionFloatHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.MapConnectionFloat_size(C.MapConnectionFloatHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapConnectionFloat_empty(C.MapConnectionFloatHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapConnectionFloat_clear(C.MapConnectionFloatHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.MapConnectionFloat_contains(C.MapConnectionFloatHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.MapConnectionFloat_keys(C.MapConnectionFloatHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listfloat.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listfloat.Handle, error) {

		return listfloat.FromCAPI(unsafe.Pointer(C.MapConnectionFloat_values(C.MapConnectionFloatHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairconnectionfloat.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairconnectionfloat.Handle, error) {

		return listpairconnectionfloat.FromCAPI(unsafe.Pointer(C.MapConnectionFloat_items(C.MapConnectionFloatHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapConnectionFloat_equal(C.MapConnectionFloatHandle(h.CAPIHandle()), C.MapConnectionFloatHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapConnectionFloat_not_equal(C.MapConnectionFloatHandle(h.CAPIHandle()), C.MapConnectionFloatHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapConnectionFloat_to_json_string(C.MapConnectionFloatHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapConnectionFloat_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
