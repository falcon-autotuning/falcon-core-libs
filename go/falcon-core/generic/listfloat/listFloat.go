package listfloat

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/ListFloat_c_api.h>
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
		C.ListFloat_destroy(C.ListFloatHandle(ptr))
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
			return unsafe.Pointer(C.ListFloat_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func Allocate(count uint32) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListFloat_allocate(C.size_t(count))), nil
		},
		construct,
		destroy,
	)
}
func FillValue(count uint32, value float32) (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListFloat_fill_value(C.size_t(count), C.float(value))), nil
		},
		construct,
		destroy,
	)
}
func New(data []float32) (*Handle, error) {
	list := make([]C.float, len(data))
	for i, v := range data {
		list[i] = C.float(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ListFloat_create(&list[0], C.size_t(len(data)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value float32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListFloat_push_back(C.ListFloatHandle(h.CAPIHandle()), C.float(value))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.ListFloat_size(C.ListFloatHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListFloat_empty(C.ListFloatHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ListFloat_erase_at(C.ListFloatHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.ListFloat_clear(C.ListFloatHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (float32, error) {
	return cmemoryallocation.Read(h, func() (float32, error) {
		return float32(C.ListFloat_at(C.ListFloatHandle(h.CAPIHandle()), C.size_t(idx))), nil
	})
}
func (h *Handle) Items() ([]float32, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ListFloat_size(C.ListFloatHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.float, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ListFloat_items(C.ListFloatHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]float32, dim)
	for i := range out {
		realout[i] = float32(out[i])

	}
	return realout, nil
}
func (h *Handle) Contains(value float32) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ListFloat_contains(C.ListFloatHandle(h.CAPIHandle()), C.float(value))), nil
	})
}
func (h *Handle) Index(value float32) (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.ListFloat_index(C.ListFloatHandle(h.CAPIHandle()), C.float(value))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ListFloat_intersection(C.ListFloatHandle(h.CAPIHandle()), C.ListFloatHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListFloat_equal(C.ListFloatHandle(h.CAPIHandle()), C.ListFloatHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.ListFloat_not_equal(C.ListFloatHandle(h.CAPIHandle()), C.ListFloatHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ListFloat_to_json_string(C.ListFloatHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ListFloat_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
