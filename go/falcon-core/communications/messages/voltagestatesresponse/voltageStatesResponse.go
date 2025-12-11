package voltagestatesresponse

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/messages/VoltageStatesResponse_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestates"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.VoltageStatesResponse_destroy(C.VoltageStatesResponseHandle(ptr))
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
				return unsafe.Pointer(C.VoltageStatesResponse_copy(C.VoltageStatesResponseHandle(handle.CAPIHandle()))), nil
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
		return bool(C.VoltageStatesResponse_equal(C.VoltageStatesResponseHandle(h.CAPIHandle()), C.VoltageStatesResponseHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.VoltageStatesResponse_not_equal(C.VoltageStatesResponseHandle(h.CAPIHandle()), C.VoltageStatesResponseHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.VoltageStatesResponse_to_json_string(C.VoltageStatesResponseHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.VoltageStatesResponse_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(message string, states *devicevoltagestates.Handle) (*Handle, error) {
	realmessage := str.New(message)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realmessage, states}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.VoltageStatesResponse_create(C.StringHandle(realmessage.CAPIHandle()), C.DeviceVoltageStatesHandle(states.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Message() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.VoltageStatesResponse_message(C.VoltageStatesResponseHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Message:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
func (h *Handle) States() (*devicevoltagestates.Handle, error) {
	return cmemoryallocation.Read(h, func() (*devicevoltagestates.Handle, error) {

		return devicevoltagestates.FromCAPI(unsafe.Pointer(C.VoltageStatesResponse_states(C.VoltageStatesResponseHandle(h.CAPIHandle()))))
	})
}
