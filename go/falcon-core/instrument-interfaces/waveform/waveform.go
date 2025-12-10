package waveform

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/instrument_interfaces/Waveform_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/port-transforms/porttransform"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axescoupledlabelleddomain"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesint"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/axesmapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretespace"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/domains/coupledlabelleddomain"
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
		C.Waveform_destroy(C.WaveformHandle(ptr))
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
				return unsafe.Pointer(C.Waveform_copy(C.WaveformHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Waveform_equal(C.WaveformHandle(h.CAPIHandle()), C.WaveformHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Waveform_not_equal(C.WaveformHandle(h.CAPIHandle()), C.WaveformHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Waveform_to_json_string(C.WaveformHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Waveform_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(space *discretespace.Handle, transforms *listporttransform.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{space, transforms}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Waveform_create(C.DiscreteSpaceHandle(space.CAPIHandle()), C.ListPortTransformHandle(transforms.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianWaveform(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, transforms *listporttransform.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{divisions, axes, increasing, transforms, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Waveform_create_cartesian_waveform(C.AxesIntHandle(divisions.CAPIHandle()), C.AxesCoupledLabelledDomainHandle(axes.CAPIHandle()), C.AxesMapStringBoolHandle(increasing.CAPIHandle()), C.ListPortTransformHandle(transforms.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianIdentityWaveform(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{divisions, axes, increasing, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Waveform_create_cartesian_identity_waveform(C.AxesIntHandle(divisions.CAPIHandle()), C.AxesCoupledLabelledDomainHandle(axes.CAPIHandle()), C.AxesMapStringBoolHandle(increasing.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianWaveform2D(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, transforms *listporttransform.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{divisions, axes, increasing, transforms, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Waveform_create_cartesian_waveform_2D(C.AxesIntHandle(divisions.CAPIHandle()), C.AxesCoupledLabelledDomainHandle(axes.CAPIHandle()), C.AxesMapStringBoolHandle(increasing.CAPIHandle()), C.ListPortTransformHandle(transforms.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianIdentityWaveform2D(divisions *axesint.Handle, axes *axescoupledlabelleddomain.Handle, increasing *axesmapstringbool.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{divisions, axes, increasing, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Waveform_create_cartesian_identity_waveform_2D(C.AxesIntHandle(divisions.CAPIHandle()), C.AxesCoupledLabelledDomainHandle(axes.CAPIHandle()), C.AxesMapStringBoolHandle(increasing.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianWaveform1D(division int32, shared_domain *coupledlabelleddomain.Handle, increasing *mapstringbool.Handle, transforms *listporttransform.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{shared_domain, increasing, transforms, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Waveform_create_cartesian_waveform_1D(C.int(division), C.CoupledLabelledDomainHandle(shared_domain.CAPIHandle()), C.MapStringBoolHandle(increasing.CAPIHandle()), C.ListPortTransformHandle(transforms.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewCartesianIdentityWaveform1D(division int32, shared_domain *coupledlabelleddomain.Handle, increasing *mapstringbool.Handle, domain *domain.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{shared_domain, increasing, domain}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Waveform_create_cartesian_identity_waveform_1D(C.int(division), C.CoupledLabelledDomainHandle(shared_domain.CAPIHandle()), C.MapStringBoolHandle(increasing.CAPIHandle()), C.DomainHandle(domain.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Space() (*discretespace.Handle, error) {
	return cmemoryallocation.Read(h, func() (*discretespace.Handle, error) {

		return discretespace.FromCAPI(unsafe.Pointer(C.Waveform_space(C.WaveformHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Transforms() (*listporttransform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listporttransform.Handle, error) {

		return listporttransform.FromCAPI(unsafe.Pointer(C.Waveform_transforms(C.WaveformHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) PushBack(value *porttransform.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.Waveform_push_back(C.WaveformHandle(h.CAPIHandle()), C.PortTransformHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.Waveform_size(C.WaveformHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Waveform_empty(C.WaveformHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.Waveform_erase_at(C.WaveformHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.Waveform_clear(C.WaveformHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*porttransform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*porttransform.Handle, error) {

		return porttransform.FromCAPI(unsafe.Pointer(C.Waveform_at(C.WaveformHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() (*listporttransform.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listporttransform.Handle, error) {

		return listporttransform.FromCAPI(unsafe.Pointer(C.Waveform_items(C.WaveformHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Contains(value *porttransform.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.Waveform_contains(C.WaveformHandle(h.CAPIHandle()), C.PortTransformHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *porttransform.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.Waveform_index(C.WaveformHandle(h.CAPIHandle()), C.PortTransformHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Waveform_intersection(C.WaveformHandle(h.CAPIHandle()), C.WaveformHandle(other.CAPIHandle()))))
	})
}
