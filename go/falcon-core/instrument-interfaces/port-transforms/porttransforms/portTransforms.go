package porttransforms

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/instrument_interfaces/port_transforms/PortTransforms_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listporttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.PortTransforms_destroy(C.PortTransformsHandle(ptr))
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
				return unsafe.Pointer(C.PortTransforms_copy(C.PortTransformsHandle(handle.CAPIHandle()))), nil
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
		return bool(C.PortTransforms_equal(C.PortTransformsHandle(h.CAPIHandle()), C.PortTransformsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.PortTransforms_not_equal(C.PortTransformsHandle(h.CAPIHandle()), C.PortTransformsHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.PortTransforms_to_json_string(C.PortTransformsHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.PortTransforms_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.PortTransforms_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*porttransform.Handle) (*Handle, error) {
	list, err := listporttransform.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of porttransform failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(handle *listporttransform.Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PortTransforms_create(C.ListPortTransformHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Transforms() (*listporttransform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listporttransform.Handle, error) {

		return listporttransform.FromCAPI(unsafe.Pointer(C.PortTransforms_transforms(C.PortTransformsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) PushBack(value *porttransform.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.PortTransforms_push_back(C.PortTransformsHandle(h.CAPIHandle()), C.PortTransformHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.PortTransforms_size(C.PortTransformsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.PortTransforms_empty(C.PortTransformsHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.PortTransforms_erase_at(C.PortTransformsHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.PortTransforms_clear(C.PortTransformsHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*porttransform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*porttransform.Handle, error) {

		return porttransform.FromCAPI(unsafe.Pointer(C.PortTransforms_at(C.PortTransformsHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() (*listporttransform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listporttransform.Handle, error) {

		return listporttransform.FromCAPI(unsafe.Pointer(C.PortTransforms_items(C.PortTransformsHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Contains(value *porttransform.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.PortTransforms_contains(C.PortTransformsHandle(h.CAPIHandle()), C.PortTransformHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *porttransform.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.PortTransforms_index(C.PortTransformsHandle(h.CAPIHandle()), C.PortTransformHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.PortTransforms_intersection(C.PortTransformsHandle(h.CAPIHandle()), C.PortTransformsHandle(other.CAPIHandle()))))
	})
}
