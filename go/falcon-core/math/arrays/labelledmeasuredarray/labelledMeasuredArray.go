package labelledmeasuredarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/LabelledMeasuredArray_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listlistsizet"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/arrays/measuredarray"
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
		C.LabelledMeasuredArray_destroy(C.LabelledMeasuredArrayHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func FromFarray(farray *farraydouble.Handle, label *acquisitioncontext.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{farray, label}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledMeasuredArray_from_farray(C.FArrayDoubleHandle(farray.CAPIHandle()), C.AcquisitionContextHandle(label.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func FromMeasuredArray(measuredarray *measuredarray.Handle, label *acquisitioncontext.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{measuredarray, label}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LabelledMeasuredArray_from_measured_array(C.MeasuredArrayHandle(measuredarray.CAPIHandle()), C.AcquisitionContextHandle(label.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Label() (*acquisitioncontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*acquisitioncontext.Handle, error) {

		return acquisitioncontext.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_label(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Connection() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_connection(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) InstrumentType() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_instrument_type(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("InstrumentType:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Units() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_units(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledMeasuredArray_size(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Dimension() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledMeasuredArray_dimension(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Shape() ([]uint32, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledMeasuredArray_dimension(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Shape: dimension errored"), err)
	}
	out := make([]C.size_t, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledMeasuredArray_shape(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]uint32, dim)
	for i := range out {
		realout[i] = uint32(realout[i])
	}
	return realout, nil
}
func (h *Handle) Data() ([]float64, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledMeasuredArray_dimension(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Data: dimension errored"), err)
	}
	out := make([]C.double, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledMeasuredArray_data(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]float64, dim)
	for i := range out {
		realout[i] = float64(realout[i])
	}
	return realout, nil
}
func (h *Handle) PlusequalsFarray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.LabelledMeasuredArray_plusequals_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) PlusequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray_plusequals_double(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) PlusequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray_plusequals_int(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) PlusMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_plus_measured_array(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_plus_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_plus_double(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) PlusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_plus_int(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) MinusequalsMeasuredArray(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.LabelledMeasuredArray_minusequals_measured_array(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusequalsFarray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.LabelledMeasuredArray_minusequals_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray_minusequals_double(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) MinusequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray_minusequals_int(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) MinusMeasuredArray(other *measuredarray.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_minus_measured_array(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.MeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_minus_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_minus_double(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) MinusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_minus_int(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Negation() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_negation(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) TimesequalsMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_timesequals_measured_array(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesequalsFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_timesequals_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray_timesequals_double(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) TimesequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray_timesequals_int(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) TimesMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_times_measured_array(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_times_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_times_double(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) TimesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_times_int(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DividesequalsMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_dividesequals_measured_array(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesequalsFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_dividesequals_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray_dividesequals_double(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) DividesequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray_dividesequals_int(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) DividesMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_divides_measured_array(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_divides_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_divides_double(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) DividesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_divides_int(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Pow(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_pow(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) Abs() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_abs(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) MinFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_min_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_min_measured_array(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MaxFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_max_farray(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MaxMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_max_measured_array(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equality(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledMeasuredArray_equality(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Notequality(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledMeasuredArray_notequality(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Greaterthan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledMeasuredArray_greaterthan(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) Lessthan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledMeasuredArray_lessthan(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) RemoveOffset(offset float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray_remove_offset(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(offset))
		return nil
	})
}
func (h *Handle) Sum() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray_sum(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Reshape(shape *uint32, ndims uint32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_reshape(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.size_t*(shape), C.size_t(ndims))))
	})
}
func (h *Handle) Where(value float64) (*listlistsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlistsizet.Handle, error) {

		return listlistsizet.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_where(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(value))))
	})
}
func (h *Handle) Flip(axis uint32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_flip(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) FullGradient() ([]*Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledMeasuredArray_dimension(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("FullGradient: dimension errored"), err)
	}
	out := make([]C.LabelledMeasuredArrayHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledMeasuredArray_full_gradient(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*Handle, dim)
	for i := range out {
		realout[i] = *Handle(realout[i])
	}
	return realout, nil
}
func (h *Handle) Gradient(axis uint32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_gradient(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) GetSumOfSquares() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray_get_sum_of_squares(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetSummedDiffIntOfSquares(other int32) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray_get_summed_diff_int_of_squares(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.int(other))), nil
	})
}
func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray_get_summed_diff_double_of_squares(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.double(other))), nil
	})
}
func (h *Handle) GetSummedDiffArrayOfSquares(other *Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (float64, error) {
		return float64(C.LabelledMeasuredArray_get_summed_diff_array_of_squares(C.LabelledMeasuredArrayHandle(h.CAPIHandle()), C.LabelledMeasuredArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray_to_json_string(C.LabelledMeasuredArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.LabelledMeasuredArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
