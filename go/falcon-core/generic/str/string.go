package str

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{
			FalconCoreHandle: falconcorehandle.Construct(ptr),
		}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.String_destroy(C.StringHandle(ptr))
	}
)

// --- Constructors using cmemoryallocation ---

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}

func New(raw string) *Handle {
	out, _ := cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.String_create(C.CString(raw), C.size_t(len(raw)))), nil
		},
		construct,
		destroy)
	return out
}

// --- Destroy method using cmemoryallocation.CloseAllocation ---

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}

func (h *Handle) ToGoString() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {
		sh := (*C.struct_string)(unsafe.Pointer(h.CAPIHandle()))
		return C.GoStringN(sh.raw, C.int(sh.length)), nil
	})
}
