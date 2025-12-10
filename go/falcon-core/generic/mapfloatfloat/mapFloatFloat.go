package mapfloatfloat

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/MapFloatFloat_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listfloat"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listpairfloatfloat"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairfloatfloat"
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
		C.MapFloatFloat_destroy(C.MapFloatFloatHandle(ptr))
	}
)

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
			return unsafe.Pointer(C.MapFloatFloat_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MapFloatFloat_copy(C.MapFloatFloatHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(data []*pairfloatfloat.Handle) (*Handle, error) {
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
	size := C.size_t(n) * C.size_t(unsafe.Sizeof(C.PairFloatFloatHandle(nil)))
	cList := C.malloc(size)
	if cList == nil {
		return nil, errors.New("C.malloc failed")
	}
	// Copy Go data to C memory
	slice := (*[1 << 30]C.PairFloatFloatHandle)(cList)[:n:n]
	for i, v := range data {
		slice[i] = C.PairFloatFloatHandle(v.CAPIHandle())
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.MapFloatFloat_create((*C.PairFloatFloatHandle)(cList), C.size_t(n)))
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
func (h *Handle) InsertOrAssign(key float32, value float32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MapFloatFloat_insert_or_assign(C.MapFloatFloatHandle(h.CAPIHandle()), C.float(key), C.float(value))
		return nil
	})
}
func (h *Handle) Insert(key float32, value float32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MapFloatFloat_insert(C.MapFloatFloatHandle(h.CAPIHandle()), C.float(key), C.float(value))
		return nil
	})
}
func (h *Handle) At(key float32) (float32, error) {
	return cmemoryallocation.Read(h, func() (float32, error) {
		return float32(C.MapFloatFloat_at(C.MapFloatFloatHandle(h.CAPIHandle()), C.float(key))), nil
	})
}
func (h *Handle) Erase(key float32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MapFloatFloat_erase(C.MapFloatFloatHandle(h.CAPIHandle()), C.float(key))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MapFloatFloat_size(C.MapFloatFloatHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapFloatFloat_empty(C.MapFloatFloatHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.MapFloatFloat_clear(C.MapFloatFloatHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Contains(key float32) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MapFloatFloat_contains(C.MapFloatFloatHandle(h.CAPIHandle()), C.float(key))), nil
	})
}
func (h *Handle) Keys() (*listfloat.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listfloat.Handle, error) {

		return listfloat.FromCAPI(unsafe.Pointer(C.MapFloatFloat_keys(C.MapFloatFloatHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Values() (*listfloat.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listfloat.Handle, error) {

		return listfloat.FromCAPI(unsafe.Pointer(C.MapFloatFloat_values(C.MapFloatFloatHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Items() (*listpairfloatfloat.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listpairfloatfloat.Handle, error) {

		return listpairfloatfloat.FromCAPI(unsafe.Pointer(C.MapFloatFloat_items(C.MapFloatFloatHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapFloatFloat_equal(C.MapFloatFloatHandle(h.CAPIHandle()), C.MapFloatFloatHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MapFloatFloat_not_equal(C.MapFloatFloatHandle(h.CAPIHandle()), C.MapFloatFloatHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MapFloatFloat_to_json_string(C.MapFloatFloatHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MapFloatFloat_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
