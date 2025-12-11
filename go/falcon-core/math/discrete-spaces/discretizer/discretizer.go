package discretizer

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/discrete_spaces/Discretizer_c_api.h>
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
		C.Discretizer_destroy(C.DiscretizerHandle(ptr))
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
				return unsafe.Pointer(C.Discretizer_copy(C.DiscretizerHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Discretizer_equal(C.DiscretizerHandle(h.CAPIHandle()), C.DiscretizerHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Discretizer_not_equal(C.DiscretizerHandle(h.CAPIHandle()), C.DiscretizerHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Discretizer_to_json_string(C.DiscretizerHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Discretizer_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianDiscretizer(delta float64) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.Discretizer_create_cartesian_discretizer(C.double(delta))), nil
		},
		construct,
		destroy,
	)
}
func NewPolarDiscretizer(delta float64) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.Discretizer_create_polar_discretizer(C.double(delta))), nil
		},
		construct,
		destroy,
	)
}
func (h *Handle) Delta() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.Discretizer_delta(C.DiscretizerHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) SetDelta(delta float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.Discretizer_set_delta(C.DiscretizerHandle(h.CAPIHandle()), C.double(delta))
		return nil
	})
}
func (h *Handle) Domain() (*domain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*domain.Handle, error) {

		return domain.FromCAPI(unsafe.Pointer(C.Discretizer_domain(C.DiscretizerHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) IsCartesian() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Discretizer_is_cartesian(C.DiscretizerHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsPolar() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Discretizer_is_polar(C.DiscretizerHandle(h.CAPIHandle()))), nil
	})
}
