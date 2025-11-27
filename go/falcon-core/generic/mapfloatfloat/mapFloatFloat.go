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
func New(data []*pairfloatfloat.Handle) (*Handle, error) {
	list := make([]C.PairFloatFloatHandle, len(data))
	for i, v := range data {
		list[i] = C.PairFloatFloatHandle(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.MapFloatFloat_create(&list[0], C.size_t(len(data)))), nil
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
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.MapFloatFloat_size(C.MapFloatFloatHandle(h.CAPIHandle()))), nil
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
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapFloatFloat_equal(C.MapFloatFloatHandle(h.CAPIHandle()), C.MapFloatFloatHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MapFloatFloat_not_equal(C.MapFloatFloatHandle(h.CAPIHandle()), C.MapFloatFloatHandle(b.CAPIHandle()))), nil
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
