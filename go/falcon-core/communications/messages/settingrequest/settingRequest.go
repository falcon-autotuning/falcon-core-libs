package settingrequest

/*
#cgo pkg-config: falcon-core-c-api
#include <falcon-core/communications/messages/SettingRequest_c_api.h>
#include <falcon-core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapinstrumentportquantity"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/instrument-interfaces/names/ports"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.SettingRequest_destroy(C.SettingRequestHandle(ptr))
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
				return unsafe.Pointer(C.SettingRequest_copy(C.SettingRequestHandle(handle.CAPIHandle()))), nil
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
		return bool(C.SettingRequest_equal(C.SettingRequestHandle(h.CAPIHandle()), C.SettingRequestHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.SettingRequest_not_equal(C.SettingRequestHandle(h.CAPIHandle()), C.SettingRequestHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.SettingRequest_to_json_string(C.SettingRequestHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.SettingRequest_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(message string, getters *ports.Handle, setters *mapinstrumentportquantity.Handle) (*Handle, error) {
	realmessage := str.New(message)
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{realmessage, getters, setters}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.SettingRequest_create(C.StringHandle(realmessage.CAPIHandle()), C.PortsHandle(getters.CAPIHandle()), C.MapInstrumentPortQuantityHandle(setters.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) Getters() (*ports.Handle, error) {
	return cmemoryallocation.Read(h, func() (*ports.Handle, error) {

		return ports.FromCAPI(unsafe.Pointer(C.SettingRequest_getters(C.SettingRequestHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Setters() (*mapinstrumentportquantity.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapinstrumentportquantity.Handle, error) {

		return mapinstrumentportquantity.FromCAPI(unsafe.Pointer(C.SettingRequest_setters(C.SettingRequestHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Message() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.SettingRequest_message(C.SettingRequestHandle(h.CAPIHandle()))))
		if err != nil {
			return "", errors.New("Message:" + err.Error())
		}
		return strObj.ToGoString()
	})
}
