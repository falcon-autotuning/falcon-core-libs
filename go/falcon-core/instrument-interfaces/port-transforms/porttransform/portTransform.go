package porttransform

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/instrument_interfaces/port_transforms/PortTransform_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/liststring"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringdouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/analyticfunction"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.PortTransform_destroy(C.PortTransformHandle(ptr))
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
				return unsafe.Pointer(C.PortTransform_copy(C.PortTransformHandle(handle.CAPIHandle()))), nil
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
		return bool(C.PortTransform_equal(C.PortTransformHandle(h.CAPIHandle()), C.PortTransformHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.PortTransform_not_equal(C.PortTransformHandle(h.CAPIHandle()), C.PortTransformHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.PortTransform_to_json_string(C.PortTransformHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.PortTransform_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(port *instrumentport.Handle, transform *analyticfunction.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{port, transform}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PortTransform_create(C.InstrumentPortHandle(port.CAPIHandle()), C.AnalyticFunctionHandle(transform.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewConstantTransform(port *instrumentport.Handle, value float64) (*Handle, error) {
	return cmemoryallocation.Read(port, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PortTransform_create_constant_transform(C.InstrumentPortHandle(port.CAPIHandle()), C.double(value))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewIdentityTransform(port *instrumentport.Handle) (*Handle, error) {
	return cmemoryallocation.Read(port, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PortTransform_create_identity_transform(C.InstrumentPortHandle(port.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Port() (*instrumentport.Handle, error) {
	return cmemoryallocation.Read(h, func() (*instrumentport.Handle, error) {

		return instrumentport.FromCAPI(unsafe.Pointer(C.PortTransform_port(C.PortTransformHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Labels() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.PortTransform_labels(C.PortTransformHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Evaluate(args *mapstringdouble.Handle, time float64) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, args}, func() (float64, error) {
		return float64(C.PortTransform_evaluate(C.PortTransformHandle(h.CAPIHandle()), C.MapStringDoubleHandle(args.CAPIHandle()), C.double(time))), nil
	})
}
func (h *Handle) EvaluateArraywise(args *mapstringdouble.Handle, deltaT float64, maxTime float64) (*farraydouble.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, args}, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.PortTransform_evaluate_arraywise(C.PortTransformHandle(h.CAPIHandle()), C.MapStringDoubleHandle(args.CAPIHandle()), C.double(deltaT), C.double(maxTime))))
	})
}
