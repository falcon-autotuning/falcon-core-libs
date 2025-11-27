package pairinterpretationcontextdouble

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/PairInterpretationContextDouble_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/interpretations/interpretationcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
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
		C.PairInterpretationContextDouble_destroy(C.PairInterpretationContextDoubleHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(first *interpretationcontext.Handle, second float64) (*Handle, error) {
	return cmemoryallocation.Read(first, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PairInterpretationContextDouble_create(C.InterpretationContextHandle(first.CAPIHandle()), C.double(second))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) First() (*interpretationcontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*interpretationcontext.Handle, error) {

		return interpretationcontext.FromCAPI(unsafe.Pointer(C.PairInterpretationContextDouble_first(C.PairInterpretationContextDoubleHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Second() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.PairInterpretationContextDouble_second(C.PairInterpretationContextDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.PairInterpretationContextDouble_equal(C.PairInterpretationContextDoubleHandle(h.CAPIHandle()), C.PairInterpretationContextDoubleHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.PairInterpretationContextDouble_not_equal(C.PairInterpretationContextDoubleHandle(h.CAPIHandle()), C.PairInterpretationContextDoubleHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.PairInterpretationContextDouble_to_json_string(C.PairInterpretationContextDoubleHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.PairInterpretationContextDouble_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
