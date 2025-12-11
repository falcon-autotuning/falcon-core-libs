package controlarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/ControlArray_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlistsizet"
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
		C.ControlArray_destroy(C.ControlArrayHandle(ptr))
	}
)

func (h *Handle) IsNil() bool { return h == nil }
func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func Copy(handle *Handle) (*Handle, error) {
	return cmemoryallocation.Read(handle, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ControlArray_copy(C.ControlArrayHandle(handle.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ControlArray_equal(C.ControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.ControlArray_not_equal(C.ControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.ControlArray_to_json_string(C.ControlArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.ControlArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func FromData(data []float64, shape []uint64) (*Handle, error) {
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	cdata := make([]C.double, len(data))
	for i, v := range data {
		cdata[i] = C.double(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.ControlArray_from_data(&cdata[0], &cshape[0], C.size_t(len(shape)))), nil
		},
		construct,
		destroy,
	)
}
func FromFArray(farray *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.Read(farray, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.ControlArray_from_farray(C.FArrayDoubleHandle(farray.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.ControlArray_size(C.ControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Dimension() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.ControlArray_dimension(C.ControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Shape() ([]uint64, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ControlArray_dimension(C.ControlArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Shape: size errored"), err)
	}
	out := make([]C.size_t, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ControlArray_shape(C.ControlArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]uint64, dim)
	for i := range out {
		realout[i] = uint64(out[i])

	}
	return realout, nil
}
func (h *Handle) Data() ([]float64, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ControlArray_size(C.ControlArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Data: size errored"), err)
	}
	out := make([]C.double, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ControlArray_data(C.ControlArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
func (h *Handle) PlusEqualsFArray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.ControlArray_plus_equals_farray(C.ControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) PlusEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ControlArray_plus_equals_double(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) PlusEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ControlArray_plus_equals_int(C.ControlArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) PlusControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_plus_control_array(C.ControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_plus_farray(C.ControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_plus_double(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) PlusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_plus_int(C.ControlArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) MinusEqualsFArray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.ControlArray_minus_equals_farray(C.ControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ControlArray_minus_equals_double(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) MinusEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ControlArray_minus_equals_int(C.ControlArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) MinusControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_minus_control_array(C.ControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_minus_farray(C.ControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_minus_double(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) MinusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_minus_int(C.ControlArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Negation() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_negation(C.ControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) TimesEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ControlArray_times_equals_double(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) TimesEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ControlArray_times_equals_int(C.ControlArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_times_double(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) TimesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_times_int(C.ControlArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DividesEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ControlArray_divides_equals_double(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) DividesEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.ControlArray_divides_equals_int(C.ControlArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_divides_double(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) DividesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_divides_int(C.ControlArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Pow(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_pow(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) Abs() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_abs(C.ControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Min() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.ControlArray_min(C.ControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) MinFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_min_farray(C.ControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_min_control_array(C.ControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Max() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.ControlArray_max(C.ControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) MaxFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_max_farray(C.ControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MaxControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_max_control_array(C.ControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) GreaterThan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ControlArray_greater_than(C.ControlArrayHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) LessThan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.ControlArray_less_than(C.ControlArrayHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) RemoveOffset(offset float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.ControlArray_remove_offset(C.ControlArrayHandle(h.CAPIHandle()), C.double(offset))
		return nil
	})
}
func (h *Handle) Sum() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.ControlArray_sum(C.ControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Where(value float64) (*listlistsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlistsizet.Handle, error) {

		return listlistsizet.FromCAPI(unsafe.Pointer(C.ControlArray_where(C.ControlArrayHandle(h.CAPIHandle()), C.double(value))))
	})
}
func (h *Handle) Flip(axis uint64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.ControlArray_flip(C.ControlArrayHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) FullGradient() ([]*farraydouble.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.ControlArray_dimension(C.ControlArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("FullGradient: size errored"), err)
	}
	out := make([]C.FArrayDoubleHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.ControlArray_full_gradient(C.ControlArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*farraydouble.Handle, dim)
	for i := range out {
		realout[i], err = farraydouble.FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("FullGradient: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Gradient(axis uint64) (*farraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.ControlArray_gradient(C.ControlArrayHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) GetSumOfSquares() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.ControlArray_get_sum_of_squares(C.ControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetSummedDiffIntOfSquares(other int32) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.ControlArray_get_summed_diff_int_of_squares(C.ControlArrayHandle(h.CAPIHandle()), C.int(other))), nil
	})
}
func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.ControlArray_get_summed_diff_double_of_squares(C.ControlArrayHandle(h.CAPIHandle()), C.double(other))), nil
	})
}
func (h *Handle) GetSummedDiffArrayOfSquares(other *Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (float64, error) {
		return float64(C.ControlArray_get_summed_diff_array_of_squares(C.ControlArrayHandle(h.CAPIHandle()), C.ControlArrayHandle(other.CAPIHandle()))), nil
	})
}
