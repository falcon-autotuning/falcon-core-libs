package group

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/core/Group_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/geometries/gategeometryarray1d"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.Group_destroy(C.GroupHandle(ptr))
	}
)

func FromCAPI(p unsafe.Pointer) (*Handle, error) {
	return cmemoryallocation.FromCAPI(
		p,
		construct,
		destroy,
	)
}
func New(name *channel.Handle, num_dots int32, screening_gates *connections.Handle, reservoir_gates *connections.Handle, plunger_gates *connections.Handle, barrier_gates *connections.Handle, order *connections.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{name, screening_gates, reservoir_gates, plunger_gates, barrier_gates, order}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Group_create(C.ChannelHandle(name.CAPIHandle()), C.int(num_dots), C.ConnectionsHandle(screening_gates.CAPIHandle()), C.ConnectionsHandle(reservoir_gates.CAPIHandle()), C.ConnectionsHandle(plunger_gates.CAPIHandle()), C.ConnectionsHandle(barrier_gates.CAPIHandle()), C.ConnectionsHandle(order.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}

func (h *Handle) Close() error {
	return cmemoryallocation.CloseAllocation(h, destroy)
}
func (h *Handle) Name() (*channel.Handle, error) {
	return cmemoryallocation.Read(h, func() (*channel.Handle, error) {

		return channel.FromCAPI(unsafe.Pointer(C.Group_name(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) NumDots() (int32, error) {
	return cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.Group_num_dots(C.GroupHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) Order() (*gategeometryarray1d.Handle, error) {
	return cmemoryallocation.Read(h, func() (*gategeometryarray1d.Handle, error) {

		return gategeometryarray1d.FromCAPI(unsafe.Pointer(C.Group_order(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) HasChannel(channel *channel.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (bool, error) {
		return bool(C.Group_has_channel(C.GroupHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))), nil
	})
}
func (h *Handle) IsChargeSensor() (bool, error) {
	return cmemoryallocation.Read(h, func() (bool, error) {
		return bool(C.Group_is_charge_sensor(C.GroupHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) GetAllChannelGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Group_get_all_channel_gates(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) ScreeningGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Group_screening_gates(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) ReservoirGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Group_reservoir_gates(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) PlungerGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Group_plunger_gates(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) BarrierGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Group_barrier_gates(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Ohmics() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Group_ohmics(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) DotGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Group_dot_gates(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetOhmic() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Group_get_ohmic(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetBarrierGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Group_get_barrier_gate(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetPlungerGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Group_get_plunger_gate(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetReservoirGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Group_get_reservoir_gate(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetScreeningGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Group_get_screening_gate(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetDotGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Group_get_dot_gate(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Group_get_gate(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetAllGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Group_get_all_gates(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetAllConnections() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Group_get_all_connections(C.GroupHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) HasOhmic(ohmic *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, ohmic}, func() (bool, error) {
		return bool(C.Group_has_ohmic(C.GroupHandle(h.CAPIHandle()), C.ConnectionHandle(ohmic.CAPIHandle()))), nil
	})
}
func (h *Handle) HasGate(gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gate}, func() (bool, error) {
		return bool(C.Group_has_gate(C.GroupHandle(h.CAPIHandle()), C.ConnectionHandle(gate.CAPIHandle()))), nil
	})
}
func (h *Handle) HasBarrierGate(barrier_gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, barrier_gate}, func() (bool, error) {
		return bool(C.Group_has_barrier_gate(C.GroupHandle(h.CAPIHandle()), C.ConnectionHandle(barrier_gate.CAPIHandle()))), nil
	})
}
func (h *Handle) HasPlungerGate(plunger_gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, plunger_gate}, func() (bool, error) {
		return bool(C.Group_has_plunger_gate(C.GroupHandle(h.CAPIHandle()), C.ConnectionHandle(plunger_gate.CAPIHandle()))), nil
	})
}
func (h *Handle) HasReservoirGate(reservoir_gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, reservoir_gate}, func() (bool, error) {
		return bool(C.Group_has_reservoir_gate(C.GroupHandle(h.CAPIHandle()), C.ConnectionHandle(reservoir_gate.CAPIHandle()))), nil
	})
}
func (h *Handle) HasScreeningGate(screening_gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, screening_gate}, func() (bool, error) {
		return bool(C.Group_has_screening_gate(C.GroupHandle(h.CAPIHandle()), C.ConnectionHandle(screening_gate.CAPIHandle()))), nil
	})
}
func (h *Handle) Equal(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Group_equal(C.GroupHandle(h.CAPIHandle()), C.GroupHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Group_not_equal(C.GroupHandle(h.CAPIHandle()), C.GroupHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Group_to_json_string(C.GroupHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Group_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
