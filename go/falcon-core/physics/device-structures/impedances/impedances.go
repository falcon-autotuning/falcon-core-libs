package impedances

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/device_structures/Impedances_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listimpedance"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/impedance"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.Impedances_destroy(C.ImpedancesHandle(ptr))
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
				return unsafe.Pointer(C.Impedances_copy(C.ImpedancesHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Impedances_equal(C.ImpedancesHandle(h.CAPIHandle()), C.ImpedancesHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Impedances_not_equal(C.ImpedancesHandle(h.CAPIHandle()), C.ImpedancesHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Impedances_to_json_string(C.ImpedancesHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Impedances_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.Impedances_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*impedance.Handle) (*Handle, error) {
	list, err := listimpedance.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of impedance failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(items *listimpedance.Handle) (*Handle, error) {
	return cmemoryallocation.Read(items, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Impedances_create(C.ListImpedanceHandle(items.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) PushBack(value *impedance.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.Impedances_push_back(C.ImpedancesHandle(h.CAPIHandle()), C.ImpedanceHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.Impedances_size(C.ImpedancesHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Impedances_empty(C.ImpedancesHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.Impedances_erase_at(C.ImpedancesHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.Impedances_clear(C.ImpedancesHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*impedance.Handle, error) {
	return cmemoryallocation.Read(h, func() (*impedance.Handle, error) {

		return impedance.FromCAPI(unsafe.Pointer(C.Impedances_at(C.ImpedancesHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() (*listimpedance.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listimpedance.Handle, error) {

		return listimpedance.FromCAPI(unsafe.Pointer(C.Impedances_items(C.ImpedancesHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Contains(value *impedance.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.Impedances_contains(C.ImpedancesHandle(h.CAPIHandle()), C.ImpedanceHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Impedances_intersection(C.ImpedancesHandle(h.CAPIHandle()), C.ImpedancesHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Index(value *impedance.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.Impedances_index(C.ImpedancesHandle(h.CAPIHandle()), C.ImpedanceHandle(value.CAPIHandle()))), nil
	})
}
