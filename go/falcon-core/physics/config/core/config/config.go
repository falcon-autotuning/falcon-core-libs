package config

/*
#cgo pkg-config: falcon_core_c_api
#include <falcon_core/physics/config/core/Config_c_api.h>
#include <falcon_core/generic/String_c_api.h>
#include <stdlib.h>
*/
import "C"
import (
	"errors"
	"unsafe"

	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channel"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/channels"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/autotuner-interfaces/names/gname"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/cmemoryallocation"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/falconcorehandle"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listgname"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/listgroup"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapchannelconnections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/mapgnamegroup"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/pairconnectionconnection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/generic/str"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/group"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/config/core/voltageconstraints"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connection"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/connections"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/gaterelations"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/impedance"
	"github.com/falcon-autotuning/falcon-core-libs/go/falcon-core/physics/device-structures/impedances"
)

type Handle struct {
	falconcorehandle.FalconCoreHandle
}

var (
	construct = func(ptr unsafe.Pointer) *Handle {
		return &Handle{FalconCoreHandle: falconcorehandle.Construct(ptr)}
	}
	destroy = func(ptr unsafe.Pointer) {
		C.Config_destroy(C.ConfigHandle(ptr))
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
				return unsafe.Pointer(C.Config_copy(C.ConfigHandle(handle.CAPIHandle()))), nil
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
		return bool(C.Config_equal(C.ConfigHandle(h.CAPIHandle()), C.ConfigHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) NotEqual(other *Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, other}, func() (bool, error) {
		return bool(C.Config_not_equal(C.ConfigHandle(h.CAPIHandle()), C.ConfigHandle(other.CAPIHandle()))), nil
	})
}
func (h *Handle) ToJSON() (string, error) {
	return cmemoryallocation.Read(h, func() (string, error) {

		strObj, err := str.FromCAPI(unsafe.Pointer(C.Config_to_json_string(C.ConfigHandle(h.CAPIHandle()))))
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
				return unsafe.Pointer(C.Config_from_json_string(C.StringHandle(realjson.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func New(screening_gates *connections.Handle, plunger_gates *connections.Handle, ohmics *connections.Handle, barrier_gates *connections.Handle, reservoir_gates *connections.Handle, groups *mapgnamegroup.Handle, wiring_DC *impedances.Handle, constraints *voltageconstraints.Handle) (*Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{screening_gates, plunger_gates, ohmics, barrier_gates, reservoir_gates, groups, wiring_DC, constraints}, func() (*Handle, error) {

		return cmemoryallocation.NewAllocation(
			func() (unsafe.Pointer, error) {
				return unsafe.Pointer(C.Config_create(C.ConnectionsHandle(screening_gates.CAPIHandle()), C.ConnectionsHandle(plunger_gates.CAPIHandle()), C.ConnectionsHandle(ohmics.CAPIHandle()), C.ConnectionsHandle(barrier_gates.CAPIHandle()), C.ConnectionsHandle(reservoir_gates.CAPIHandle()), C.MapGnameGroupHandle(groups.CAPIHandle()), C.ImpedancesHandle(wiring_DC.CAPIHandle()), C.VoltageConstraintsHandle(constraints.CAPIHandle()))), nil
			},
			construct,
			destroy,
		)
	})
}
func (h *Handle) NumUniqueChannels() (int32, error) {
	return cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.Config_num_unique_channels(C.ConfigHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) VoltageConstraints() (*voltageconstraints.Handle, error) {
	return cmemoryallocation.Read(h, func() (*voltageconstraints.Handle, error) {

		return voltageconstraints.FromCAPI(unsafe.Pointer(C.Config_voltage_constraints(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Groups() (*mapgnamegroup.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapgnamegroup.Handle, error) {

		return mapgnamegroup.FromCAPI(unsafe.Pointer(C.Config_groups(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) WiringDc() (*impedances.Handle, error) {
	return cmemoryallocation.Read(h, func() (*impedances.Handle, error) {

		return impedances.FromCAPI(unsafe.Pointer(C.Config_wiring_DC(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Channels() (*channels.Handle, error) {
	return cmemoryallocation.Read(h, func() (*channels.Handle, error) {

		return channels.FromCAPI(unsafe.Pointer(C.Config_channels(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetImpedance(connection *connection.Handle) (*impedance.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, connection}, func() (*impedance.Handle, error) {

		return impedance.FromCAPI(unsafe.Pointer(C.Config_get_impedance(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(connection.CAPIHandle()))))
	})
}
func (h *Handle) GetAllGnames() (*listgname.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listgname.Handle, error) {

		return listgname.FromCAPI(unsafe.Pointer(C.Config_get_all_gnames(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetAllGroups() (*listgroup.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listgroup.Handle, error) {

		return listgroup.FromCAPI(unsafe.Pointer(C.Config_get_all_groups(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) HasChannel(channel *channel.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (bool, error) {
		return bool(C.Config_has_channel(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))), nil
	})
}
func (h *Handle) HasGname(gname *gname.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gname}, func() (bool, error) {
		return bool(C.Config_has_gname(C.ConfigHandle(h.CAPIHandle()), C.GnameHandle(gname.CAPIHandle()))), nil
	})
}
func (h *Handle) SelectGroup(gname *gname.Handle) (*group.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gname}, func() (*group.Handle, error) {

		return group.FromCAPI(unsafe.Pointer(C.Config_select_group(C.ConfigHandle(h.CAPIHandle()), C.GnameHandle(gname.CAPIHandle()))))
	})
}
func (h *Handle) GetDotNumber(channel *channel.Handle) (int32, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (int32, error) {
		return int32(C.Config_get_dot_number(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))), nil
	})
}
func (h *Handle) GetChargeSenseGroups() (*listgname.Handle, error) {
	return cmemoryallocation.Read(h, func() (*listgname.Handle, error) {

		return listgname.FromCAPI(unsafe.Pointer(C.Config_get_charge_sense_groups(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) OhmicInChargeSensor(ohmic *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, ohmic}, func() (bool, error) {
		return bool(C.Config_ohmic_in_charge_sensor(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(ohmic.CAPIHandle()))), nil
	})
}
func (h *Handle) GetAssociatedOhmic(reservoir_gate *connection.Handle) (*connection.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, reservoir_gate}, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Config_get_associated_ohmic(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(reservoir_gate.CAPIHandle()))))
	})
}
func (h *Handle) GetCurrentChannels() (*channels.Handle, error) {
	return cmemoryallocation.Read(h, func() (*channels.Handle, error) {

		return channels.FromCAPI(unsafe.Pointer(C.Config_get_current_channels(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetGname(channel *channel.Handle) (*gname.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*gname.Handle, error) {

		return gname.FromCAPI(unsafe.Pointer(C.Config_get_gname(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetGroupBarrierGates(gname *gname.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gname}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_group_barrier_gates(C.ConfigHandle(h.CAPIHandle()), C.GnameHandle(gname.CAPIHandle()))))
	})
}
func (h *Handle) GetGroupPlungerGates(gname *gname.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gname}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_group_plunger_gates(C.ConfigHandle(h.CAPIHandle()), C.GnameHandle(gname.CAPIHandle()))))
	})
}
func (h *Handle) GetGroupReservoirGates(gname *gname.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gname}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_group_reservoir_gates(C.ConfigHandle(h.CAPIHandle()), C.GnameHandle(gname.CAPIHandle()))))
	})
}
func (h *Handle) GetGroupScreeningGates(gname *gname.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gname}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_group_screening_gates(C.ConfigHandle(h.CAPIHandle()), C.GnameHandle(gname.CAPIHandle()))))
	})
}
func (h *Handle) GetGroupDotGates(gname *gname.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gname}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_group_dot_gates(C.ConfigHandle(h.CAPIHandle()), C.GnameHandle(gname.CAPIHandle()))))
	})
}
func (h *Handle) GetGroupGates(gname *gname.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gname}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_group_gates(C.ConfigHandle(h.CAPIHandle()), C.GnameHandle(gname.CAPIHandle()))))
	})
}
func (h *Handle) GetChannelBarrierGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_channel_barrier_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetChannelPlungerGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_channel_plunger_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetChannelReservoirGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_channel_reservoir_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetChannelScreeningGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_channel_screening_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetChannelDotGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_channel_dot_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetChannelGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_channel_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetChannelOhmics(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_channel_ohmics(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetChannelOrderNoOhmics(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_channel_order_no_ohmics(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetNumUniqueChannels() (int32, error) {
	return cmemoryallocation.Read(h, func() (int32, error) {
		return int32(C.Config_get_num_unique_channels(C.ConfigHandle(h.CAPIHandle()))), nil
	})
}
func (h *Handle) ReturnChannelsFromGate(gate *connection.Handle) (*channels.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gate}, func() (*channels.Handle, error) {

		return channels.FromCAPI(unsafe.Pointer(C.Config_return_channels_from_gate(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(gate.CAPIHandle()))))
	})
}
func (h *Handle) ReturnChannelFromGate(gate *connection.Handle) (*channel.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gate}, func() (*channel.Handle, error) {

		return channel.FromCAPI(unsafe.Pointer(C.Config_return_channel_from_gate(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(gate.CAPIHandle()))))
	})
}
func (h *Handle) OhmicInChannel(ohmic *connection.Handle, channel *channel.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, ohmic, channel}, func() (bool, error) {
		return bool(C.Config_ohmic_in_channel(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(ohmic.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))), nil
	})
}
func (h *Handle) GetDotChannelNeighbors(dot_gate *connection.Handle) (*pairconnectionconnection.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, dot_gate}, func() (*pairconnectionconnection.Handle, error) {

		return pairconnectionconnection.FromCAPI(unsafe.Pointer(C.Config_get_dot_channel_neighbors(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(dot_gate.CAPIHandle()))))
	})
}
func (h *Handle) GetBarrierGateDict() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_barrier_gate_dict(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetPlungerGateDict() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_plunger_gate_dict(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetReservoirGateDict() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_reservoir_gate_dict(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetScreeningGateDict() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_screening_gate_dict(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetDotGateDict() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_dot_gate_dict(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetGateDict() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_gate_dict(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedBarrierGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_barrier_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedPlungerGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_plunger_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedReservoirGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_reservoir_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedScreeningGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_screening_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedDotGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_dot_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedBarrierGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_barrier_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedPlungerGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_plunger_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedReservoirGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_reservoir_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedScreeningGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_screening_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedDotGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_dot_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedChannelBarrierGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_channel_barrier_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedChannelPlungerGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_channel_plunger_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedChannelReservoirGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_channel_reservoir_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedChannelScreeningGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_channel_screening_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedChannelDotGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_channel_dot_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetSharedChannelGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_shared_channel_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedChannelBarrierGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_channel_barrier_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedChannelPlungerGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_channel_plunger_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedChannelReservoirGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_channel_reservoir_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedChannelScreeningGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_channel_screening_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedChannelDotGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_channel_dot_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedChannelGates(channel *channel.Handle) (*connections.Handle, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, channel}, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_channel_gates(C.ConfigHandle(h.CAPIHandle()), C.ChannelHandle(channel.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedBarrierGatesByChannel() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_barrier_gates_by_channel(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedPlungerGatesByChannel() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_plunger_gates_by_channel(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedReservoirGatesByChannel() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_reservoir_gates_by_channel(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedScreeningGatesByChannel() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_screening_gates_by_channel(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedDotGatesByChannel() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_dot_gates_by_channel(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetIsolatedGatesByChannel() (*mapchannelconnections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*mapchannelconnections.Handle, error) {

		return mapchannelconnections.FromCAPI(unsafe.Pointer(C.Config_get_isolated_gates_by_channel(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GenerateGateRelations() (*gaterelations.Handle, error) {
	return cmemoryallocation.Read(h, func() (*gaterelations.Handle, error) {

		return gaterelations.FromCAPI(unsafe.Pointer(C.Config_generate_gate_relations(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) ScreeningGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_screening_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) ReservoirGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_reservoir_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) PlungerGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_plunger_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) BarrierGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_barrier_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) Ohmics() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_ohmics(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) DotGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_dot_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetOhmic() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Config_get_ohmic(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetBarrierGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Config_get_barrier_gate(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetPlungerGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Config_get_plunger_gate(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetReservoirGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Config_get_reservoir_gate(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetScreeningGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Config_get_screening_gate(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetDotGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Config_get_dot_gate(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetGate() (*connection.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connection.Handle, error) {

		return connection.FromCAPI(unsafe.Pointer(C.Config_get_gate(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetAllGates() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_all_gates(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) GetAllConnections() (*connections.Handle, error) {
	return cmemoryallocation.Read(h, func() (*connections.Handle, error) {

		return connections.FromCAPI(unsafe.Pointer(C.Config_get_all_connections(C.ConfigHandle(h.CAPIHandle()))))
	})
}
func (h *Handle) HasOhmic(ohmic *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, ohmic}, func() (bool, error) {
		return bool(C.Config_has_ohmic(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(ohmic.CAPIHandle()))), nil
	})
}
func (h *Handle) HasGate(gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, gate}, func() (bool, error) {
		return bool(C.Config_has_gate(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(gate.CAPIHandle()))), nil
	})
}
func (h *Handle) HasBarrierGate(barrier_gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, barrier_gate}, func() (bool, error) {
		return bool(C.Config_has_barrier_gate(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(barrier_gate.CAPIHandle()))), nil
	})
}
func (h *Handle) HasPlungerGate(plunger_gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, plunger_gate}, func() (bool, error) {
		return bool(C.Config_has_plunger_gate(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(plunger_gate.CAPIHandle()))), nil
	})
}
func (h *Handle) HasReservoirGate(reservoir_gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, reservoir_gate}, func() (bool, error) {
		return bool(C.Config_has_reservoir_gate(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(reservoir_gate.CAPIHandle()))), nil
	})
}
func (h *Handle) HasScreeningGate(screening_gate *connection.Handle) (bool, error) {
	return cmemoryallocation.MultiRead([]cmemoryallocation.HasCAPIHandle{h, screening_gate}, func() (bool, error) {
		return bool(C.Config_has_screening_gate(C.ConfigHandle(h.CAPIHandle()), C.ConnectionHandle(screening_gate.CAPIHandle()))), nil
	})
}
