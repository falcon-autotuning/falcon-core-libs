package instrumentport

/*
#cgo pkg-config: falcon-core-c-api
#include <falcon-core/instrument_interfaces/names/InstrumentPort_c_api.h>
#include <falcon-core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/access"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrument"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentcharacteristic"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/porttype"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/scope"
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
		C.InstrumentPort_destroy(C.InstrumentPortHandle(ptr))
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
				return unsafe.Pointer(C.InstrumentPort_copy(C.InstrumentPortHandle(handle.CAPIHandle()))), nil
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
		return bool(C.InstrumentPort_equal(C.InstrumentPortHandle(h.CAPIHandle()), C.InstrumentPortHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.InstrumentPort_not_equal(C.InstrumentPortHandle(h.CAPIHandle()), C.InstrumentPortHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.InstrumentPort_to_json_string(C.InstrumentPortHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.InstrumentPort_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewPort(default_name string, instrument_name string, scope scope.Scope, access access.Access, characteristic instrumentcharacteristic.InstrumentCharacteristic, type_ porttype.PortType, pseudo_name *connection.Handle, instrument_type instrument.Instrument, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_name := str.New(instrument_name)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, realinstrument_name, pseudo_name, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InstrumentPort_create_port(C.StringHandle(realdefault_name.CAPIHandle()), C.StringHandle(realinstrument_name.CAPIHandle()), C.Scope(scope), C.Access(access), C.InstrumentCharacteristic(characteristic), C.PortType(type_), C.ConnectionHandle(pseudo_name.CAPIHandle()), C.Instrument(instrument_type), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewSetting(default_name string, instrument_name string, scope scope.Scope, access access.Access, characteristic instrumentcharacteristic.InstrumentCharacteristic, pseudo_name *connection.Handle, instrument_type instrument.Instrument, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_name := str.New(instrument_name)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, realinstrument_name, pseudo_name, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InstrumentPort_create_setting(C.StringHandle(realdefault_name.CAPIHandle()), C.StringHandle(realinstrument_name.CAPIHandle()), C.Scope(scope), C.Access(access), C.InstrumentCharacteristic(characteristic), C.ConnectionHandle(pseudo_name.CAPIHandle()), C.Instrument(instrument_type), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewKnob(default_name string, instrument_name string, pseudo_name *connection.Handle, instrument_type instrument.Instrument, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_name := str.New(instrument_name)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, realinstrument_name, pseudo_name, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InstrumentPort_create_knob(C.StringHandle(realdefault_name.CAPIHandle()), C.StringHandle(realinstrument_name.CAPIHandle()), C.ConnectionHandle(pseudo_name.CAPIHandle()), C.Instrument(instrument_type), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewMeter(default_name string, instrument_name string, pseudo_name *connection.Handle, instrument_type instrument.Instrument, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_name := str.New(instrument_name)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, realinstrument_name, pseudo_name, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InstrumentPort_create_meter(C.StringHandle(realdefault_name.CAPIHandle()), C.StringHandle(realinstrument_name.CAPIHandle()), C.ConnectionHandle(pseudo_name.CAPIHandle()), C.Instrument(instrument_type), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewTimer() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.InstrumentPort_create_timer()), nil
		},
		construct,
		destroy,
	)
}
func NewExecutionClock() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.InstrumentPort_create_execution_clock()), nil
		},
		construct,
		destroy,
	)
}
func (h *Handle) DefaultName() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.InstrumentPort_default_name(C.InstrumentPortHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("DefaultName:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) InstrumentName() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.InstrumentPort_instrument_name(C.InstrumentPortHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("InstrumentName:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) PseudoName() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.InstrumentPort_pseudo_name(C.InstrumentPortHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) InstrumentType() (instrument.Instrument, error) {
	return cmemoryallocation.Read(h, func() (instrument.Instrument, error) {
		return instrument.Instrument(C.InstrumentPort_instrument_type(C.InstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Scope() (scope.Scope, error) {
	return cmemoryallocation.Read(h, func() (scope.Scope, error) {
		return scope.Scope(C.InstrumentPort_scope(C.InstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Access() (access.Access, error) {
	return cmemoryallocation.Read(h, func() (access.Access, error) {
		return access.Access(C.InstrumentPort_access(C.InstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Characteristic() (instrumentcharacteristic.InstrumentCharacteristic, error) {
	return cmemoryallocation.Read(h, func() (instrumentcharacteristic.InstrumentCharacteristic, error) {
		return instrumentcharacteristic.InstrumentCharacteristic(C.InstrumentPort_characteristic(C.InstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Units() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.InstrumentPort_units(C.InstrumentPortHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Description() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.InstrumentPort_description(C.InstrumentPortHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Description:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) InstrumentFacingName() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.InstrumentPort_instrument_facing_name(C.InstrumentPortHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("InstrumentFacingName:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Type() (porttype.PortType, error) {
	return cmemoryallocation.Read(h, func() (porttype.PortType, error) {
		return porttype.PortType(C.InstrumentPort_type(C.InstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsKnob() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.InstrumentPort_is_knob(C.InstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsMeter() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.InstrumentPort_is_meter(C.InstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) IsSetting() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.InstrumentPort_is_setting(C.InstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
