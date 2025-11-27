package axesdouble

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AxesDouble_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdouble"
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
		C.AxesDouble_destroy(C.AxesDoubleHandle(ptr))
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
			return unsafe.Pointer(C.AxesDouble_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []float64) (*Handle, error) {
	list, err := listdouble.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of double failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(data *listdouble.Handle) (*Handle, error) {
	return cmemoryallocation.Read(data, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesDouble_create(C.ListDoubleHandle(data.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesDouble_push_back(C.AxesDoubleHandle(h.CAPIHandle()), C.double(value))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.AxesDouble_size(C.AxesDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesDouble_empty(C.AxesDoubleHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesDouble_erase_at(C.AxesDoubleHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesDouble_clear(C.AxesDoubleHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.AxesDouble_at(C.AxesDoubleHandle(h.CAPIHandle()), C.size_t(idx))), nil
	})
}
func (h *Handle) Items() ([]float64, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.AxesDouble_size(C.AxesDoubleHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: size errored"), err)
	}
	out := make([]C.double, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.AxesDouble_items(C.AxesDoubleHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]float64, dim)
	for i := range out {
		realout[i] = float64(out[i])

	}
	return realout, nil
}
func (h *Handle) Contains(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesDouble_contains(C.AxesDoubleHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) Index(value float64) (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.AxesDouble_index(C.AxesDoubleHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.AxesDouble_intersection(C.AxesDoubleHandle(h.CAPIHandle()), C.AxesDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesDouble_equal(C.AxesDoubleHandle(h.CAPIHandle()), C.AxesDoubleHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesDouble_not_equal(C.AxesDoubleHandle(h.CAPIHandle()), C.AxesDoubleHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AxesDouble_to_json_string(C.AxesDoubleHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AxesDouble_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
