package unitspace

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/UnitSpace_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescontrolarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdiscretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.UnitSpace_destroy(C.UnitSpaceHandle(ptr))
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
				return unsafe.Pointer(C.UnitSpace_copy(C.UnitSpaceHandle(handle.CAPIHandle()))), nil
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
		return bool(C.UnitSpace_equal(C.UnitSpaceHandle(h.CAPIHandle()), C.UnitSpaceHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.UnitSpace_not_equal(C.UnitSpaceHandle(h.CAPIHandle()), C.UnitSpaceHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.UnitSpace_to_json_string(C.UnitSpaceHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.UnitSpace_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(axes *axesdiscretizer.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{axes, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.UnitSpace_create(C.AxesDiscretizerHandle(axes.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewRaySpace(dr float64, dtheta float64, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.Read(domain, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.UnitSpace_create_ray_space(C.double(dr), C.double(dtheta), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianSpace(deltas *axesdouble.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{deltas, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.UnitSpace_create_cartesian_space(C.AxesDoubleHandle(deltas.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesian1DSpace(delta float64, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.Read(domain, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.UnitSpace_create_cartesian_1D_space(C.double(delta), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesian2DSpace(deltas *axesdouble.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{deltas, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.UnitSpace_create_cartesian_2D_space(C.AxesDoubleHandle(deltas.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Axes() (*axesdiscretizer.Handle, error) {
	return cmemoryallocation.Read(h, func() (*axesdiscretizer.Handle, error) {

		return axesdiscretizer.FromCAPI(unsafe.Pointer(C.UnitSpace_axes(C.UnitSpaceHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Domain() (*domain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*domain.Handle, error) {

		return domain.FromCAPI(unsafe.Pointer(C.UnitSpace_domain(C.UnitSpaceHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Space() (*farraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.UnitSpace_space(C.UnitSpaceHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Shape() (*listint.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listint.Handle, error) {

		return listint.FromCAPI(unsafe.Pointer(C.UnitSpace_shape(C.UnitSpaceHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Dimension() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.UnitSpace_dimension(C.UnitSpaceHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Compile() error {
	return cmemoryallocation.Write(h, func() error {
		C.UnitSpace_compile(C.UnitSpaceHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) CreateArray(axes *axesint.Handle) (*axescontrolarray.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, axes}, func() (*axescontrolarray.Handle, error) {

		return axescontrolarray.FromCAPI(unsafe.Pointer(C.UnitSpace_create_array(C.UnitSpaceHandle(h.CAPIHandle()), C.AxesIntHandle(axes.CAPIHandle()))))
	})
}
func (h *Handle) PushBack(value *discretizer.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.UnitSpace_push_back(C.UnitSpaceHandle(h.CAPIHandle()), C.DiscretizerHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.UnitSpace_size(C.UnitSpaceHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.UnitSpace_empty(C.UnitSpaceHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.UnitSpace_erase_at(C.UnitSpaceHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.UnitSpace_clear(C.UnitSpaceHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*discretizer.Handle, error) {
	return cmemoryallocation.Read(h, func() (*discretizer.Handle, error) {

		return discretizer.FromCAPI(unsafe.Pointer(C.UnitSpace_at(C.UnitSpaceHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*discretizer.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.UnitSpace_size(C.UnitSpaceHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.DiscretizerHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.UnitSpace_items(C.UnitSpaceHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*discretizer.Handle, dim)
	for i := range out {
		realout[i], err = discretizer.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("Items: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Contains(value *discretizer.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.UnitSpace_contains(C.UnitSpaceHandle(h.CAPIHandle()), C.DiscretizerHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *discretizer.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.UnitSpace_index(C.UnitSpaceHandle(h.CAPIHandle()), C.DiscretizerHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.UnitSpace_intersection(C.UnitSpaceHandle(h.CAPIHandle()), C.UnitSpaceHandle(other.CAPIHandle()))))
	})
}
