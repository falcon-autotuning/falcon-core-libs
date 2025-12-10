package acquisitioncontext

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/contexts/AcquisitionContext_c_api.h>
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
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/instrumentport"
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
		C.AcquisitionContext_destroy(C.AcquisitionContextHandle(ptr))
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
				return unsafe.Pointer(C.AcquisitionContext_copy(C.AcquisitionContextHandle(handle.CAPIHandle()))), nil
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
		return bool(C.AcquisitionContext_equal(C.AcquisitionContextHandle(h.CAPIHandle()), C.AcquisitionContextHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.AcquisitionContext_not_equal(C.AcquisitionContextHandle(h.CAPIHandle()), C.AcquisitionContextHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AcquisitionContext_to_json_string(C.AcquisitionContextHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.AcquisitionContext_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(connection *connection.Handle, instrument_type string, units *symbolunit.Handle) (*Handle, error) {
	realinstrument_type := str.New(instrument_type)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{connection, realinstrument_type, units}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AcquisitionContext_create(C.ConnectionHandle(connection.CAPIHandle()), C.StringHandle(realinstrument_type.CAPIHandle()), C.SymbolUnitHandle(units.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func NewFromPort(port *instrumentport.Handle) (*Handle, error) {
	return cmemoryallocation.Read(port, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.AcquisitionContext_create_from_port(C.InstrumentPortHandle(port.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Connection() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.AcquisitionContext_connection(C.AcquisitionContextHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) InstrumentType() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.AcquisitionContext_instrument_type(C.AcquisitionContextHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("InstrumentType:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Units() (*symbolunit.Handle, error) {
	return cmemoryallocation.Read(h, func() (*symbolunit.Handle, error) {

		return symbolunit.FromCAPI(unsafe.Pointer(C.AcquisitionContext_units(C.AcquisitionContextHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) DivisionUnit(other *symbolunit.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.AcquisitionContext_division_unit(C.AcquisitionContextHandle(h.CAPIHandle()), C.SymbolUnitHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) Division(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.AcquisitionContext_division(C.AcquisitionContextHandle(h.CAPIHandle()), C.AcquisitionContextHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) MatchConnection(other *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.AcquisitionContext_match_connection(C.AcquisitionContextHandle(h.CAPIHandle()), C.ConnectionHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) MatchInstrumentType(other string) (bool, error) {
	realother := str.New(other)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, realother}, func() (bool, error) {
		return bool(C.AcquisitionContext_match_instrument_type(C.AcquisitionContextHandle(h.CAPIHandle()), C.StringHandle(realother.CAPIHandle()))), nil
	})
}
