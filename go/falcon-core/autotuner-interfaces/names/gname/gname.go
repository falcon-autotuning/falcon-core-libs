package gname

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/names/Gname_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"

	// no extra imports
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
		C.Gname_destroy(C.GnameHandle(ptr))
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
				return unsafe.Pointer(C.Gname_copy(C.GnameHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Gname_equal(C.GnameHandle(h.CAPIHandle()), C.GnameHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Gname_not_equal(C.GnameHandle(h.CAPIHandle()), C.GnameHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Gname_to_json_string(C.GnameHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Gname_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromNum(num int32) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.Gname_create_from_num(C.int(num))), nil
		},
		construct,
		destroy,
	)
}
func New(name string) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.Read(realname, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Gname_create(C.StringHandle(realname.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Gname() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Gname_gname(C.GnameHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Gname:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
