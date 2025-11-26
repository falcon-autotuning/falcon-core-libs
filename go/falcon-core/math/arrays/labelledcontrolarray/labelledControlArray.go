package labelledcontrolarray

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/LabelledControlArray_c_api.h>
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
		C.LabelledControlArray_destroy(C.LabelledControlArrayHandle(ptr))
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
				return unsafe.Pointer(C.LabelledControlArray_from_farray(C.FArrayDoubleHandle(farray.CAPIHandle()), C.AcquisitionContextHandle(label.CAPIHandle()))), nil
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
				return unsafe.Pointer(C.LabelledControlArray_from_control_array(C.ControlArrayHandle(controlarray.CAPIHandle()), C.AcquisitionContextHandle(label.CAPIHandle()))), nil
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

		return acquisitioncontext.FromCAPI(unsafe.Pointer(C.LabelledControlArray_label(C.LabelledControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Connection() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.LabelledControlArray_connection(C.LabelledControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) InstrumentType() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledControlArray_instrument_type(C.LabelledControlArrayHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("InstrumentType:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Units() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.LabelledControlArray_units(C.LabelledControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Size() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledControlArray_size(C.LabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Dimension() (uint32, error) {
	return cmemoryallocation.Read(h, func() (uint32, error) {
		return uint32(C.LabelledControlArray_dimension(C.LabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Shape() ([]uint32, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledControlArray_dimension(C.LabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Shape: dimension errored"), err)
	}
	out := make([]C.size_t, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledControlArray_shape(C.LabelledControlArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
		return int32(C.LabelledControlArray_dimension(C.LabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Data: dimension errored"), err)
	}
	out := make([]C.double, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledControlArray_data(C.LabelledControlArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
		C.LabelledControlArray_plusequals_farray(C.LabelledControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) PlusequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray_plusequals_double(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) PlusequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray_plusequals_int(C.LabelledControlArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) PlusControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_plus_control_array(C.LabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_plus_farray(C.LabelledControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_plus_double(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) PlusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_plus_int(C.LabelledControlArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) MinusequalsControlArray(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.LabelledControlArray_minusequals_control_array(C.LabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusequalsFarray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.LabelledControlArray_minusequals_farray(C.LabelledControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray_minusequals_double(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) MinusequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray_minusequals_int(C.LabelledControlArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) MinusControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_minus_control_array(C.LabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_minus_farray(C.LabelledControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_minus_double(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) MinusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_minus_int(C.LabelledControlArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Negation() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_negation(C.LabelledControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) TimesequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray_timesequals_double(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) TimesequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray_timesequals_int(C.LabelledControlArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_times_double(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) TimesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_times_int(C.LabelledControlArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DividesequalsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray_dividesequals_double(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) DividesequalsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray_dividesequals_int(C.LabelledControlArrayHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_divides_double(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) DividesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_divides_int(C.LabelledControlArrayHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Pow(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_pow(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) Abs() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_abs(C.LabelledControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Min() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_min(C.LabelledControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) MinFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_min_farray(C.LabelledControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_min_control_array(C.LabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Max() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_max(C.LabelledControlArrayHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) MaxFarray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_max_farray(C.LabelledControlArrayHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MaxControlArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_max_control_array(C.LabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Equality(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledControlArray_equality(C.LabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Notequality(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LabelledControlArray_notequality(C.LabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) Greaterthan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledControlArray_greaterthan(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) Lessthan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.LabelledControlArray_lessthan(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) RemoveOffset(offset float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.LabelledControlArray_remove_offset(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(offset))
		return nil
	})
}
func (h *Handle) Sum() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray_sum(C.LabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Where(value float64) (*listlistsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlistsizet.Handle, error) {

		return listlistsizet.FromCAPI(unsafe.Pointer(C.LabelledControlArray_where(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(value))))
	})
}
func (h *Handle) Flip(axis uint32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.LabelledControlArray_flip(C.LabelledControlArrayHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) FullGradient() ([]*farraydouble.Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.LabelledControlArray_dimension(C.LabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("FullGradient: dimension errored"), err)
	}
	out := make([]C.FArrayDoubleHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.LabelledControlArray_full_gradient(C.LabelledControlArrayHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
		return true, nil
	})
	if err != nil {
		return nil, err
	}
	realout := make([]*farraydouble.Handle, dim)
	for i := range out {
		realout[i] = *farraydouble.Handle(realout[i])
	}
	return realout, nil
}
func (h *Handle) Gradient(axis uint32) (*farraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.LabelledControlArray_gradient(C.LabelledControlArrayHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) GetSumOfSquares() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray_get_sum_of_squares(C.LabelledControlArrayHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetSummedDiffIntOfSquares(other int32) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray_get_summed_diff_int_of_squares(C.LabelledControlArrayHandle(h.CAPIHandle()), C.int(other))), nil
	})
}
func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.LabelledControlArray_get_summed_diff_double_of_squares(C.LabelledControlArrayHandle(h.CAPIHandle()), C.double(other))), nil
	})
}
func (h *Handle) GetSummedDiffArrayOfSquares(other *Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (float64, error) {
		return float64(C.LabelledControlArray_get_summed_diff_array_of_squares(C.LabelledControlArrayHandle(h.CAPIHandle()), C.LabelledControlArrayHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LabelledControlArray_to_json_string(C.LabelledControlArrayHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.LabelledControlArray_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
