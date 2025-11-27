package labelledcontrolarray1d

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/LabelledControlArray1D_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/contexts/acquisitioncontext"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/farraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listfarraydouble"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlistsizet"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/controlarray"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.LabelledControlArray1D_destroy(C.LabelledControlArray1DHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func FromFArray(farray *farraydouble.Handle, label *acquisitioncontext.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{farray, label}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledControlArray1D_from_farray(C.FArrayDoubleHandle(farray.CAPIHandle()), C.AcquisitionContextHandle(label.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func FromControlArray(controlarray *controlarray.Handle, label *acquisitioncontext.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{controlarray, label}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledControlArray1D_from_control_array(C.ControlArrayHandle(controlarray.CAPIHandle()), C.AcquisitionContextHandle(label.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Is1D() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledControlArray1D_is_1D(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) As1D() (*farraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_as_1D(C.LabelledControlArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetStart() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray1D_get_start(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetEnd() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray1D_get_end(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsDecreasing() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledControlArray1D_is_decreasing(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsIncreasing() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledControlArray1D_is_increasing(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetDistance() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray1D_get_distance(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetMean() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray1D_get_mean(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetStd() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray1D_get_std(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Reverse() error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_reverse(C.LabelledControlArray1DHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) GetClosestIndex(value float64) (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledControlArray1D_get_closest_index(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) EvenDivisions(divisions uint32) (*listfarraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listfarraydouble.Handle, error) {

		return listfarraydouble.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_even_divisions(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.size_t(divisions))))
	})
}
func (h *Handle) Label() (*acquisitioncontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*acquisitioncontext.Handle, error) {

		return acquisitioncontext.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_label(C.LabelledControlArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Connection() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_connection(C.LabelledControlArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) InstrumentType() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_instrument_type(C.LabelledControlArray1DHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("InstrumentType:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Units() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_units(C.LabelledControlArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledControlArray1D_size(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Dimension() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledControlArray1D_dimension(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Shape() ([]uint32, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledControlArray1D_size(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Shape: size errored"), err)
	}
	out := make([]C.size_t, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledControlArray1D_shape(C.LabelledControlArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
func (h *Handle) Data() ([]float64, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledControlArray1D_size(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Data: size errored"), err)
	}
	out := make([]C.double, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledControlArray1D_data(C.LabelledControlArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
		C.LabelledControlArray1D_plus_equals_farray(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) PlusEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_plus_equals_double(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) PlusEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_plus_equals_int(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) PlusControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_plus_control_array(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_plus_farray(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_plus_double(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) PlusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_plus_int(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) MinusEqualsFArray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.LabelledControlArray1D_minus_equals_farray(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_minus_equals_double(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) MinusEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_minus_equals_int(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) MinusControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_minus_control_array(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_minus_farray(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_minus_double(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) MinusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_minus_int(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Negation() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_negation(C.LabelledControlArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) TimesEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_times_equals_double(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) TimesEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_times_equals_int(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_times_double(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) TimesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_times_int(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DividesEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_divides_equals_double(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) DividesEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_divides_equals_int(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_divides_double(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) DividesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_divides_int(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Pow(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_pow(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) Abs() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_abs(C.LabelledControlArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) MinFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_min_farray(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_min_control_array(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MaxFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_max_farray(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MaxControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_max_control_array(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledControlArray1D_equal(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledControlArray1D_not_equal(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) GreaterThan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledControlArray1D_greater_than(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) LessThan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledControlArray1D_less_than(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) RemoveOffset(offset float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray1D_remove_offset(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(offset))
		return nil
	})
}
func (h *Handle) Sum() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray1D_sum(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Where(value float64) (*listlistsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlistsizet.Handle, error) {

		return listlistsizet.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_where(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(value))))
	})
}
func (h *Handle) Flip(axis uint32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_flip(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) FullGradient() ([]*farraydouble.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledControlArray1D_size(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("FullGradient: size errored"), err)
	}
	out := make([]C.FArrayDoubleHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledControlArray1D_full_gradient(C.LabelledControlArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
func (h *Handle) Gradient(axis uint32) (*farraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_gradient(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) GetSumOfSquares() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray1D_get_sum_of_squares(C.LabelledControlArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetSummedDiffIntOfSquares(other int32) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray1D_get_summed_diff_int_of_squares(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.int(other))), nil
	})
}
func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray1D_get_summed_diff_double_of_squares(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.double(other))), nil
	})
}
func (h *Handle) GetSummedDiffArrayOfSquares(other *Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (float64, error) {
		return float64(C.LabelledControlArray1D_get_summed_diff_array_of_squares(C.LabelledControlArray1DHandle(h.CAPIHandle()), C.LabelledControlArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledControlArray1D_to_json_string(C.LabelledControlArray1DHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.LabelledControlArray1D_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
