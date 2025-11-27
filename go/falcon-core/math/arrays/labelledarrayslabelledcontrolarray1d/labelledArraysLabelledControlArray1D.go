package labelledarrayslabelledcontrolarray1d

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/LabelledArraysLabelledControlArray1D_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listacquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelledcontrolarray1d"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledcontrolarray1d"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.LabelledArraysLabelledControlArray1D_destroy(C.LabelledArraysLabelledControlArray1DHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(items []*labelledcontrolarray1d.Handle) (*Handle, error) {
	list, err := listlabelledcontrolarray1d.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of labelledcontrolarray1d failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(arrays *listlabelledcontrolarray1d.Handle) (*Handle, error) {
	return cmemoryallocation.Read(arrays, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledArraysLabelledControlArray1D_create(C.ListLabelledControlArray1DHandle(arrays.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Arrays() (*listlabelledcontrolarray1d.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlabelledcontrolarray1d.Handle, error) {

		return listlabelledcontrolarray1d.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray1D_arrays(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Labels() (*listacquisitioncontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listacquisitioncontext.Handle, error) {

		return listacquisitioncontext.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray1D_labels(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) IsControlArrays() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray1D_is_control_arrays(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsMeasuredArrays() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray1D_is_measured_arrays(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) PushBack(value *labelledcontrolarray1d.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.LabelledArraysLabelledControlArray1D_push_back(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledArraysLabelledControlArray1D_size(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray1D_empty(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledArraysLabelledControlArray1D_erase_at(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledArraysLabelledControlArray1D_clear(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*labelledcontrolarray1d.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelledcontrolarray1d.Handle, error) {

		return labelledcontrolarray1d.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray1D_at(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Contains(value *labelledcontrolarray1d.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray1D_contains(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *labelledcontrolarray1d.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.LabelledArraysLabelledControlArray1D_index(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray1D_intersection(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledArraysLabelledControlArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray1D_equal(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledArraysLabelledControlArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray1D_not_equal(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledArraysLabelledControlArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray1D_to_json_string(C.LabelledArraysLabelledControlArray1DHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.LabelledArraysLabelledControlArray1D_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
