package gaterelations

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/device_structures/GateRelations_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairconnectionconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.GateRelations_destroy(C.GateRelationsHandle(ptr))
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
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.GateRelations_copy(C.GateRelationsHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.GateRelations_equal(C.GateRelationsHandle(h.CAPIHandle()), C.GateRelationsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.GateRelations_not_equal(C.GateRelationsHandle(h.CAPIHandle()), C.GateRelationsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.GateRelations_to_json_string(C.GateRelationsHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.GateRelations_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.GateRelations_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*pairconnectionconnections.Handle) (*Handle, error) {
	list, err := listpairconnectionconnections.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of pairconnectionconnections failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(items *listpairconnectionconnections.Handle) (*Handle, error) {
	return cmemoryallocation.Read(items, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.GateRelations_create(C.ListPairConnectionConnectionsHandle(items.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) InsertOrAssign(key *connection.Handle, value *connections.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.GateRelations_insert_or_assign(C.GateRelationsHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.ConnectionsHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Insert(key *connection.Handle, value *connections.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key, value}, func() error {
		C.GateRelations_insert(C.GateRelationsHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()), C.ConnectionsHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(key *connection.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.GateRelations_at(C.GateRelationsHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))))
	})
}
func (h *Handle) Erase(key *connection.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{key}, func() error {
		C.GateRelations_erase(C.GateRelationsHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.GateRelations_size(C.GateRelationsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.GateRelations_empty(C.GateRelationsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.GateRelations_clear(C.GateRelationsHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, key}, func() (bool, error) {
		return bool(C.GateRelations_contains(C.GateRelationsHandle(h.CAPIHandle()), C.ConnectionHandle(key.CAPIHandle()))), nil
	})
}
func (h *Handle) Keys() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.GateRelations_keys(C.GateRelationsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnections.Handle, error) {

		return listconnections.FromCAPI(unsafe.Pointer(C.GateRelations_values(C.GateRelationsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairconnectionconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairconnectionconnections.Handle, error) {

		return listpairconnectionconnections.FromCAPI(unsafe.Pointer(C.GateRelations_items(C.GateRelationsHandle(h.CAPIHandle()))))
	})
}
