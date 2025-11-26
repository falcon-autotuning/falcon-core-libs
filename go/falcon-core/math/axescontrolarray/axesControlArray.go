package axescontrolarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AxesControlArray_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listcontrolarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.AxesControlArray_destroy(C.AxesControlArrayHandle(ptr))
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
			return unsafe.Pointer(C.AxesControlArray_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*controlarray.Handle) (*Handle, error) {
	list, err := listcontrolarray.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of controlarray failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(data *listcontrolarray.Handle) (*Handle, error) {
	return cmemoryallocation.Read(data, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesControlArray_create(C.ListControlArrayHandle(data.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *controlarray.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.AxesControlArray_push_back(C.AxesControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.AxesControlArray_size(C.AxesControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesControlArray_empty(C.AxesControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesControlArray_erase_at(C.AxesControlArrayHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesControlArray_clear(C.AxesControlArrayHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*controlarray.Handle, error) {
	return cmemoryallocation.Read(h, func() (*controlarray.Handle, error) {

		return controlarray.FromCAPI(unsafe.Pointer(C.AxesControlArray_at(C.AxesControlArrayHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*controlarray.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.AxesControlArray_dimension(C.AxesControlArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: dimension errored"), err)
	}
	out := make([]C.ControlArrayHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.AxesControlArray_items(C.AxesControlArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*controlarray.Handle, dim)
	for i := range out {
		realout[i] = *controlarray.Handle(realout[i])
	}
	return realout, nil
}
func (h *Handle) Contains(value *controlarray.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.AxesControlArray_contains(C.AxesControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *controlarray.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.AxesControlArray_index(C.AxesControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.AxesControlArray_intersection(C.AxesControlArrayHandle(h.CAPIHandle()), C.AxesControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesControlArray_equal(C.AxesControlArrayHandle(h.CAPIHandle()), C.AxesControlArrayHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesControlArray_not_equal(C.AxesControlArrayHandle(h.CAPIHandle()), C.AxesControlArrayHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AxesControlArray_to_json_string(C.AxesControlArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AxesControlArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
