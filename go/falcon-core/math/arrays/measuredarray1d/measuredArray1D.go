package measuredarray1d
/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/MeasuredArray1D_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"unsafe"
	"errors"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	---------INSERT-IMPORTS---------
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)
type Handle struct { falconcorehandle.FalconCoreHandle }
var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.MeasuredArray1D_destroy(C.MeasuredArray1DHandle(ptr))
	}
)
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
