package measuredarray1d

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/arrays/MeasuredArray1D_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listfarraydouble"
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
		C.MeasuredArray1D_destroy(C.MeasuredArray1DHandle(ptr))
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
				return unsafe.Pointer(C.MeasuredArray1D_copy(C.MeasuredArray1DHandle(handle.CAPIHandle()))), nil
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
		return bool(C.MeasuredArray1D_equal(C.MeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.MeasuredArray1D_not_equal(C.MeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArray1DHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MeasuredArray1D_to_json_string(C.MeasuredArray1DHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MeasuredArray1D_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func FromData(data []float64, shape []uint64) (*Handle, error) {
	nData := len(data)
	if nData == 0 {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(nil), nil
			},
			construct,
			destroy,
		)
	}
	cData := C.malloc(C.size_t(nData) * C.size_t(unsafe.Sizeof(C.double(0))))
	if cData == nil {
		return nil, errors.New("C.malloc failed")
	}
	slicecData := (*[1 << 30]C.double)(cData)[:nData:nData]
	for i, v := range data {
		slicecData[i] = C.double(v)
	}
	nShape := len(shape)
	if nShape == 0 {
		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(nil), nil
			},
			construct,
			destroy,
		)
	}
	cShape := C.malloc(C.size_t(nShape) * C.size_t(unsafe.Sizeof(C.size_t(0))))
	if cShape == nil {
		return nil, errors.New("C.malloc failed")
	}
	slicecShape := (*[1 << 30]C.size_t)(cShape)[:nShape:nShape]
	for i, v := range shape {
		slicecShape[i] = C.size_t(v)
	}

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			res := unsafe.Pointer(C.MeasuredArray1D_from_data((*C.double)(cData), (*C.size_t)(cShape), C.size_t(nShape)))
			C.free(cData)
			C.free(cShape)
			return res, nil
		},
		construct,
		destroy,
	)

}
func FromFArray(farray *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.Read(farray, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MeasuredArray1D_from_farray(C.FArrayDoubleHandle(farray.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Is1D() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MeasuredArray1D_is_1D(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) As1D() (*farraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*farraydouble.Handle, error) {

		return farraydouble.FromCAPI(unsafe.Pointer(C.MeasuredArray1D_as_1D(C.MeasuredArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetStart() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_get_start(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetEnd() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_get_end(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsDecreasing() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MeasuredArray1D_is_decreasing(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsIncreasing() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MeasuredArray1D_is_increasing(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetDistance() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_get_distance(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetMean() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_get_mean(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetStd() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_get_std(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Reverse() error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_reverse(C.MeasuredArray1DHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) GetClosestIndex(value float64) (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MeasuredArray1D_get_closest_index(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) EvenDivisions(divisions uint64) (*listfarraydouble.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listfarraydouble.Handle, error) {

		return listfarraydouble.FromCAPI(unsafe.Pointer(C.MeasuredArray1D_even_divisions(C.MeasuredArray1DHandle(h.CAPIHandle()), C.size_t(divisions))))
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MeasuredArray1D_size(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Dimension() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.MeasuredArray1D_dimension(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Shape() ([]uint64, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.MeasuredArray1D_dimension(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Shape: size errored"), err)
	}
	out := make([]C.size_t, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.MeasuredArray1D_shape(C.MeasuredArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
		return int32(C.MeasuredArray1D_size(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("Data: size errored"), err)
	}
	out := make([]C.double, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.MeasuredArray1D_data(C.MeasuredArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
		C.MeasuredArray1D_plus_equals_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) PlusEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_plus_equals_double(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) PlusEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_plus_equals_int(C.MeasuredArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) PlusMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_plus_measured_array(C.MeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_plus_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PlusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_plus_double(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) PlusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_plus_int(C.MeasuredArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) MinusEqualsFArray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.MeasuredArray1D_minus_equals_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MinusEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_minus_equals_double(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) MinusEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_minus_equals_int(C.MeasuredArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) MinusMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_minus_measured_array(C.MeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_minus_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinusDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_minus_double(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) MinusInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_minus_int(C.MeasuredArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Negation() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_negation(C.MeasuredArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) TimesEqualsFArray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.MeasuredArray1D_times_equals_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) TimesEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_times_equals_double(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) TimesEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_times_equals_int(C.MeasuredArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) TimesMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_times_measured_array(C.MeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_times_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) TimesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_times_double(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) TimesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_times_int(C.MeasuredArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DividesEqualsMeasuredArray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.MeasuredArray1D_divides_equals_measured_array(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) DividesEqualsFArray(other *farraydouble.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.MeasuredArray1D_divides_equals_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) DividesEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_divides_equals_double(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) DividesEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_divides_equals_int(C.MeasuredArray1DHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) DividesMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_divides_measured_array(C.MeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_divides_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DividesDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_divides_double(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) DividesInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_divides_int(C.MeasuredArray1DHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) Pow(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_pow(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) Abs() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_abs(C.MeasuredArray1DHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Min() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_min(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) MinFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_min_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MinMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_min_measured_array(C.MeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Max() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_max(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) MaxFArray(other *farraydouble.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_max_farray(C.MeasuredArray1DHandle(h.CAPIHandle()), C.FArrayDoubleHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MaxMeasuredArray(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_max_measured_array(C.MeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArray1DHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) GreaterThan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MeasuredArray1D_greater_than(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) LessThan(value float64) (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.MeasuredArray1D_less_than(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(value))), nil
	})
}
func (h *Handle) RemoveOffset(offset float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.MeasuredArray1D_remove_offset(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(offset))
		return nil
	})
}
func (h *Handle) Sum() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_sum(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
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
				return unsafe.Pointer(C.MeasuredArray1D_reshape(C.MeasuredArray1DHandle(h.CAPIHandle()), &cshape[0], C.size_t(len(shape)))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Where(value float64) (*listlistsizet.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listlistsizet.Handle, error) {

		return listlistsizet.FromCAPI(unsafe.Pointer(C.MeasuredArray1D_where(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(value))))
	})
}
func (h *Handle) Flip(axis uint64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_flip(C.MeasuredArray1DHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) FullGradient() ([]*Handle, error) {
	dim, err := cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.MeasuredArray1D_dimension(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
	if err != nil {
		return nil, errors.Join(errors.New("FullGradient: size errored"), err)
	}
	out := make([]C.MeasuredArray1DHandle, dim)
	_, err = cmemoryallocation.Read(h, func() (bool, error) {
		C.MeasuredArray1D_full_gradient(C.MeasuredArray1DHandle(h.CAPIHandle()), &out[0], C.size_t(dim))
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
func (h *Handle) Gradient(axis uint64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.MeasuredArray1D_gradient(C.MeasuredArray1DHandle(h.CAPIHandle()), C.size_t(axis))))
	})
}
func (h *Handle) GetSumOfSquares() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_get_sum_of_squares(C.MeasuredArray1DHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetSummedDiffIntOfSquares(other int32) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_get_summed_diff_int_of_squares(C.MeasuredArray1DHandle(h.CAPIHandle()), C.int(other))), nil
	})
}
func (h *Handle) GetSummedDiffDoubleOfSquares(other float64) (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.MeasuredArray1D_get_summed_diff_double_of_squares(C.MeasuredArray1DHandle(h.CAPIHandle()), C.double(other))), nil
	})
}
func (h *Handle) GetSummedDiffArrayOfSquares(other *Handle) (float64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (float64, error) {
		return float64(C.MeasuredArray1D_get_summed_diff_array_of_squares(C.MeasuredArray1DHandle(h.CAPIHandle()), C.MeasuredArray1DHandle(other.CAPIHandle()))), nil
	})
}
