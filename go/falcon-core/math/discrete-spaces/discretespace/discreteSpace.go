package discretespace

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/discrete_spaces/DiscreteSpace_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesinstrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axeslabelledcontrolarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/unitspace"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.DiscreteSpace_destroy(C.DiscreteSpaceHandle(ptr))
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
				return unsafe.Pointer(C.DiscreteSpace_copy(C.DiscreteSpaceHandle(handle.CAPIHandle()))), nil
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
		return bool(C.DiscreteSpace_equal(C.DiscreteSpaceHandle(h.CAPIHandle()), C.DiscreteSpaceHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.DiscreteSpace_not_equal(C.DiscreteSpaceHandle(h.CAPIHandle()), C.DiscreteSpaceHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.DiscreteSpace_to_json_string(C.DiscreteSpaceHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.DiscreteSpace_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(space *unitspace.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{space, axes, increasing}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.DiscreteSpace_create(C.UnitSpaceHandle(space.CAPIHandle()), C.AxesCoupledLabelledDomainHandle(axes.CAPIHandle()), C.AxesMapStringBoolHandle(increasing.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianDiscreteSpace(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{divisions, axes, increasing, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.DiscreteSpace_create_cartesian_discrete_space(C.AxesIntHandle(divisions.CAPIHandle()), C.AxesCoupledLabelledDomainHandle(axes.CAPIHandle()), C.AxesMapStringBoolHandle(increasing.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianDiscreteSpace1D(division int32, shared_domain *coupledlabelleddomain.Handle, increasing *mapstringbool.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{shared_domain, increasing, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.DiscreteSpace_create_cartesian_discrete_space_1D(C.int(division), C.CoupledLabelledDomainHandle(shared_domain.CAPIHandle()), C.MapStringBoolHandle(increasing.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Space() (*unitspace.Handle, error) {
	return cmemoryallocation.Read(h, func() (*unitspace.Handle, error) {

		return unitspace.FromCAPI(unsafe.Pointer(C.DiscreteSpace_space(C.DiscreteSpaceHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Axes() (*axescoupledlabelleddomain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*axescoupledlabelleddomain.Handle, error) {

		return axescoupledlabelleddomain.FromCAPI(unsafe.Pointer(C.DiscreteSpace_axes(C.DiscreteSpaceHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Increasing() (*axesmapstringbool.Handle, error) {
	return cmemoryallocation.Read(h, func() (*axesmapstringbool.Handle, error) {

		return axesmapstringbool.FromCAPI(unsafe.Pointer(C.DiscreteSpace_increasing(C.DiscreteSpaceHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Knobs() (*ports.Handle, error) {
	return cmemoryallocation.Read(h, func() (*ports.Handle, error) {

		return ports.FromCAPI(unsafe.Pointer(C.DiscreteSpace_knobs(C.DiscreteSpaceHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) ValidateUnitSpaceDimensionalityMatchesKnobs() error {
	return cmemoryallocation.Write(h, func() error {
		C.DiscreteSpace_validate_unit_space_dimensionality_matches_knobs(C.DiscreteSpaceHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) ValidateKnobUniqueness() error {
	return cmemoryallocation.Write(h, func() error {
		C.DiscreteSpace_validate_knob_uniqueness(C.DiscreteSpaceHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) GetAxis(knob *instrumentport.Handle) (int32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, knob}, func() (int32, error) {
		return int32(C.DiscreteSpace_get_axis(C.DiscreteSpaceHandle(h.CAPIHandle()), C.InstrumentPortHandle(knob.CAPIHandle()))), nil
	})
}
func (h *Handle) GetDomain(knob *instrumentport.Handle) (*domain.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, knob}, func() (*domain.Handle, error) {

		return domain.FromCAPI(unsafe.Pointer(C.DiscreteSpace_get_domain(C.DiscreteSpaceHandle(h.CAPIHandle()), C.InstrumentPortHandle(knob.CAPIHandle()))))
	})
}
func (h *Handle) GetProjection(projection *axesinstrumentport.Handle) (*axeslabelledcontrolarray.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, projection}, func() (*axeslabelledcontrolarray.Handle, error) {

		return axeslabelledcontrolarray.FromCAPI(unsafe.Pointer(C.DiscreteSpace_get_projection(C.DiscreteSpaceHandle(h.CAPIHandle()), C.AxesInstrumentPortHandle(projection.CAPIHandle()))))
	})
}
