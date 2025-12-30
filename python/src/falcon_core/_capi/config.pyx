cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .channel cimport Channel, _channel_from_capi
from .channels cimport Channels, _channels_from_capi
from .connection cimport Connection, _connection_from_capi
from .connections cimport Connections, _connections_from_capi
from .gate_relations cimport GateRelations, _gate_relations_from_capi
from .gname cimport Gname, _gname_from_capi
from .group cimport Group, _group_from_capi
from .impedance cimport Impedance, _impedance_from_capi
from .impedances cimport Impedances, _impedances_from_capi
from .list_gname cimport ListGname, _list_gname_from_capi
from .list_group cimport ListGroup, _list_group_from_capi
from .map_channel_connections cimport MapChannelConnections, _map_channel_connections_from_capi
from .map_gname_group cimport MapGnameGroup, _map_gname_group_from_capi
from .pair_connection_connection cimport PairConnectionConnection, _pair_connection_connection_from_capi
from .voltage_constraints cimport VoltageConstraints, _voltage_constraints_from_capi

cdef class Config:
    def __cinit__(self):
        self.handle = <_c_api.ConfigHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ConfigHandle>0 and self.owned:
            _c_api.Config_destroy(self.handle)
        self.handle = <_c_api.ConfigHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ConfigHandle h
        try:
            h = _c_api.Config_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ConfigHandle>0:
            raise MemoryError("Failed to create Config")
        cdef Config obj = <Config>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, Connections screening_gates, Connections plunger_gates, Connections ohmics, Connections barrier_gates, Connections reservoir_gates, MapGnameGroup groups, Impedances wiring_DC, VoltageConstraints constraints):
        cdef _c_api.ConfigHandle h
        h = _c_api.Config_create(screening_gates.handle if screening_gates is not None else <_c_api.ConnectionsHandle>0, plunger_gates.handle if plunger_gates is not None else <_c_api.ConnectionsHandle>0, ohmics.handle if ohmics is not None else <_c_api.ConnectionsHandle>0, barrier_gates.handle if barrier_gates is not None else <_c_api.ConnectionsHandle>0, reservoir_gates.handle if reservoir_gates is not None else <_c_api.ConnectionsHandle>0, groups.handle if groups is not None else <_c_api.MapGnameGroupHandle>0, wiring_DC.handle if wiring_DC is not None else <_c_api.ImpedancesHandle>0, constraints.handle if constraints is not None else <_c_api.VoltageConstraintsHandle>0)
        if h == <_c_api.ConfigHandle>0:
            raise MemoryError("Failed to create Config")
        cdef Config obj = <Config>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.ConfigHandle h_ret = _c_api.Config_copy(self.handle)
        if h_ret == <_c_api.ConfigHandle>0:
            return None
        return _config_from_capi(h_ret)

    def equal(self, Config other):
        return _c_api.Config_equal(self.handle, other.handle if other is not None else <_c_api.ConfigHandle>0)

    def __eq__(self, Config other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Config other):
        return _c_api.Config_not_equal(self.handle, other.handle if other is not None else <_c_api.ConfigHandle>0)

    def __ne__(self, Config other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Config_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def num_unique_channels(self, ):
        return _c_api.Config_num_unique_channels(self.handle)

    def voltage_constraints(self, ):
        cdef _c_api.VoltageConstraintsHandle h_ret = _c_api.Config_voltage_constraints(self.handle)
        if h_ret == <_c_api.VoltageConstraintsHandle>0:
            return None
        return _voltage_constraints_from_capi(h_ret)

    def groups(self, ):
        cdef _c_api.MapGnameGroupHandle h_ret = _c_api.Config_groups(self.handle)
        if h_ret == <_c_api.MapGnameGroupHandle>0:
            return None
        return _map_gname_group_from_capi(h_ret)

    def wiring_DC(self, ):
        cdef _c_api.ImpedancesHandle h_ret = _c_api.Config_wiring_DC(self.handle)
        if h_ret == <_c_api.ImpedancesHandle>0:
            return None
        return _impedances_from_capi(h_ret)

    def channels(self, ):
        cdef _c_api.ChannelsHandle h_ret = _c_api.Config_channels(self.handle)
        if h_ret == <_c_api.ChannelsHandle>0:
            return None
        return _channels_from_capi(h_ret)

    def get_impedance(self, Connection connection):
        cdef _c_api.ImpedanceHandle h_ret = _c_api.Config_get_impedance(self.handle, connection.handle if connection is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.ImpedanceHandle>0:
            return None
        return _impedance_from_capi(h_ret, owned=False)

    def get_all_gnames(self, ):
        cdef _c_api.ListGnameHandle h_ret = _c_api.Config_get_all_gnames(self.handle)
        if h_ret == <_c_api.ListGnameHandle>0:
            return None
        return _list_gname_from_capi(h_ret, owned=False)

    def get_all_groups(self, ):
        cdef _c_api.ListGroupHandle h_ret = _c_api.Config_get_all_groups(self.handle)
        if h_ret == <_c_api.ListGroupHandle>0:
            return None
        return _list_group_from_capi(h_ret, owned=False)

    def has_channel(self, Channel channel):
        return _c_api.Config_has_channel(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)

    def has_gname(self, Gname gname):
        return _c_api.Config_has_gname(self.handle, gname.handle if gname is not None else <_c_api.GnameHandle>0)

    def select_group(self, Gname gname):
        cdef _c_api.GroupHandle h_ret = _c_api.Config_select_group(self.handle, gname.handle if gname is not None else <_c_api.GnameHandle>0)
        if h_ret == <_c_api.GroupHandle>0:
            return None
        return _group_from_capi(h_ret)

    def get_dot_number(self, Channel channel):
        return _c_api.Config_get_dot_number(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)

    def get_charge_sense_groups(self, ):
        cdef _c_api.ListGnameHandle h_ret = _c_api.Config_get_charge_sense_groups(self.handle)
        if h_ret == <_c_api.ListGnameHandle>0:
            return None
        return _list_gname_from_capi(h_ret, owned=False)

    def ohmic_in_charge_sensor(self, Connection ohmic):
        return _c_api.Config_ohmic_in_charge_sensor(self.handle, ohmic.handle if ohmic is not None else <_c_api.ConnectionHandle>0)

    def get_associated_ohmic(self, Connection reservoir_gate):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_associated_ohmic(self.handle, reservoir_gate.handle if reservoir_gate is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_current_channels(self, ):
        cdef _c_api.ChannelsHandle h_ret = _c_api.Config_get_current_channels(self.handle)
        if h_ret == <_c_api.ChannelsHandle>0:
            return None
        return _channels_from_capi(h_ret, owned=False)

    def get_gname(self, Channel channel):
        cdef _c_api.GnameHandle h_ret = _c_api.Config_get_gname(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.GnameHandle>0:
            return None
        return _gname_from_capi(h_ret, owned=False)

    def get_group_barrier_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_barrier_gates(self.handle, gname.handle if gname is not None else <_c_api.GnameHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_group_plunger_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_plunger_gates(self.handle, gname.handle if gname is not None else <_c_api.GnameHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_group_reservoir_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_reservoir_gates(self.handle, gname.handle if gname is not None else <_c_api.GnameHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_group_screening_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_screening_gates(self.handle, gname.handle if gname is not None else <_c_api.GnameHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_group_dot_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_dot_gates(self.handle, gname.handle if gname is not None else <_c_api.GnameHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_group_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_gates(self.handle, gname.handle if gname is not None else <_c_api.GnameHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_channel_barrier_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_barrier_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_channel_plunger_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_plunger_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_channel_reservoir_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_reservoir_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_channel_screening_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_screening_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_channel_dot_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_dot_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_channel_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_channel_ohmics(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_ohmics(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_channel_order_no_ohmics(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_order_no_ohmics(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_num_unique_channels(self, ):
        return _c_api.Config_get_num_unique_channels(self.handle)

    def return_channels_from_gate(self, Connection gate):
        cdef _c_api.ChannelsHandle h_ret = _c_api.Config_return_channels_from_gate(self.handle, gate.handle if gate is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.ChannelsHandle>0:
            return None
        return _channels_from_capi(h_ret)

    def return_channel_from_gate(self, Connection gate):
        cdef _c_api.ChannelHandle h_ret = _c_api.Config_return_channel_from_gate(self.handle, gate.handle if gate is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.ChannelHandle>0:
            return None
        return _channel_from_capi(h_ret)

    def ohmic_in_channel(self, Connection ohmic, Channel channel):
        return _c_api.Config_ohmic_in_channel(self.handle, ohmic.handle if ohmic is not None else <_c_api.ConnectionHandle>0, channel.handle if channel is not None else <_c_api.ChannelHandle>0)

    def get_dot_channel_neighbors(self, Connection dot_gate):
        cdef _c_api.PairConnectionConnectionHandle h_ret = _c_api.Config_get_dot_channel_neighbors(self.handle, dot_gate.handle if dot_gate is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.PairConnectionConnectionHandle>0:
            return None
        return _pair_connection_connection_from_capi(h_ret, owned=False)

    def get_barrier_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_barrier_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_plunger_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_plunger_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_reservoir_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_reservoir_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_screening_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_screening_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_dot_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_dot_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_isolated_barrier_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_barrier_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_plunger_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_plunger_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_reservoir_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_reservoir_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_dot_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_dot_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_barrier_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_barrier_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_plunger_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_plunger_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_reservoir_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_reservoir_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_dot_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_dot_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_channel_barrier_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_barrier_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_channel_plunger_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_plunger_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_channel_reservoir_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_reservoir_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_channel_screening_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_screening_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_channel_dot_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_dot_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_shared_channel_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_channel_barrier_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_barrier_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_channel_plunger_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_plunger_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_channel_reservoir_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_reservoir_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_channel_screening_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_screening_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_channel_dot_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_dot_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_channel_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_gates(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_isolated_barrier_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_barrier_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_isolated_plunger_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_plunger_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_isolated_reservoir_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_reservoir_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_isolated_screening_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_screening_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_isolated_dot_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_dot_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def get_isolated_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=False)

    def generate_gate_relations(self, ):
        cdef _c_api.GateRelationsHandle h_ret = _c_api.Config_generate_gate_relations(self.handle)
        if h_ret == <_c_api.GateRelationsHandle>0:
            return None
        return _gate_relations_from_capi(h_ret)

    def screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def reservoir_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_reservoir_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def plunger_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_plunger_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def barrier_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_barrier_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def ohmics(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_ohmics(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def dot_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_dot_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def get_ohmic(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_ohmic(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_barrier_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_barrier_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_plunger_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_plunger_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_reservoir_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_reservoir_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_screening_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_screening_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_dot_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_dot_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_all_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_all_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_all_connections(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_all_connections(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def has_ohmic(self, Connection ohmic):
        return _c_api.Config_has_ohmic(self.handle, ohmic.handle if ohmic is not None else <_c_api.ConnectionHandle>0)

    def has_gate(self, Connection gate):
        return _c_api.Config_has_gate(self.handle, gate.handle if gate is not None else <_c_api.ConnectionHandle>0)

    def has_barrier_gate(self, Connection barrier_gate):
        return _c_api.Config_has_barrier_gate(self.handle, barrier_gate.handle if barrier_gate is not None else <_c_api.ConnectionHandle>0)

    def has_plunger_gate(self, Connection plunger_gate):
        return _c_api.Config_has_plunger_gate(self.handle, plunger_gate.handle if plunger_gate is not None else <_c_api.ConnectionHandle>0)

    def has_reservoir_gate(self, Connection reservoir_gate):
        return _c_api.Config_has_reservoir_gate(self.handle, reservoir_gate.handle if reservoir_gate is not None else <_c_api.ConnectionHandle>0)

    def has_screening_gate(self, Connection screening_gate):
        return _c_api.Config_has_screening_gate(self.handle, screening_gate.handle if screening_gate is not None else <_c_api.ConnectionHandle>0)

cdef Config _config_from_capi(_c_api.ConfigHandle h, bint owned=True):
    if h == <_c_api.ConfigHandle>0:
        return None
    cdef Config obj = Config.__new__(Config)
    obj.handle = h
    obj.owned = owned
    return obj
