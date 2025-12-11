package dotgateswithneighbors

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/geometries/DotGatesWithNeighbors_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdotgatewithneighbors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/dotgatewithneighbors"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.DotGatesWithNeighbors_destroy(C.DotGatesWithNeighborsHandle(ptr))
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
				return unsafe.Pointer(C.DotGatesWithNeighbors_copy(C.DotGatesWithNeighborsHandle(handle.CAPIHandle()))), nil
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
		return bool(C.DotGatesWithNeighbors_equal(C.DotGatesWithNeighborsHandle(h.CAPIHandle()), C.DotGatesWithNeighborsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.DotGatesWithNeighbors_not_equal(C.DotGatesWithNeighborsHandle(h.CAPIHandle()), C.DotGatesWithNeighborsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.DotGatesWithNeighbors_to_json_string(C.DotGatesWithNeighborsHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.DotGatesWithNeighbors_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.DotGatesWithNeighbors_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*dotgatewithneighbors.Handle) (*Handle, error) {
	list, err := listdotgatewithneighbors.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of dotgatewithneighbors failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(items *listdotgatewithneighbors.Handle) (*Handle, error) {
	return cmemoryallocation.Read(items, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.DotGatesWithNeighbors_create(C.ListDotGateWithNeighborsHandle(items.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) IsPlungerGates() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.DotGatesWithNeighbors_is_plunger_gates(C.DotGatesWithNeighborsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsBarrierGates() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.DotGatesWithNeighbors_is_barrier_gates(C.DotGatesWithNeighborsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.DotGatesWithNeighbors_intersection(C.DotGatesWithNeighborsHandle(h.CAPIHandle()), C.DotGatesWithNeighborsHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PushBack(value *dotgatewithneighbors.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.DotGatesWithNeighbors_push_back(C.DotGatesWithNeighborsHandle(h.CAPIHandle()), C.DotGateWithNeighborsHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.DotGatesWithNeighbors_size(C.DotGatesWithNeighborsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.DotGatesWithNeighbors_empty(C.DotGatesWithNeighborsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.DotGatesWithNeighbors_erase_at(C.DotGatesWithNeighborsHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.DotGatesWithNeighbors_clear(C.DotGatesWithNeighborsHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*dotgatewithneighbors.Handle, error) {
	return cmemoryallocation.Read(h, func() (*dotgatewithneighbors.Handle, error) {

		return dotgatewithneighbors.FromCAPI(unsafe.Pointer(C.DotGatesWithNeighbors_at(C.DotGatesWithNeighborsHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() (*listdotgatewithneighbors.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listdotgatewithneighbors.Handle, error) {

		return listdotgatewithneighbors.FromCAPI(unsafe.Pointer(C.DotGatesWithNeighbors_items(C.DotGatesWithNeighborsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Contains(value *dotgatewithneighbors.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.DotGatesWithNeighbors_contains(C.DotGatesWithNeighborsHandle(h.CAPIHandle()), C.DotGateWithNeighborsHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *dotgatewithneighbors.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.DotGatesWithNeighbors_index(C.DotGatesWithNeighborsHandle(h.CAPIHandle()), C.DotGateWithNeighborsHandle(value.CAPIHandle()))), nil
	})
}
