package devicevoltagestate

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/voltage_states/DeviceVoltageState_c_api.h>
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
		C.DeviceVoltageState_destroy(C.DeviceVoltageStateHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(connection *connection.Handle, voltage float64, unit *symbolunit.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{connection, unit}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.DeviceVoltageState_create(C.ConnectionHandle(connection.CAPIHandle()), C.double(voltage), C.SymbolUnitHandle(unit.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Connection() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_connection(C.DeviceVoltageStateHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Voltage() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.DeviceVoltageState_voltage(C.DeviceVoltageStateHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Value() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.DeviceVoltageState_value(C.DeviceVoltageStateHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Unit() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_unit(C.DeviceVoltageStateHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) ConvertTo(target_unit *symbolunit.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{target_unit}, func() error {
		C.DeviceVoltageState_convert_to(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.SymbolUnitHandle(target_unit.CAPIHandle()))
		return nil
	})
}
func (h *Handle) MultiplyInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_multiply_int(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) MultiplyDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_multiply_double(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) MultiplyQuantity(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_multiply_quantity(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MultiplyEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.DeviceVoltageState_multiply_equals_int(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) MultiplyEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.DeviceVoltageState_multiply_equals_double(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) MultiplyEqualsQuantity(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.DeviceVoltageState_multiply_equals_quantity(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) DivideInt(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_divide_int(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) DivideDouble(other float64) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_divide_double(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.double(other))))
	})
}
func (h *Handle) DivideQuantity(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_divide_quantity(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) DivideEqualsInt(other int32) error {
	return cmemoryallocation.Write(h, func() error {
		C.DeviceVoltageState_divide_equals_int(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.int(other))
		return nil
	})
}
func (h *Handle) DivideEqualsDouble(other float64) error {
	return cmemoryallocation.Write(h, func() error {
		C.DeviceVoltageState_divide_equals_double(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.double(other))
		return nil
	})
}
func (h *Handle) DivideEqualsQuantity(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.DeviceVoltageState_divide_equals_quantity(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Power(other int32) (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_power(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.int(other))))
	})
}
func (h *Handle) AddQuantity(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_add_quantity(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) AddEqualsQuantity(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.DeviceVoltageState_add_equals_quantity(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) SubtractQuantity(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_subtract_quantity(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) SubtractEqualsQuantity(other *Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{other}, func() error {
		C.DeviceVoltageState_subtract_equals_quantity(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(other.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Negate() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_negate(C.DeviceVoltageStateHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Abs() (*Handle, error) {
	return cmemoryallocation.Read(h, func() (*Handle, error) {

		return Handle.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_abs(C.DeviceVoltageStateHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.DeviceVoltageState_equal(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.DeviceVoltageState_not_equal(C.DeviceVoltageStateHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.DeviceVoltageState_to_json_string(C.DeviceVoltageStateHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.DeviceVoltageState_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
