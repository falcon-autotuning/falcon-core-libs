package devicevoltagestate

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/voltage_states/DeviceVoltageState_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <falcon_core/physics/device_structures/Connection_c_api.h>
#include <falcon_core/physics/units/SymbolUnit_c_api.h>
#include <stdlib.h>
*/
import "C"

import (
	"errors"
	"runtime"
	"sync"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/deviceStructures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/units/symbolunit"
)

type chandle C.DeviceVoltageStateHandle

type Handle struct {
	chandle chandle
	mu      sync.RWMutex
	closed  bool
}

func new(h chandle) *Handle {
	handle := &Handle{chandle: h}
	runtime.SetFinalizer(handle, func(h *Handle) { h.Close() })
	return handle
}

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	if p == nil {
		return nil, errors.New("FromCAPI: pointer is nil")
	}
	return new(chandle(p)), nil
}

func (h *Handle) CAPIHandle() (unsafe.Pointer, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("CAPIHandle: handle is closed")
	}
	return unsafe.Pointer(h.chandle), nil
}

func (h *Handle) Close() error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("Handle already closed")
	}
	C.DeviceVoltageState_destroy(C.DeviceVoltageStateHandle(h.chandle))
	h.closed = true
	h.chandle = nil
	return nil
}

func New(connection *connection.Handle, voltage float64, unit *symbolunit.Handle) (*Handle, error) {
	connPtr, err := connection.CAPIHandle()
	if err != nil {
		return nil, err
	}
	unitPtr, err := unit.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.DeviceVoltageState_create(
		C.ConnectionHandle(connPtr),
		C.double(voltage),
		C.SymbolUnitHandle(unitPtr),
	))
	return new(h), nil
}

func (h *Handle) Connection() (*connection.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Connection: handle is closed")
	}
	cConn := C.DeviceVoltageState_connection(C.DeviceVoltageStateHandle(h.chandle))
	return connection.FromCAPI(unsafe.Pointer(cConn))
}

func (h *Handle) Voltage() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Voltage: handle is closed")
	}
	val := float64(C.DeviceVoltageState_voltage(C.DeviceVoltageStateHandle(h.chandle)))
	return val, nil
}

func (h *Handle) Value() (float64, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return 0, errors.New("Value: handle is closed")
	}
	val := float64(C.DeviceVoltageState_value(C.DeviceVoltageStateHandle(h.chandle)))
	return val, nil
}

func (h *Handle) Unit() (*symbolunit.Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Unit: handle is closed")
	}
	cUnit := C.DeviceVoltageState_unit(C.DeviceVoltageStateHandle(h.chandle))
	return symbolunit.FromCAPI(unsafe.Pointer(cUnit))
}

func (h *Handle) ConvertTo(targetUnit *symbolunit.Handle) error {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return errors.New("ConvertTo: handle is closed")
	}
	unitPtr, err := targetUnit.CAPIHandle()
	if err != nil {
		return err
	}
	C.DeviceVoltageState_convert_to(C.DeviceVoltageStateHandle(h.chandle), C.SymbolUnitHandle(unitPtr))
	return nil
}

func (h *Handle) MultiplyInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("MultiplyInt: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_multiply_int(C.DeviceVoltageStateHandle(h.chandle), C.int(other)))
	return new(res), nil
}

func (h *Handle) MultiplyDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("MultiplyDouble: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_multiply_double(C.DeviceVoltageStateHandle(h.chandle), C.double(other)))
	return new(res), nil
}

func (h *Handle) MultiplyQuantity(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("MultiplyQuantity: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("MultiplyQuantity: other handle is closed or nil")
	}
	res := chandle(C.DeviceVoltageState_multiply_quantity(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) MultiplyEqualsInt(other int) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("MultiplyEqualsInt: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_multiply_equals_int(C.DeviceVoltageStateHandle(h.chandle), C.int(other)))
	return new(res), nil
}

func (h *Handle) MultiplyEqualsDouble(other float64) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("MultiplyEqualsDouble: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_multiply_equals_double(C.DeviceVoltageStateHandle(h.chandle), C.double(other)))
	return new(res), nil
}

func (h *Handle) MultiplyEqualsQuantity(other *Handle) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("MultiplyEqualsQuantity: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("MultiplyEqualsQuantity: other handle is closed or nil")
	}
	res := chandle(C.DeviceVoltageState_multiply_equals_quantity(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) DivideInt(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DivideInt: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_divide_int(C.DeviceVoltageStateHandle(h.chandle), C.int(other)))
	return new(res), nil
}

func (h *Handle) DivideDouble(other float64) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DivideDouble: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_divide_double(C.DeviceVoltageStateHandle(h.chandle), C.double(other)))
	return new(res), nil
}

