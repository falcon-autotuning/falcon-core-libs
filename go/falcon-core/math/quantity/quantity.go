package quantity

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/math/Quantity_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
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
		C.Quantity_destroy(C.QuantityHandle(ptr))
	}
)

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
				return unsafe.Pointer(C.Quantity_copy(C.QuantityHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Quantity_equal(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Quantity_not_equal(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Quantity_to_json_string(C.QuantityHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Quantity_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(value float64, unit *symbolunit.Handle) (*Handle, error) {
	return cmemoryallocation.Read(unit, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Quantity_create(C.double(value), C.SymbolUnitHandle(unit.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Value() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.Quantity_value(C.QuantityHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Unit() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.Quantity_unit(C.QuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) ConvertTo(target_unit *symbolunit.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{target_unit}, func() error {
		C.Quantity_convert_to(C.QuantityHandle(h.CAPIHandle()), C.SymbolUnitHandle(target_unit.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MultiplyInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_multiply_int(C.QuantityHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) MultiplyDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_multiply_double(C.QuantityHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) MultiplyQuantity(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_multiply_quantity(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MultiplyEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.Quantity_multiply_equals_int(C.QuantityHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) MultiplyEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.Quantity_multiply_equals_double(C.QuantityHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) MultiplyEqualsQuantity(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.Quantity_multiply_equals_quantity(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) DivideInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_divide_int(C.QuantityHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DivideDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_divide_double(C.QuantityHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) DivideQuantity(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_divide_quantity(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DivideEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.Quantity_divide_equals_int(C.QuantityHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) DivideEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.Quantity_divide_equals_double(C.QuantityHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) DivideEqualsQuantity(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.Quantity_divide_equals_quantity(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Power(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_power(C.QuantityHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) AddQuantity(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_add_quantity(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) AddEqualsQuantity(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.Quantity_add_equals_quantity(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) SubtractQuantity(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_subtract_quantity(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) SubtractEqualsQuantity(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.Quantity_subtract_equals_quantity(C.QuantityHandle(h.CAPIHandle()), C.QuantityHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Negate() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_negate(C.QuantityHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Abs() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.Quantity_abs(C.QuantityHandle(h.CAPIHandle()))))
	})
}
