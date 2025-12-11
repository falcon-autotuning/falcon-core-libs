package impedance

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/device_structures/Impedance_c_api.h>
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
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.Impedance_destroy(C.ImpedanceHandle(ptr))
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
				return unsafe.Pointer(C.Impedance_copy(C.ImpedanceHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Impedance_equal(C.ImpedanceHandle(h.CAPIHandle()), C.ImpedanceHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Impedance_not_equal(C.ImpedanceHandle(h.CAPIHandle()), C.ImpedanceHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Impedance_to_json_string(C.ImpedanceHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Impedance_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(connection *connection.Handle, resistance float64, capacitance float64) (*Handle, error) {
	return cmemoryallocation.Read(connection, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Impedance_create(C.ConnectionHandle(connection.CAPIHandle()), C.double(resistance), C.double(capacitance))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Connection() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Impedance_connection(C.ImpedanceHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Resistance() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.Impedance_resistance(C.ImpedanceHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Capacitance() (float64, error) {
	return cmemoryallocation.Read(h, func() (float64, error) {
		return float64(C.Impedance_capacitance(C.ImpedanceHandle(h.CAPIHandle()))), nil
	})
}
