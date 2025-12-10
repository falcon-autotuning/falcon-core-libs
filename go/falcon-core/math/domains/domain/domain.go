package domain

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/domains/Domain_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"

	// no extra imports
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.Domain_destroy(C.DomainHandle(ptr))
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
				return unsafe.Pointer(C.Domain_copy(C.DomainHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Domain_equal(C.DomainHandle(h.CAPIHandle()), C.DomainHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Domain_not_equal(C.DomainHandle(h.CAPIHandle()), C.DomainHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Domain_to_json_string(C.DomainHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Domain_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(min_val float64, max_val float64, lesser_bound_contained bool, greater_bound_contained bool) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.Domain_create(C.double(min_val), C.double(max_val), C.bool(lesser_bound_contained), C.bool(greater_bound_contained))), nil
		},
		construct,
		destroy,
	)
}
func (h *Handle) LesserBound() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.Domain_lesser_bound(C.DomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GreaterBound() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.Domain_greater_bound(C.DomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) LesserBoundContained() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Domain_lesser_bound_contained(C.DomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GreaterBoundContained() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Domain_greater_bound_contained(C.DomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) In(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Domain_in(C.DomainHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) Range() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.Domain_range(C.DomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Center() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.Domain_center(C.DomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Domain_intersection(C.DomainHandle(h.CAPIHandle()), C.DomainHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Union(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Domain_union(C.DomainHandle(h.CAPIHandle()), C.DomainHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) IsEmpty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Domain_is_empty(C.DomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) ContainsDomain(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Domain_contains_domain(C.DomainHandle(h.CAPIHandle()), C.DomainHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Shift(offset float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Domain_shift(C.DomainHandle(h.CAPIHandle()), C.double(offset))))
	})
}
func (h *Handle) Scale(scale float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Domain_scale(C.DomainHandle(h.CAPIHandle()), C.double(scale))))
	})
}
func (h *Handle) Transform(other *Handle, value float64) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (float64, error) {
		return float64(C.Domain_transform(C.DomainHandle(h.CAPIHandle()), C.DomainHandle(other.CAPIHandle()), C.double(value))), nil
	})
}
