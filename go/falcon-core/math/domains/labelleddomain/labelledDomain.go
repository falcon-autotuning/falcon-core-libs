package labelleddomain

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/domains/LabelledDomain_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/domain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.LabelledDomain_destroy(C.LabelledDomainHandle(ptr))
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
				return unsafe.Pointer(C.LabelledDomain_copy(C.LabelledDomainHandle(handle.CAPIHandle()))), nil
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
		return bool(C.LabelledDomain_equal(C.LabelledDomainHandle(h.CAPIHandle()), C.LabelledDomainHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledDomain_not_equal(C.LabelledDomainHandle(h.CAPIHandle()), C.LabelledDomainHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledDomain_to_json_string(C.LabelledDomainHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.LabelledDomain_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewPrimitiveKnob(default_name string, min_val float64, max_val float64, psuedo_name *connection.Handle, instrument_type string, lesser_bound_contained bool, greater_bound_contained bool, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_type := str.New(instrument_type)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, psuedo_name, realinstrument_type, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledDomain_create_primitive_knob(C.StringHandle(realdefault_name.CAPIHandle()), C.double(min_val), C.double(max_val), C.ConnectionHandle(psuedo_name.CAPIHandle()), C.StringHandle(realinstrument_type.CAPIHandle()), C.bool(lesser_bound_contained), C.bool(greater_bound_contained), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewPrimitiveMeter(default_name string, min_val float64, max_val float64, psuedo_name *connection.Handle, instrument_type string, lesser_bound_contained bool, greater_bound_contained bool, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_type := str.New(instrument_type)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, psuedo_name, realinstrument_type, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledDomain_create_primitive_meter(C.StringHandle(realdefault_name.CAPIHandle()), C.double(min_val), C.double(max_val), C.ConnectionHandle(psuedo_name.CAPIHandle()), C.StringHandle(realinstrument_type.CAPIHandle()), C.bool(lesser_bound_contained), C.bool(greater_bound_contained), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewPrimitivePort(default_name string, min_val float64, max_val float64, psuedo_name *connection.Handle, instrument_type string, lesser_bound_contained bool, greater_bound_contained bool, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_type := str.New(instrument_type)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, psuedo_name, realinstrument_type, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledDomain_create_primitive_port(C.StringHandle(realdefault_name.CAPIHandle()), C.double(min_val), C.double(max_val), C.ConnectionHandle(psuedo_name.CAPIHandle()), C.StringHandle(realinstrument_type.CAPIHandle()), C.bool(lesser_bound_contained), C.bool(greater_bound_contained), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromPort(min_val float64, max_val float64, port *instrumentport.Handle, lesser_bound_contained bool, greater_bound_contained bool) (*Handle, error) {
	return cmemoryallocation.Read(port, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledDomain_create_from_port(C.double(min_val), C.double(max_val), C.InstrumentPortHandle(port.CAPIHandle()), C.bool(lesser_bound_contained), C.bool(greater_bound_contained))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromPortAndDomain(port *instrumentport.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{port, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledDomain_create_from_port_and_domain(C.InstrumentPortHandle(port.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromDomain(domain *domain.Handle, default_name string, psuedo_name *connection.Handle, instrument_type string, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_type := str.New(instrument_type)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{domain, realdefault_name, psuedo_name, realinstrument_type, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledDomain_create_from_domain(C.DomainHandle(domain.CAPIHandle()), C.StringHandle(realdefault_name.CAPIHandle()), C.ConnectionHandle(psuedo_name.CAPIHandle()), C.StringHandle(realinstrument_type.CAPIHandle()), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Port() (*instrumentport.Handle, error) {
	return cmemoryallocation.Read(h, func() (*instrumentport.Handle, error) {

		return instrumentport.FromCAPI(unsafe.Pointer(C.LabelledDomain_port(C.LabelledDomainHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Domain() (*domain.Handle, error) {
	return cmemoryallocation.Read(h, func() (*domain.Handle, error) {

		return domain.FromCAPI(unsafe.Pointer(C.LabelledDomain_domain(C.LabelledDomainHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) MatchingPort(port *instrumentport.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, port}, func() (bool, error) {
		return bool(C.LabelledDomain_matching_port(C.LabelledDomainHandle(h.CAPIHandle()), C.InstrumentPortHandle(port.CAPIHandle()))), nil
	})
}
func (h *Handle) LesserBound() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledDomain_lesser_bound(C.LabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GreaterBound() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledDomain_greater_bound(C.LabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) LesserBoundContained() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledDomain_lesser_bound_contained(C.LabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GreaterBoundContained() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledDomain_greater_bound_contained(C.LabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) In(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledDomain_in(C.LabelledDomainHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) Range() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledDomain_range(C.LabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Center() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledDomain_center(C.LabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledDomain_intersection(C.LabelledDomainHandle(h.CAPIHandle()), C.LabelledDomainHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Union(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledDomain_union(C.LabelledDomainHandle(h.CAPIHandle()), C.LabelledDomainHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) IsEmpty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledDomain_is_empty(C.LabelledDomainHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) ContainsDomain(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledDomain_contains_domain(C.LabelledDomainHandle(h.CAPIHandle()), C.LabelledDomainHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Shift(offset float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledDomain_shift(C.LabelledDomainHandle(h.CAPIHandle()), C.double(offset))))
	})
}
func (h *Handle) Scale(scale float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledDomain_scale(C.LabelledDomainHandle(h.CAPIHandle()), C.double(scale))))
	})
}
func (h *Handle) Transform(other *Handle, value float64) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (float64, error) {
		return float64(C.LabelledDomain_transform(C.LabelledDomainHandle(h.CAPIHandle()), C.LabelledDomainHandle(other.CAPIHandle()), C.double(value))), nil
	})
}
