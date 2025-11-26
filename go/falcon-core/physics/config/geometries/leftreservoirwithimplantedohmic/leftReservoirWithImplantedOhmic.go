package leftreservoirwithimplantedohmic

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/geometries/LeftReservoirWithImplantedOhmic_c_api.h>
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
		C.LeftReservoirWithImplantedOhmic_destroy(C.LeftReservoirWithImplantedOhmicHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(name string, right_neighbor *connection.Handle, ohmic *connection.Handle) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realname, right_neighbor, ohmic}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_create(C.StringHandle(realname.CAPIHandle()), C.ConnectionHandle(right_neighbor.CAPIHandle()), C.ConnectionHandle(ohmic.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Name() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_name(C.LeftReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Name:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Type() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_type(C.LeftReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Type:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Ohmic() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_ohmic(C.LeftReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) RightNeighbor() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_right_neighbor(C.LeftReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LeftReservoirWithImplantedOhmic_equal(C.LeftReservoirWithImplantedOhmicHandle(h.CAPIHandle()), C.LeftReservoirWithImplantedOhmicHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.LeftReservoirWithImplantedOhmic_not_equal(C.LeftReservoirWithImplantedOhmicHandle(h.CAPIHandle()), C.LeftReservoirWithImplantedOhmicHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_to_json_string(C.LeftReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.LeftReservoirWithImplantedOhmic_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
