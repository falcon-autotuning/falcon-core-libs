package rightreservoirwithimplantedohmic

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/geometries/RightReservoirWithImplantedOhmic_c_api.h>
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
		C.RightReservoirWithImplantedOhmic_destroy(C.RightReservoirWithImplantedOhmicHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(name string, left_neighbor *connection.Handle, ohmic *connection.Handle) (*Handle, error) {
	realname := str.New(name)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realname, left_neighbor, ohmic}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.RightReservoirWithImplantedOhmic_create(C.StringHandle(realname.CAPIHandle()), C.ConnectionHandle(left_neighbor.CAPIHandle()), C.ConnectionHandle(ohmic.CAPIHandle()))), nil
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

		strObj, err := str.FromCAPI(unsafe.Pointer(C.RightReservoirWithImplantedOhmic_name(C.RightReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Name:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Type() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.RightReservoirWithImplantedOhmic_type(C.RightReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Type:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) Ohmic() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.RightReservoirWithImplantedOhmic_ohmic(C.RightReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) LeftNeighbor() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.RightReservoirWithImplantedOhmic_left_neighbor(C.RightReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.RightReservoirWithImplantedOhmic_equal(C.RightReservoirWithImplantedOhmicHandle(h.CAPIHandle()), C.RightReservoirWithImplantedOhmicHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.RightReservoirWithImplantedOhmic_not_equal(C.RightReservoirWithImplantedOhmicHandle(h.CAPIHandle()), C.RightReservoirWithImplantedOhmicHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.RightReservoirWithImplantedOhmic_to_json_string(C.RightReservoirWithImplantedOhmicHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.RightReservoirWithImplantedOhmic_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
