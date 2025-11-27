package pairinterpretationcontextstring

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/PairInterpretationContextString_c_api.h>
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
		C.PairInterpretationContextString_destroy(C.PairInterpretationContextStringHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(first *interpretationcontext.Handle, second string) (*Handle, error) {
	realsecond := str.New(second)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{first, realsecond}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.PairInterpretationContextString_create(C.InterpretationContextHandle(first.CAPIHandle()), C.StringHandle(realsecond.CAPIHandle()))), nil
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

		return interpretationcontext.FromCAPI(unsafe.Pointer(C.PairInterpretationContextString_first(C.PairInterpretationContextStringHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Second() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.PairInterpretationContextString_second(C.PairInterpretationContextStringHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Second:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.PairInterpretationContextString_equal(C.PairInterpretationContextStringHandle(h.CAPIHandle()), C.PairInterpretationContextStringHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.PairInterpretationContextString_not_equal(C.PairInterpretationContextStringHandle(h.CAPIHandle()), C.PairInterpretationContextStringHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.PairInterpretationContextString_to_json_string(C.PairInterpretationContextStringHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.PairInterpretationContextString_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
