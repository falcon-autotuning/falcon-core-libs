package dotgatewithneighbors

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/geometries/DotGateWithNeighbors_c_api.h>
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
		C.DotGateWithNeighbors_destroy(C.DotGateWithNeighborsHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func NewPlungerGateWithNeighbors(name string, left_neighbor *connection.Handle, right_neighbor *connection.Handle) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realname, left_neighbor, right_neighbor}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.DotGateWithNeighbors_create_plunger_gate_with_neighbors(C.StringHandle(realname.CAPIHandle()), C.ConnectionHandle(left_neighbor.CAPIHandle()), C.ConnectionHandle(right_neighbor.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewBarrierGateWithNeighbors(name string, left_neighbor *connection.Handle, right_neighbor *connection.Handle) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realname, left_neighbor, right_neighbor}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.DotGateWithNeighbors_create_barrier_gate_with_neighbors(C.StringHandle(realname.CAPIHandle()), C.ConnectionHandle(left_neighbor.CAPIHandle()), C.ConnectionHandle(right_neighbor.CAPIHandle()))), nil
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
		return bool(C.DotGateWithNeighbors_equal(C.DotGateWithNeighborsHandle(h.CAPIHandle()), C.DotGateWithNeighborsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.DotGateWithNeighbors_not_equal(C.DotGateWithNeighborsHandle(h.CAPIHandle()), C.DotGateWithNeighborsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Name() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.DotGateWithNeighbors_name(C.DotGateWithNeighborsHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Name:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Type() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.DotGateWithNeighbors_type(C.DotGateWithNeighborsHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Type:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) LeftNeighbor() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.DotGateWithNeighbors_left_neighbor(C.DotGateWithNeighborsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) RightNeighbor() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.DotGateWithNeighbors_right_neighbor(C.DotGateWithNeighborsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) IsBarrierGate() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.DotGateWithNeighbors_is_barrier_gate(C.DotGateWithNeighborsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsPlungerGate() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.DotGateWithNeighbors_is_plunger_gate(C.DotGateWithNeighborsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.DotGateWithNeighbors_to_json_string(C.DotGateWithNeighborsHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.DotGateWithNeighbors_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
