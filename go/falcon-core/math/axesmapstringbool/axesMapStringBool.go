package axesmapstringbool

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AxesMapStringBool_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listmapstringbool"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapstringbool"
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
		C.AxesMapStringBool_destroy(C.AxesMapStringBoolHandle(ptr))
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
			return unsafe.Pointer(C.AxesMapStringBool_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*mapstringbool.Handle) (*Handle, error) {
	list, err := listmapstringbool.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of mapstringbool failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(data *listmapstringbool.Handle) (*Handle, error) {
	return cmemoryallocation.Read(data, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesMapStringBool_create(C.ListMapStringBoolHandle(data.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *mapstringbool.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.AxesMapStringBool_push_back(C.AxesMapStringBoolHandle(h.CAPIHandle()), C.MapStringBoolHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.AxesMapStringBool_size(C.AxesMapStringBoolHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesMapStringBool_empty(C.AxesMapStringBoolHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesMapStringBool_erase_at(C.AxesMapStringBoolHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesMapStringBool_clear(C.AxesMapStringBoolHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*mapstringbool.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapstringbool.Handle, error) {

		return mapstringbool.FromCAPI(unsafe.Pointer(C.AxesMapStringBool_at(C.AxesMapStringBoolHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*mapstringbool.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.AxesMapStringBool_dimension(C.AxesMapStringBoolHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: dimension errored"), err)
	}
	out := make([]C.MapStringBoolHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.AxesMapStringBool_items(C.AxesMapStringBoolHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*mapstringbool.Handle, dim)
	for i := range out {
		realout[i] = *mapstringbool.Handle(realout[i])
	}
	return realout, nil
}
func (h *Handle) Contains(value *mapstringbool.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.AxesMapStringBool_contains(C.AxesMapStringBoolHandle(h.CAPIHandle()), C.MapStringBoolHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *mapstringbool.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.AxesMapStringBool_index(C.AxesMapStringBoolHandle(h.CAPIHandle()), C.MapStringBoolHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.AxesMapStringBool_intersection(C.AxesMapStringBoolHandle(h.CAPIHandle()), C.AxesMapStringBoolHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesMapStringBool_equal(C.AxesMapStringBoolHandle(h.CAPIHandle()), C.AxesMapStringBoolHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesMapStringBool_not_equal(C.AxesMapStringBoolHandle(h.CAPIHandle()), C.AxesMapStringBoolHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AxesMapStringBool_to_json_string(C.AxesMapStringBoolHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AxesMapStringBool_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
