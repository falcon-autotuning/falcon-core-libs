package labelledarrayslabelledcontrolarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/LabelledArraysLabelledControlArray_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelledcontrolarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledcontrolarray"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.LabelledArraysLabelledControlArray_destroy(C.LabelledArraysLabelledControlArrayHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(items []*labelledcontrolarray.Handle) (*Handle, error) {
	list, err := listlabelledcontrolarray.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of labelledcontrolarray failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(arrays *listlabelledcontrolarray.Handle) (*Handle, error) {
	return cmemoryallocation.Read(arrays, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledArraysLabelledControlArray_create(C.ListLabelledControlArrayHandle(arrays.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledArraysLabelledControlArray_copy(C.LabelledArraysLabelledControlArrayHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Arrays() (*listlabelledcontrolarray.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlabelledcontrolarray.Handle, error) {

		return listlabelledcontrolarray.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray_arrays(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Labels() (*listacquisitioncontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listacquisitioncontext.Handle, error) {

		return listacquisitioncontext.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray_labels(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) IsControlArrays() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray_is_control_arrays(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsMeasuredArrays() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray_is_measured_arrays(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) PushBack(value *labelledcontrolarray.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.LabelledArraysLabelledControlArray_push_back(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.LabelledArraysLabelledControlArray_size(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray_empty(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledArraysLabelledControlArray_erase_at(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledArraysLabelledControlArray_clear(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*labelledcontrolarray.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelledcontrolarray.Handle, error) {

		return labelledcontrolarray.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray_at(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Contains(value *labelledcontrolarray.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray_contains(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *labelledcontrolarray.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.LabelledArraysLabelledControlArray_index(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray_intersection(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledArraysLabelledControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray_equal(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledArraysLabelledControlArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledArraysLabelledControlArray_not_equal(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()), C.LabelledArraysLabelledControlArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledControlArray_to_json_string(C.LabelledArraysLabelledControlArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.LabelledArraysLabelledControlArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
