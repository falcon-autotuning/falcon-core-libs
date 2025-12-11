package analyticfunction

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AnalyticFunction_c_api.h>
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
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.AnalyticFunction_destroy(C.AnalyticFunctionHandle(ptr))
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
				return unsafe.Pointer(C.AnalyticFunction_copy(C.AnalyticFunctionHandle(handle.CAPIHandle()))), nil
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
		return bool(C.AnalyticFunction_equal(C.AnalyticFunctionHandle(h.CAPIHandle()), C.AnalyticFunctionHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.AnalyticFunction_not_equal(C.AnalyticFunctionHandle(h.CAPIHandle()), C.AnalyticFunctionHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AnalyticFunction_to_json_string(C.AnalyticFunctionHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AnalyticFunction_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(labels *liststring.Handle, expression string) (*Handle, error) {
	realexpression := str.New(expression)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{labels, realexpression}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AnalyticFunction_create(C.ListStringHandle(labels.CAPIHandle()), C.StringHandle(realexpression.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewIdentity() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.AnalyticFunction_create_identity()), nil
		},
		construct,
		destroy,
	)
}
func NewConstant(value float64) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.AnalyticFunction_create_constant(C.double(value))), nil
		},
		construct,
		destroy,
	)
}
func (h *Handle) Labels() (*liststring.Handle, error) {
	return cmemoryallocation.Read(h, func() (*liststring.Handle, error) {

		return liststring.FromCAPI(unsafe.Pointer(C.AnalyticFunction_labels(C.AnalyticFunctionHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Evaluate(args *mapstringdouble.Handle, time float64) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, args}, func() (float64, error) {
		return float64(C.AnalyticFunction_evaluate(C.AnalyticFunctionHandle(h.CAPIHandle()), C.MapStringDoubleHandle(args.CAPIHandle()), C.double(time))), nil
	})
}
func (h *Handle) EvaluateArraywise(args *mapstringdouble.Handle, deltaT float64, maxTime float64) (*farraydouble.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, args}, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.AnalyticFunction_evaluate_arraywise(C.AnalyticFunctionHandle(h.CAPIHandle()), C.MapStringDoubleHandle(args.CAPIHandle()), C.double(deltaT), C.double(maxTime))))
	})
}
