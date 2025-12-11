package listbool

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListBool_c_api.h>
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
		C.ListBool_destroy(C.ListBoolHandle(ptr))
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
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListBool_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ListBool_copy(C.ListBoolHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func Allocate(count uint64) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListBool_allocate(C.size_t(count))), nil
		},
		construct,
		destroy,
	)
}
func FillValue(count uint64, value bool) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListBool_fill_value(C.size_t(count), C.bool(value))), nil
		},
		construct,
		destroy,
	)
}
func New(data []bool) (*Handle, error) {
	n := len(data)
	if n == 0 {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(nil), nil
			},
			construct,
			destroy,
		)
	}
	size := C.size_t(n) * C.size_t(unsafe.Sizeof(C.bool(false)))
	cList := C.malloc(size)
	if cList == nil {
		return nil, errors.New("C.malloc failed")
	}
	// Copy Go data to C memory
	slice := (*[1 << 30]C.bool)(cList)[:n:n]
	for i, v := range data {
		slice[i] = C.bool(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.ListBool_create((*C.bool)(cList), C.size_t(n)))
			C.free(cList)
			return res, nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value bool) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListBool_push_back(C.ListBoolHandle(h.CAPIHandle()), C.bool(value))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.ListBool_size(C.ListBoolHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListBool_empty(C.ListBoolHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListBool_erase_at(C.ListBoolHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListBool_clear(C.ListBoolHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListBool_at(C.ListBoolHandle(h.CAPIHandle()), C.size_t(idx))), nil
	})
}
func (h *Handle) Items() ([]bool, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListBool_size(C.ListBoolHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.bool, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListBool_items(C.ListBoolHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]bool, dim)
	for i := range out {
		realout[i] = bool(out[i])

	}
	return realout, nil
}
func (h *Handle) Contains(value bool) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListBool_contains(C.ListBoolHandle(h.CAPIHandle()), C.bool(value))), nil
	})
}
func (h *Handle) Index(value bool) (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.ListBool_index(C.ListBoolHandle(h.CAPIHandle()), C.bool(value))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListBool_intersection(C.ListBoolHandle(h.CAPIHandle()), C.ListBoolHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListBool_equal(C.ListBoolHandle(h.CAPIHandle()), C.ListBoolHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ListBool_not_equal(C.ListBoolHandle(h.CAPIHandle()), C.ListBoolHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListBool_to_json_string(C.ListBoolHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListBool_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
