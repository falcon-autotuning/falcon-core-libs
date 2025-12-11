package instrumentport

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/instrument_interfaces/names/InstrumentPort_c_api.h>
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
func NewPort(default_name string, psuedo_name *connection.Handle, instrument_type string, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_type := str.New(instrument_type)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, psuedo_name, realinstrument_type, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InstrumentPort_create_port(C.StringHandle(realdefault_name.CAPIHandle()), C.ConnectionHandle(psuedo_name.CAPIHandle()), C.StringHandle(realinstrument_type.CAPIHandle()), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewKnob(default_name string, psuedo_name *connection.Handle, instrument_type string, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_type := str.New(instrument_type)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, psuedo_name, realinstrument_type, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InstrumentPort_create_knob(C.StringHandle(realdefault_name.CAPIHandle()), C.ConnectionHandle(psuedo_name.CAPIHandle()), C.StringHandle(realinstrument_type.CAPIHandle()), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewMeter(default_name string, psuedo_name *connection.Handle, instrument_type string, units *symbolunit.Handle, description string) (*Handle, error) {
	realdefault_name := str.New(default_name)
	realinstrument_type := str.New(instrument_type)
	realdescription := str.New(description)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realdefault_name, psuedo_name, realinstrument_type, units, realdescription}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.InstrumentPort_create_meter(C.StringHandle(realdefault_name.CAPIHandle()), C.ConnectionHandle(psuedo_name.CAPIHandle()), C.StringHandle(realinstrument_type.CAPIHandle()), C.SymbolUnitHandle(units.CAPIHandle()), C.StringHandle(realdescription.CAPIHandle()))), nil
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
func (h *Handle) PsuedoName() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.InstrumentPort_psuedo_name(C.InstrumentPortHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) InstrumentType() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.InstrumentPort_instrument_type(C.InstrumentPortHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("InstrumentType:" + err.Error())
		}
		return strObj.ToGoString()
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
func (h *Handle) IsPort() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.InstrumentPort_is_port(C.InstrumentPortHandle(h.CAPIHandle()))), nil
	})
}
