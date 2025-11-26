package axesmeasurementcontext

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/AxesMeasurementContext_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/measurementcontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listmeasurementcontext"
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
		C.AxesMeasurementContext_destroy(C.AxesMeasurementContextHandle(ptr))
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
			return unsafe.Pointer(C.AxesMeasurementContext_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*measurementcontext.Handle) (*Handle, error) {
	list, err := listmeasurementcontext.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of measurementcontext failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(data *listmeasurementcontext.Handle) (*Handle, error) {
	return cmemoryallocation.Read(data, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AxesMeasurementContext_create(C.ListMeasurementContextHandle(data.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) PushBack(value *measurementcontext.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.AxesMeasurementContext_push_back(C.AxesMeasurementContextHandle(h.CAPIHandle()), C.MeasurementContextHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.AxesMeasurementContext_size(C.AxesMeasurementContextHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.AxesMeasurementContext_empty(C.AxesMeasurementContextHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesMeasurementContext_erase_at(C.AxesMeasurementContextHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.AxesMeasurementContext_clear(C.AxesMeasurementContextHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*measurementcontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*measurementcontext.Handle, error) {

		return measurementcontext.FromCAPI(unsafe.Pointer(C.AxesMeasurementContext_at(C.AxesMeasurementContextHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() ([]*measurementcontext.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.AxesMeasurementContext_dimension(C.AxesMeasurementContextHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Items: dimension errored"), err)
	}
	out := make([]C.MeasurementContextHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.AxesMeasurementContext_items(C.AxesMeasurementContextHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*measurementcontext.Handle, dim)
	for i := range out {
		realout[i] = *measurementcontext.Handle(realout[i])
	}
	return realout, nil
}
func (h *Handle) Contains(value *measurementcontext.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.AxesMeasurementContext_contains(C.AxesMeasurementContextHandle(h.CAPIHandle()), C.MeasurementContextHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *measurementcontext.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.AxesMeasurementContext_index(C.AxesMeasurementContextHandle(h.CAPIHandle()), C.MeasurementContextHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.AxesMeasurementContext_intersection(C.AxesMeasurementContextHandle(h.CAPIHandle()), C.AxesMeasurementContextHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesMeasurementContext_equal(C.AxesMeasurementContextHandle(h.CAPIHandle()), C.AxesMeasurementContextHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.AxesMeasurementContext_not_equal(C.AxesMeasurementContextHandle(h.CAPIHandle()), C.AxesMeasurementContextHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AxesMeasurementContext_to_json_string(C.AxesMeasurementContextHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AxesMeasurementContext_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
