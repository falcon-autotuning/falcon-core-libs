package farrayint

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/generic/FArrayInt_c_api.h>
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
		C.FArrayInt_destroy(C.FArrayIntHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func NewEmpty(shape []int) (*Handle, error) {
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.FArrayInt_create_empty(&cshape[0], C.size_t(len(shape)))), nil
		},
		construct,
		destroy,
	)
}
func NewZeros(shape []int) (*Handle, error) {
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.FArrayInt_create_zeros(&cshape[0], C.size_t(len(shape)))), nil
		},
		construct,
		destroy,
	)
}
func FromShape(shape []int) (*Handle, error) {
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.FArrayInt_from_shape(&cshape[0], C.size_t(len(shape)))), nil
		},
		construct,
		destroy,
	)
}
func FromData(data []int32, shape []int) (*Handle, error) {
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	cdata := make([]C.int, len(data))
	for i, v := range data {
		cdata[i] = C.int(v)
	}
	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.FArrayInt_from_data(&cdata[0], &cshape[0], C.size_t(len(shape)))), nil
		},
		construct,
		destroy,
	)
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.FArrayInt_size(C.FArrayIntHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Dimension() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.FArrayInt_dimension(C.FArrayIntHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Shape() ([]uint32, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.FArrayInt_size(C.FArrayIntHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Shape: size errored"), err)
	}
	out := make([]C.size_t, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.FArrayInt_shape(C.FArrayIntHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]uint32, dim)
	for i := range out {
		realout[i] = uint32(out[i])

	}
	return realout, nil
}
func (h *Handle) Data() ([]int32, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.FArrayInt_size(C.FArrayIntHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Data: size errored"), err)
	}
	out := make([]C.int, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.FArrayInt_data(C.FArrayIntHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]int32, dim)
	for i := range out {
		realout[i] = int32(out[i])

	}
	return realout, nil
}
func (h *Handle) PlusEqualsFArray(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.FArrayInt_plus_equals_farray(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) PlusEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_plus_equals_double(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) PlusEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_plus_equals_int(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) PlusFArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_plus_farray(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_plus_double(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) PlusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_plus_int(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) MinusEqualsFArray(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.FArrayInt_minus_equals_farray(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_minus_equals_double(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) MinusEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_minus_equals_int(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) MinusFArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_minus_farray(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_minus_double(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) MinusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_minus_int(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Negation() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_negation(C.FArrayIntHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) TimesEqualsFArray(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.FArrayInt_times_equals_farray(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) TimesEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_times_equals_double(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) TimesEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_times_equals_int(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) TimesFArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_times_farray(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_times_double(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) TimesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_times_int(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DividesEqualsFArray(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.FArrayInt_divides_equals_farray(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) DividesEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_divides_equals_double(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) DividesEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_divides_equals_int(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) DividesFArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_divides_farray(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_divides_double(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) DividesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_divides_int(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Pow(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_pow(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DoublePow(other float64) (*farraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.FArrayInt_double_pow(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) PowInplace(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_pow_inplace(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) Abs() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_abs(C.FArrayIntHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Min() (int32, error) {
	return cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.FArrayInt_min(C.FArrayIntHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) MinArraywise(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_min_arraywise(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Max() (int32, error) {
	return cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.FArrayInt_max(C.FArrayIntHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) MaxArraywise(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_max_arraywise(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.FArrayInt_equal(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.FArrayInt_not_equal(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) GreaterThan(value int32) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.FArrayInt_greater_than(C.FArrayIntHandle(h.CAPIHandle()), C.int(value))), nil
	})
}
func (h *Handle) LessThan(value int32) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.FArrayInt_less_than(C.FArrayIntHandle(h.CAPIHandle()), C.int(value))), nil
	})
}
func (h *Handle) RemoveOffset(offset int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.FArrayInt_remove_offset(C.FArrayIntHandle(h.CAPIHandle()), C.int(offset))
		return nil
	})
}
func (h *Handle) Sum() (int32, error) {
	return cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.FArrayInt_sum(C.FArrayIntHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Reshape(shape []int32) (*Handle, error) {
	cshape := make([]C.size_t, len(shape))
	for i, v := range shape {
		cshape[i] = C.size_t(v)
	}
	return cmemoryallocation.Read(h, func() (*Handle, error) {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.FArrayInt_reshape(C.FArrayIntHandle(h.CAPIHandle()), &cshape[0], C.size_t(len(shape)))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Where(value int32) (*listlistsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlistsizet.Handle, error) {

		return listlistsizet.FromCAPI(unsafe.Pointer(C.FArrayInt_where(C.FArrayIntHandle(h.CAPIHandle()), C.int(value))))
	})
}
func (h *Handle) Flip(axis uint32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_flip(C.FArrayIntHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) FullGradient() ([]*Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.FArrayInt_size(C.FArrayIntHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("FullGradient: size errored"), err)
	}
	out := make([]C.FArrayIntHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.FArrayInt_full_gradient(C.FArrayIntHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*Handle, dim)
	for i := range out {
		realout[i], err = FromCAPI(unsafe.Pointer(out[i]))
		if err != nil {
			return nil, errors.Join(errors.New("FullGradient: conversion from CAPI failed"), err)
		}

	}
	return realout, nil
}
func (h *Handle) Gradient(axis uint32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.FArrayInt_gradient(C.FArrayIntHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) GetSumOfSquares() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.FArrayInt_get_sum_of_squares(C.FArrayIntHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetSummedDiffIntOfSquares(other int32) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.FArrayInt_get_summed_diff_int_of_squares(C.FArrayIntHandle(h.CAPIHandle()), C.int(other))), nil
	})
}
func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.FArrayInt_get_summed_diff_double_of_squares(C.FArrayIntHandle(h.CAPIHandle()), C.double(other))), nil
	})
}
func (h *Handle) GetSummedDiffArrayOfSquares(other *Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (float64, error) {
		return float64(C.FArrayInt_get_summed_diff_array_of_squares(C.FArrayIntHandle(h.CAPIHandle()), C.FArrayIntHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.FArrayInt_to_json_string(C.FArrayIntHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.FArrayInt_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