func (h *Handle) DivideQuantity(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DivideQuantity: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("DivideQuantity: other handle is closed or nil")
	}
	res := chandle(C.DeviceVoltageState_divide_quantity(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) DivideEqualsInt(other int) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DivideEqualsInt: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_divide_equals_int(C.DeviceVoltageStateHandle(h.chandle), C.int(other)))
	return new(res), nil
}

func (h *Handle) DivideEqualsDouble(other float64) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DivideEqualsDouble: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_divide_equals_double(C.DeviceVoltageStateHandle(h.chandle), C.double(other)))
	return new(res), nil
}

func (h *Handle) DivideEqualsQuantity(other *Handle) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("DivideEqualsQuantity: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("DivideEqualsQuantity: other handle is closed or nil")
	}
	res := chandle(C.DeviceVoltageState_divide_equals_quantity(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) Power(other int) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Power: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_power(C.DeviceVoltageStateHandle(h.chandle), C.int(other)))
	return new(res), nil
}

func (h *Handle) AddQuantity(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("AddQuantity: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("AddQuantity: other handle is closed or nil")
	}
	res := chandle(C.DeviceVoltageState_add_quantity(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) AddEqualsQuantity(other *Handle) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("AddEqualsQuantity: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("AddEqualsQuantity: other handle is closed or nil")
	}
	res := chandle(C.DeviceVoltageState_add_equals_quantity(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) SubtractQuantity(other *Handle) (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("SubtractQuantity: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("SubtractQuantity: other handle is closed or nil")
	}
	res := chandle(C.DeviceVoltageState_subtract_quantity(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) SubtractEqualsQuantity(other *Handle) (*Handle, error) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("SubtractEqualsQuantity: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return nil, errors.New("SubtractEqualsQuantity: other handle is closed or nil")
	}
	res := chandle(C.DeviceVoltageState_subtract_equals_quantity(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return new(res), nil
}

func (h *Handle) Negate() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Negate: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_negate(C.DeviceVoltageStateHandle(h.chandle)))
	return new(res), nil
}

func (h *Handle) Abs() (*Handle, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return nil, errors.New("Abs: handle is closed")
	}
	res := chandle(C.DeviceVoltageState_abs(C.DeviceVoltageStateHandle(h.chandle)))
	return new(res), nil
}

func (h *Handle) Equal(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("Equal: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return false, errors.New("Equal: other handle is closed or nil")
	}
	val := bool(C.DeviceVoltageState_equal(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return val, nil
}

func (h *Handle) NotEqual(other *Handle) (bool, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return false, errors.New("NotEqual: handle is closed")
	}
	if other == nil || other.closed || other.chandle == nil {
		return false, errors.New("NotEqual: other handle is closed or nil")
	}
	val := bool(C.DeviceVoltageState_not_equal(C.DeviceVoltageStateHandle(h.chandle), C.DeviceVoltageStateHandle(other.chandle)))
	return val, nil
}

func (h *Handle) ToJSON() (string, error) {
	h.mu.RLock()
	defer h.mu.RUnlock()
	if h.closed || h.chandle == nil {
		return "", errors.New("ToJSON: handle is closed")
	}
	cStr := C.DeviceVoltageState_to_json_string(C.DeviceVoltageStateHandle(h.chandle))
	strHandle, err := str.FromCAPI(unsafe.Pointer(cStr))
	if err != nil {
		return "", err
	}
	defer strHandle.Close()
	return strHandle.ToGoString()
}

func FromJSON(json string) (*Handle, error) {
	strHandle := str.New(json)
	defer strHandle.Close()
	strPtr, err := strHandle.CAPIHandle()
	if err != nil {
		return nil, err
	}
	h := chandle(C.DeviceVoltageState_from_json_string(C.StringHandle(strPtr)))
	return new(h), nil
}
