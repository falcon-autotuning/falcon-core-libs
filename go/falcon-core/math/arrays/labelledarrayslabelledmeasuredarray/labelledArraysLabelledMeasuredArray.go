package labelledarrayslabelledmeasuredarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/LabelledArraysLabelledMeasuredArray_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlabelledmeasuredarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/labelledmeasuredarray"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.LabelledArraysLabelledMeasuredArray_destroy(C.LabelledArraysLabelledMeasuredArrayHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(items []*labelledmeasuredarray.Handle) (*Handle, error) {
	list, err := listlabelledmeasuredarray.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of labelledmeasuredarray failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(arrays *listlabelledmeasuredarray.Handle) (*Handle, error) {
	return cmemoryallocation.Read(arrays, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledArraysLabelledMeasuredArray_create(C.ListLabelledMeasuredArrayHandle(arrays.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Arrays() (*listlabelledmeasuredarray.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlabelledmeasuredarray.Handle, error) {

		return listlabelledmeasuredarray.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledMeasuredArray_arrays(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Labels() (*listacquisitioncontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listacquisitioncontext.Handle, error) {

		return listacquisitioncontext.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledMeasuredArray_labels(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Iscontrolarrays() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledArraysLabelledMeasuredArray_isControlArrays(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Ismeasuredarrays() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledArraysLabelledMeasuredArray_isMeasuredArrays(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) PushBack(value *labelledmeasuredarray.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.LabelledArraysLabelledMeasuredArray_push_back(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledArraysLabelledMeasuredArray_size(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledArraysLabelledMeasuredArray_empty(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledArraysLabelledMeasuredArray_erase_at(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledArraysLabelledMeasuredArray_clear(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint32) (*labelledmeasuredarray.Handle, error) {
	return cmemoryallocation.Read(h, func() (*labelledmeasuredarray.Handle, error) {

		return labelledmeasuredarray.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledMeasuredArray_at(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Contains(value *labelledmeasuredarray.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.LabelledArraysLabelledMeasuredArray_contains(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *labelledmeasuredarray.Handle) (uint32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint32, error) {
		return uint32(C.LabelledArraysLabelledMeasuredArray_index(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledMeasuredArray_intersection(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledArraysLabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledArraysLabelledMeasuredArray_equal(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledArraysLabelledMeasuredArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledArraysLabelledMeasuredArray_not_equal(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledArraysLabelledMeasuredArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledArraysLabelledMeasuredArray_to_json_string(C.LabelledArraysLabelledMeasuredArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.LabelledArraysLabelledMeasuredArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
