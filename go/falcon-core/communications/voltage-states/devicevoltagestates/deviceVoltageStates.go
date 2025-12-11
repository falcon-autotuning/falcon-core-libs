package devicevoltagestates

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/communications/voltage_states/DeviceVoltageStates_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/communications/voltage-states/devicevoltagestate"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listdevicevoltagestate"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/math/point"
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
		C.DeviceVoltageStates_destroy(C.DeviceVoltageStatesHandle(ptr))
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
func NewEmpty() (*Handle, error) {

	return cmemoryallocation.NewAllocation(
		func() (unsafe.Pointer, error) {
			return unsafe.Pointer(C.DeviceVoltageStates_create_empty()), nil
		},
		construct,
		destroy,
	)
}
func New(items []*devicevoltagestate.Handle) (*Handle, error) {
	list, err := listdevicevoltagestate.New(items)
	if err != nil {
		return nil, errors.Join(errors.New("construction of list of devicevoltagestate failed"), err)
	}
	return cmemoryallocation.Read(list, func() (*Handle, error) {
		return NewFromList(list)
	})
}
func NewFromList(items *listdevicevoltagestate.Handle) (*Handle, error) {
	return cmemoryallocation.Read(items, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.DeviceVoltageStates_create(C.ListDeviceVoltageStateHandle(items.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) States() (*listdevicevoltagestate.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listdevicevoltagestate.Handle, error) {

		return listdevicevoltagestate.FromCAPI(unsafe.Pointer(C.DeviceVoltageStates_states(C.DeviceVoltageStatesHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) AddState(state *devicevoltagestate.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{state}, func() error {
		C.DeviceVoltageStates_add_state(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(state.CAPIHandle()))
		return nil
	})
}
func (h *Handle) FindState(connection *connection.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connection}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.DeviceVoltageStates_find_state(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.ConnectionHandle(connection.CAPIHandle()))))
	})
}
func (h *Handle) ToPoint() (*point.Handle, error) {
	return cmemoryallocation.Read(h, func() (*point.Handle, error) {

		return point.FromCAPI(unsafe.Pointer(C.DeviceVoltageStates_to_point(C.DeviceVoltageStatesHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Intersection(other *Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (*Handle, error) {

		return FromCAPI(unsafe.Pointer(C.DeviceVoltageStates_intersection(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.DeviceVoltageStatesHandle(other.CAPIHandle()))))
	})
}
func (h *Handle) PushBack(value *devicevoltagestate.Handle) error {
	return cmemoryallocation.ReadWrite(h, []cmemoryallocation.HasCAPIHandle{value}, func() error {
		C.DeviceVoltageStates_push_back(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(value.CAPIHandle()))
		return nil
	})
}
func (h *Handle) Size() (uint64, error) {
	return cmemoryallocation.Read(h, func() (uint64, error) {
		return uint64(C.DeviceVoltageStates_size(C.DeviceVoltageStatesHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Empty() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.DeviceVoltageStates_empty(C.DeviceVoltageStatesHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) EraseAt(idx uint64) error {
	return cmemoryallocation.Write(h, func() error {
		C.DeviceVoltageStates_erase_at(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.size_t(idx))
		return nil
	})
}
func (h *Handle) Clear() error {
	return cmemoryallocation.Write(h, func() error {
		C.DeviceVoltageStates_clear(C.DeviceVoltageStatesHandle(h.CAPIHandle()))
		return nil
	})
}
func (h *Handle) At(idx uint64) (*devicevoltagestate.Handle, error) {
	return cmemoryallocation.Read(h, func() (*devicevoltagestate.Handle, error) {

		return devicevoltagestate.FromCAPI(unsafe.Pointer(C.DeviceVoltageStates_at(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.size_t(idx))))
	})
}
func (h *Handle) Items() (*listdevicevoltagestate.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listdevicevoltagestate.Handle, error) {

		return listdevicevoltagestate.FromCAPI(unsafe.Pointer(C.DeviceVoltageStates_items(C.DeviceVoltageStatesHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Contains(value *devicevoltagestate.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (bool, error) {
		return bool(C.DeviceVoltageStates_contains(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Index(value *devicevoltagestate.Handle) (uint64, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, value}, func() (uint64, error) {
		return uint64(C.DeviceVoltageStates_index(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.DeviceVoltageStateHandle(value.CAPIHandle()))), nil
	})
}
func (h *Handle) Equal(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.DeviceVoltageStates_equal(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.DeviceVoltageStatesHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(b *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, b}, func() (bool, error) {
		return bool(C.DeviceVoltageStates_not_equal(C.DeviceVoltageStatesHandle(h.CAPIHandle()), C.DeviceVoltageStatesHandle(b.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.DeviceVoltageStates_to_json_string(C.DeviceVoltageStatesHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.DeviceVoltageStates_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
