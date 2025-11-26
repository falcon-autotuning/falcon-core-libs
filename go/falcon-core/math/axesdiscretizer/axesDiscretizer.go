package axesdiscretizer

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AxesDiscretizer_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdiscretizer"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/discrete-spaces/discretizer"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.AxesDiscretizer_destroy(C.AxesDiscretizerHandle(ptr))
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
			return unsafe.Pointer(C.AxesDiscretizer_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*discretizer.Handle) (*Handle, error) {
	list, err := listdiscretizer.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of discretizer failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(data *listdiscretizer.Handle) (*Handle, error) {
	return cmemoryallocation.Read(data, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesDiscretizer_create(C.ListDiscretizerHandle(data.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *discretizer.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.AxesDiscretizer_push_back(C.AxesDiscretizerHandle(h.CAPIHandle()), C.DiscretizerHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.AxesDiscretizer_size(C.AxesDiscretizerHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesDiscretizer_empty(C.AxesDiscretizerHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesDiscretizer_erase_at(C.AxesDiscretizerHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesDiscretizer_clear(C.AxesDiscretizerHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*discretizer.Handle, error) {
	return cmemoryallocation.Read(h, func() (*discretizer.Handle, error) {

		return discretizer.FromCAPI(unsafe.Pointer(C.AxesDiscretizer_at(C.AxesDiscretizerHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*discretizer.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.AxesDiscretizer_dimension(C.AxesDiscretizerHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: dimension errored"), err)
	}
	out := make([]C.DiscretizerHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.AxesDiscretizer_items(C.AxesDiscretizerHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*discretizer.Handle, dim)
	for i := range out {
		realout[i] = *discretizer.Handle(realout[i])
	}
	return realout, nil
}
func (h *Handle) Contains(value *discretizer.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.AxesDiscretizer_contains(C.AxesDiscretizerHandle(h.CAPIHandle()), C.DiscretizerHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *discretizer.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.AxesDiscretizer_index(C.AxesDiscretizerHandle(h.CAPIHandle()), C.DiscretizerHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.AxesDiscretizer_intersection(C.AxesDiscretizerHandle(h.CAPIHandle()), C.AxesDiscretizerHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesDiscretizer_equal(C.AxesDiscretizerHandle(h.CAPIHandle()), C.AxesDiscretizerHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesDiscretizer_not_equal(C.AxesDiscretizerHandle(h.CAPIHandle()), C.AxesDiscretizerHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AxesDiscretizer_to_json_string(C.AxesDiscretizerHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AxesDiscretizer_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
