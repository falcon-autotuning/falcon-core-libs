package measurementcontext

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/autotuner_interfaces/contexts/MeasurementContext_c_api.h>
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
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.MeasurementContext_destroy(C.MeasurementContextHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(connection *connection.Handle, instrument_type string) (*Handle, error) {
	realinstrument_type := str.New(instrument_type)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{connection, realinstrument_type}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.MeasurementContext_create(C.ConnectionHandle(connection.CAPIHandle()), C.StringHandle(realinstrument_type.CAPIHandle()))), nil
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
				return unsafe.Pointer(C.MeasurementContext_create_from_port(C.InstrumentPortHandle(port.CAPIHandle()))), nil
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

		return connection.FromCAPI(unsafe.Pointer(C.MeasurementContext_connection(C.MeasurementContextHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) InstrumentType() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MeasurementContext_instrument_type(C.MeasurementContextHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("InstrumentType:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MeasurementContext_equal(C.MeasurementContextHandle(h.CAPIHandle()), C.MeasurementContextHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.MeasurementContext_not_equal(C.MeasurementContextHandle(h.CAPIHandle()), C.MeasurementContextHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.MeasurementContext_to_json_string(C.MeasurementContextHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.MeasurementContext_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
