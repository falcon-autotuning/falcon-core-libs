package labelledmeasuredarray1d

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/LabelledMeasuredArray1D_c_api.h>
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
		C.LabelledMeasuredArray1D_destroy(C.LabelledMeasuredArray1DHandle(ptr))
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
				return unsafe.Pointer(C.LabelledMeasuredArray1D_from_farray(C.FArrayDoubleHandle(farray.CAPIHandle()), C.AcquisitionContextHandle(label.CAPIHandle()))), nil
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
				return unsafe.Pointer(C.LabelledMeasuredArray1D_from_measured_array(C.MeasuredArrayHandle(measuredarray.CAPIHandle()), C.AcquisitionContextHandle(label.CAPIHandle()))), nil
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
		return bool(C.LabelledMeasuredArray1D_is_1D(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) As1D() (*farraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_as_1D(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetStart() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_get_start(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetEnd() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_get_end(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsDecreasing() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledMeasuredArray1D_is_decreasing(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsIncreasing() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledMeasuredArray1D_is_increasing(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetDistance() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_get_distance(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetMean() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_get_mean(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetStd() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_get_std(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Reverse() error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_reverse(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) GetClosestIndex(value float64) (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledMeasuredArray1D_get_closest_index(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) EvenDivisions(divisions uint32) (*listfarraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listfarraydouble.Handle, error) {

		return listfarraydouble.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_even_divisions(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.size_t(divisions))))
	})
}
func (h *Handle) Label() (*acquisitioncontext.Handle, error) {
	return cmemoryallocation.Read(h, func() (*acquisitioncontext.Handle, error) {

		return acquisitioncontext.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_label(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Connection() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_connection(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) InstrumentType() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_instrument_type(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("InstrumentType:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Units() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_units(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledMeasuredArray1D_size(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Dimension() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledMeasuredArray1D_dimension(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Shape() ([]uint32, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledMeasuredArray1D_dimension(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Shape: dimension errored"), err)
	}
	out := make([]C.size_t, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledMeasuredArray1D_shape(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
		return int32(C.LabelledMeasuredArray1D_dimension(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Data: dimension errored"), err)
	}
	out := make([]C.double, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledMeasuredArray1D_data(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
		C.LabelledMeasuredArray1D_plusequals_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) PlusequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_plusequals_double(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) PlusequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_plusequals_int(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) PlusMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_plus_measured_array(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_plus_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_plus_double(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) PlusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_plus_int(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) MinusequalsMeasuredArray(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.LabelledMeasuredArray1D_minusequals_measured_array(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusequalsFarray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.LabelledMeasuredArray1D_minusequals_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_minusequals_double(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) MinusequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_minusequals_int(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) MinusMeasuredArray(other *measuredarray.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_minus_measured_array(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_minus_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_minus_double(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) MinusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_minus_int(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Negation() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_negation(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) TimesequalsMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_timesequals_measured_array(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesequalsFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_timesequals_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_timesequals_double(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) TimesequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_timesequals_int(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) TimesMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_times_measured_array(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_times_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_times_double(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) TimesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_times_int(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DividesequalsMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_dividesequals_measured_array(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesequalsFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_dividesequals_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_dividesequals_double(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) DividesequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_dividesequals_int(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) DividesMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_divides_measured_array(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_divides_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_divides_double(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) DividesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_divides_int(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Pow(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_pow(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) Abs() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_abs(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) MinFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_min_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_min_measured_array(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MaxFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_max_farray(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MaxMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_max_measured_array(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equality(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledMeasuredArray1D_equality(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Notequality(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledMeasuredArray1D_notequality(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Greaterthan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledMeasuredArray1D_greaterthan(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) Lessthan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledMeasuredArray1D_lessthan(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) RemoveOffset(offset float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledMeasuredArray1D_remove_offset(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(offset))
		return nil
	})
}
func (h *Handle) Sum() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_sum(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Reshape(shape *uint32, ndims uint32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_reshape(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.size_t*(shape), C.size_t(ndims))))
	})
}
func (h *Handle) Where(value float64) (*listlistsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlistsizet.Handle, error) {

		return listlistsizet.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_where(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(value))))
	})
}
func (h *Handle) Flip(axis uint32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_flip(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) FullGradient() ([]*Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledMeasuredArray1D_dimension(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("FullGradient: dimension errored"), err)
	}
	out := make([]C.LabelledMeasuredArray1DHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledMeasuredArray1D_full_gradient(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_gradient(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) GetSumOfSquares() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_get_sum_of_squares(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetSummedDiffIntOfSquares(other int32) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_get_summed_diff_int_of_squares(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.int(other))), nil
	})
}
func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_get_summed_diff_double_of_squares(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.double(other))), nil
	})
}
func (h *Handle) GetSummedDiffArrayOfSquares(other *Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (float64, error) {
		return float64(C.LabelledMeasuredArray1D_get_summed_diff_array_of_squares(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()), C.LabelledMeasuredArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledMeasuredArray1D_to_json_string(C.LabelledMeasuredArray1DHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.LabelledMeasuredArray1D_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
