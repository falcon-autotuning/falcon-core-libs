# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .channel cimport Channel
from .channels cimport Channels
from .connection cimport Connection
from .connections cimport Connections
from .gate_relations cimport GateRelations
from .gname cimport Gname
from .group cimport Group
from .impedance cimport Impedance
from .impedances cimport Impedances
from .list_gname cimport ListGname
from .list_group cimport ListGroup
from .map_channel_connections cimport MapChannelConnections
from .map_gname_group cimport MapGnameGroup
from .pair_connection_connection cimport PairConnectionConnection
from .voltage_constraints cimport VoltageConstraints

cdef class Config:
    cdef c_api.ConfigHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ConfigHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ConfigHandle>0 and self.owned:
            c_api.Config_destroy(self.handle)
        self.handle = <c_api.ConfigHandle>0

    cdef Config from_capi(cls, c_api.ConfigHandle h):
        cdef Config obj = <Config>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, screening_gates, plunger_gates, ohmics, barrier_gates, reservoir_gates, groups, wiring_DC, constraints):
        cdef c_api.ConfigHandle h
        h = c_api.Config_create(<c_api.ConnectionsHandle>screening_gates.handle, <c_api.ConnectionsHandle>plunger_gates.handle, <c_api.ConnectionsHandle>ohmics.handle, <c_api.ConnectionsHandle>barrier_gates.handle, <c_api.ConnectionsHandle>reservoir_gates.handle, <c_api.MapGnameGroupHandle>groups.handle, <c_api.ImpedancesHandle>wiring_DC.handle, <c_api.VoltageConstraintsHandle>constraints.handle)
        if h == <c_api.ConfigHandle>0:
            raise MemoryError("Failed to create Config")
        cdef Config obj = <Config>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ConfigHandle h
        try:
            h = c_api.Config_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ConfigHandle>0:
            raise MemoryError("Failed to create Config")
        cdef Config obj = <Config>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def num_unique_channels(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_num_unique_channels(self.handle)

    def voltage_constraints(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VoltageConstraintsHandle h_ret
        h_ret = c_api.Config_voltage_constraints(self.handle)
        if h_ret == <c_api.VoltageConstraintsHandle>0:
            return None
        return VoltageConstraints.from_capi(VoltageConstraints, h_ret)

    def groups(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapGnameGroupHandle h_ret
        h_ret = c_api.Config_groups(self.handle)
        if h_ret == <c_api.MapGnameGroupHandle>0:
            return None
        return MapGnameGroup.from_capi(MapGnameGroup, h_ret)

    def wiring_DC(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ImpedancesHandle h_ret
        h_ret = c_api.Config_wiring_DC(self.handle)
        if h_ret == <c_api.ImpedancesHandle>0:
            return None
        return Impedances.from_capi(Impedances, h_ret)

    def channels(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ChannelsHandle h_ret
        h_ret = c_api.Config_channels(self.handle)
        if h_ret == <c_api.ChannelsHandle>0:
            return None
        return Channels.from_capi(Channels, h_ret)

    def get_impedance(self, connection):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ImpedanceHandle h_ret
        h_ret = c_api.Config_get_impedance(self.handle, <c_api.ConnectionHandle>connection.handle)
        if h_ret == <c_api.ImpedanceHandle>0:
            return None
        return Impedance.from_capi(Impedance, h_ret)

    def get_all_gnames(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListGnameHandle h_ret
        h_ret = c_api.Config_get_all_gnames(self.handle)
        if h_ret == <c_api.ListGnameHandle>0:
            return None
        return ListGname.from_capi(ListGname, h_ret)

    def get_all_groups(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListGroupHandle h_ret
        h_ret = c_api.Config_get_all_groups(self.handle)
        if h_ret == <c_api.ListGroupHandle>0:
            return None
        return ListGroup.from_capi(ListGroup, h_ret)

    def has_channel(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_has_channel(self.handle, <c_api.ChannelHandle>channel.handle)

    def has_gname(self, gname):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_has_gname(self.handle, <c_api.GnameHandle>gname.handle)

    def select_group(self, gname):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.GroupHandle h_ret
        h_ret = c_api.Config_select_group(self.handle, <c_api.GnameHandle>gname.handle)
        if h_ret == <c_api.GroupHandle>0:
            return None
        return Group.from_capi(Group, h_ret)

    def get_dot_number(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_get_dot_number(self.handle, <c_api.ChannelHandle>channel.handle)

    def get_charge_sense_groups(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListGnameHandle h_ret
        h_ret = c_api.Config_get_charge_sense_groups(self.handle)
        if h_ret == <c_api.ListGnameHandle>0:
            return None
        return ListGname.from_capi(ListGname, h_ret)

    def ohmic_in_charge_sensor(self, ohmic):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_ohmic_in_charge_sensor(self.handle, <c_api.ConnectionHandle>ohmic.handle)

    def get_associated_ohmic(self, reservoir_gate):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Config_get_associated_ohmic(self.handle, <c_api.ConnectionHandle>reservoir_gate.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_current_channels(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ChannelsHandle h_ret
        h_ret = c_api.Config_get_current_channels(self.handle)
        if h_ret == <c_api.ChannelsHandle>0:
            return None
        return Channels.from_capi(Channels, h_ret)

    def get_gname(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.GnameHandle h_ret
        h_ret = c_api.Config_get_gname(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.GnameHandle>0:
            return None
        return Gname.from_capi(Gname, h_ret)

    def get_group_barrier_gates(self, gname):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_group_barrier_gates(self.handle, <c_api.GnameHandle>gname.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_group_plunger_gates(self, gname):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_group_plunger_gates(self.handle, <c_api.GnameHandle>gname.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_group_reservoir_gates(self, gname):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_group_reservoir_gates(self.handle, <c_api.GnameHandle>gname.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_group_screening_gates(self, gname):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_group_screening_gates(self.handle, <c_api.GnameHandle>gname.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_group_dot_gates(self, gname):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_group_dot_gates(self.handle, <c_api.GnameHandle>gname.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_group_gates(self, gname):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_group_gates(self.handle, <c_api.GnameHandle>gname.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_channel_barrier_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_channel_barrier_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_channel_plunger_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_channel_plunger_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_channel_reservoir_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_channel_reservoir_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_channel_screening_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_channel_screening_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_channel_dot_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_channel_dot_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_channel_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_channel_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_channel_ohmics(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_channel_ohmics(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_channel_order_no_ohmics(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_channel_order_no_ohmics(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_num_unique_channels(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_get_num_unique_channels(self.handle)

    def return_channels_from_gate(self, gate):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ChannelsHandle h_ret
        h_ret = c_api.Config_return_channels_from_gate(self.handle, <c_api.ConnectionHandle>gate.handle)
        if h_ret == <c_api.ChannelsHandle>0:
            return None
        return Channels.from_capi(Channels, h_ret)

    def return_channel_from_gate(self, gate):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ChannelHandle h_ret
        h_ret = c_api.Config_return_channel_from_gate(self.handle, <c_api.ConnectionHandle>gate.handle)
        if h_ret == <c_api.ChannelHandle>0:
            return None
        return Channel.from_capi(Channel, h_ret)

    def ohmic_in_channel(self, ohmic, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_ohmic_in_channel(self.handle, <c_api.ConnectionHandle>ohmic.handle, <c_api.ChannelHandle>channel.handle)

    def get_dot_channel_neighbors(self, dot_gate):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PairConnectionConnectionHandle h_ret
        h_ret = c_api.Config_get_dot_channel_neighbors(self.handle, <c_api.ConnectionHandle>dot_gate.handle)
        if h_ret == <c_api.PairConnectionConnectionHandle>0:
            return None
        return PairConnectionConnection.from_capi(PairConnectionConnection, h_ret)

    def get_barrier_gate_dict(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_barrier_gate_dict(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_plunger_gate_dict(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_plunger_gate_dict(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_reservoir_gate_dict(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_reservoir_gate_dict(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_screening_gate_dict(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_screening_gate_dict(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_dot_gate_dict(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_dot_gate_dict(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_gate_dict(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_gate_dict(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_isolated_barrier_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_barrier_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_plunger_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_plunger_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_reservoir_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_reservoir_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_screening_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_screening_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_dot_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_dot_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_barrier_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_barrier_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_plunger_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_plunger_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_reservoir_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_reservoir_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_screening_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_screening_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_dot_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_dot_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_channel_barrier_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_channel_barrier_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_channel_plunger_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_channel_plunger_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_channel_reservoir_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_channel_reservoir_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_channel_screening_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_channel_screening_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_channel_dot_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_channel_dot_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_shared_channel_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_shared_channel_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_channel_barrier_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_channel_barrier_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_channel_plunger_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_channel_plunger_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_channel_reservoir_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_channel_reservoir_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_channel_screening_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_channel_screening_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_channel_dot_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_channel_dot_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_channel_gates(self, channel):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_channel_gates(self.handle, <c_api.ChannelHandle>channel.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_isolated_barrier_gates_by_channel(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_barrier_gates_by_channel(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_isolated_plunger_gates_by_channel(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_plunger_gates_by_channel(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_isolated_reservoir_gates_by_channel(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_reservoir_gates_by_channel(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_isolated_screening_gates_by_channel(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_screening_gates_by_channel(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_isolated_dot_gates_by_channel(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_dot_gates_by_channel(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def get_isolated_gates_by_channel(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapChannelConnectionsHandle h_ret
        h_ret = c_api.Config_get_isolated_gates_by_channel(self.handle)
        if h_ret == <c_api.MapChannelConnectionsHandle>0:
            return None
        return MapChannelConnections.from_capi(MapChannelConnections, h_ret)

    def generate_gate_relations(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.GateRelationsHandle h_ret
        h_ret = c_api.Config_generate_gate_relations(self.handle)
        if h_ret == <c_api.GateRelationsHandle>0:
            return None
        return GateRelations.from_capi(GateRelations, h_ret)

    def screening_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_screening_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def reservoir_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_reservoir_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def plunger_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_plunger_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def barrier_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_barrier_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def ohmics(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_ohmics(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def dot_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_dot_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_ohmic(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Config_get_ohmic(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_barrier_gate(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Config_get_barrier_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_plunger_gate(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Config_get_plunger_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_reservoir_gate(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Config_get_reservoir_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_screening_gate(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Config_get_screening_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_dot_gate(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Config_get_dot_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_gate(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Config_get_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_all_gates(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_all_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_all_connections(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Config_get_all_connections(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def has_ohmic(self, ohmic):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_has_ohmic(self.handle, <c_api.ConnectionHandle>ohmic.handle)

    def has_gate(self, gate):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_has_gate(self.handle, <c_api.ConnectionHandle>gate.handle)

    def has_barrier_gate(self, barrier_gate):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_has_barrier_gate(self.handle, <c_api.ConnectionHandle>barrier_gate.handle)

    def has_plunger_gate(self, plunger_gate):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_has_plunger_gate(self.handle, <c_api.ConnectionHandle>plunger_gate.handle)

    def has_reservoir_gate(self, reservoir_gate):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_has_reservoir_gate(self.handle, <c_api.ConnectionHandle>reservoir_gate.handle)

    def has_screening_gate(self, screening_gate):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_has_screening_gate(self.handle, <c_api.ConnectionHandle>screening_gate.handle)

    def equal(self, other):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_equal(self.handle, <c_api.ConfigHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Config_not_equal(self.handle, <c_api.ConfigHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.ConfigHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Config_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Config _config_from_capi(c_api.ConfigHandle h):
    cdef Config obj = <Config>Config.__new__(Config)
    obj.handle = h