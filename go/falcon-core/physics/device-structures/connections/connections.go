package connections

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/device_structures/Connections_c_api.h>
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
		C.Connections_destroy(C.ConnectionsHandle(ptr))
	}
)

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
				return unsafe.Pointer(C.Connections_copy(C.ConnectionsHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Connections_equal(C.ConnectionsHandle(h.CAPIHandle()), C.ConnectionsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Connections_not_equal(C.ConnectionsHandle(h.CAPIHandle()), C.ConnectionsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Connections_to_json_string(C.ConnectionsHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Connections_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.Connections_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*connection.Handle) (*Handle, error) {
	list, err := listconnection.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of connection failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(items *listconnection.Handle) (*Handle, error) {
	return cmemoryallocation.Read(items, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Connections_create(C.ListConnectionHandle(items.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) IsGates() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connections_is_gates(C.ConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsOhmics() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connections_is_ohmics(C.ConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsDotGates() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connections_is_dot_gates(C.ConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsPlungerGates() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connections_is_plunger_gates(C.ConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsBarrierGates() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connections_is_barrier_gates(C.ConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsReservoirGates() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connections_is_reservoir_gates(C.ConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsScreeningGates() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connections_is_screening_gates(C.ConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Connections_intersection(C.ConnectionsHandle(h.CAPIHandle()), C.ConnectionsHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PushBack(value *connection.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.Connections_push_back(C.ConnectionsHandle(h.CAPIHandle()), C.ConnectionHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.Connections_size(C.ConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Connections_empty(C.ConnectionsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.Connections_erase_at(C.ConnectionsHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.Connections_clear(C.ConnectionsHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Connections_at(C.ConnectionsHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() (*listconnection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listconnection.Handle, error) {

		return listconnection.FromCAPI(unsafe.Pointer(C.Connections_items(C.ConnectionsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Contains(value *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.Connections_contains(C.ConnectionsHandle(h.CAPIHandle()), C.ConnectionHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *connection.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.Connections_index(C.ConnectionsHandle(h.CAPIHandle()), C.ConnectionHandle(value.CAPIHandle()))), nil
	})
}
