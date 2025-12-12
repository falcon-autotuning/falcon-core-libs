cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport channel
from . cimport channels
from . cimport connection
from . cimport connections
from . cimport gate_relations
from . cimport gname
from . cimport group
from . cimport impedance
from . cimport impedances
from . cimport list_gname
from . cimport list_group
from . cimport map_channel_connections
from . cimport map_gname_group
from . cimport pair_connection_connection
from . cimport voltage_constraints

cdef class Config:
    def __cinit__(self):
        self.handle = <_c_api.ConfigHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ConfigHandle>0 and self.owned:
            _c_api.Config_destroy(self.handle)
        self.handle = <_c_api.ConfigHandle>0


cdef Config _config_from_capi(_c_api.ConfigHandle h):
    if h == <_c_api.ConfigHandle>0:
        return None
    cdef Config obj = Config.__new__(Config)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, Connections screening_gates, Connections plunger_gates, Connections ohmics, Connections barrier_gates, Connections reservoir_gates, MapGnameGroup groups, Impedances wiring_DC, VoltageConstraints constraints):
        cdef _c_api.ConfigHandle h
        h = _c_api.Config_create(screening_gates.handle, plunger_gates.handle, ohmics.handle, barrier_gates.handle, reservoir_gates.handle, groups.handle, wiring_DC.handle, constraints.handle)
        if h == <_c_api.ConfigHandle>0:
            raise MemoryError("Failed to create Config")
        cdef Config obj = <Config>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def num_unique_channels(self, ):
        return _c_api.Config_num_unique_channels(self.handle)

    def voltage_constraints(self, ):
        cdef _c_api.VoltageConstraintsHandle h_ret = _c_api.Config_voltage_constraints(self.handle)
        if h_ret == <_c_api.VoltageConstraintsHandle>0:
            return None
        return voltage_constraints._voltage_constraints_from_capi(h_ret)

    def groups(self, ):
        cdef _c_api.MapGnameGroupHandle h_ret = _c_api.Config_groups(self.handle)
        if h_ret == <_c_api.MapGnameGroupHandle>0:
            return None
        return map_gname_group._map_gname_group_from_capi(h_ret)

    def wiring_DC(self, ):
        cdef _c_api.ImpedancesHandle h_ret = _c_api.Config_wiring_DC(self.handle)
        if h_ret == <_c_api.ImpedancesHandle>0:
            return None
        return impedances._impedances_from_capi(h_ret)

    def channels(self, ):
        cdef _c_api.ChannelsHandle h_ret = _c_api.Config_channels(self.handle)
        if h_ret == <_c_api.ChannelsHandle>0:
            return None
        return channels._channels_from_capi(h_ret)

    def get_impedance(self, Connection connection):
        cdef _c_api.ImpedanceHandle h_ret = _c_api.Config_get_impedance(self.handle, connection.handle)
        if h_ret == <_c_api.ImpedanceHandle>0:
            return None
        return impedance._impedance_from_capi(h_ret)

    def get_all_gnames(self, ):
        cdef _c_api.ListGnameHandle h_ret = _c_api.Config_get_all_gnames(self.handle)
        if h_ret == <_c_api.ListGnameHandle>0:
            return None
        return list_gname._list_gname_from_capi(h_ret)

    def get_all_groups(self, ):
        cdef _c_api.ListGroupHandle h_ret = _c_api.Config_get_all_groups(self.handle)
        if h_ret == <_c_api.ListGroupHandle>0:
            return None
        return list_group._list_group_from_capi(h_ret)

    def has_channel(self, Channel channel):
        return _c_api.Config_has_channel(self.handle, channel.handle)

    def has_gname(self, Gname gname):
        return _c_api.Config_has_gname(self.handle, gname.handle)

    def select_group(self, Gname gname):
        cdef _c_api.GroupHandle h_ret = _c_api.Config_select_group(self.handle, gname.handle)
        if h_ret == <_c_api.GroupHandle>0:
            return None
        return group._group_from_capi(h_ret)

    def get_dot_number(self, Channel channel):
        return _c_api.Config_get_dot_number(self.handle, channel.handle)

    def get_charge_sense_groups(self, ):
        cdef _c_api.ListGnameHandle h_ret = _c_api.Config_get_charge_sense_groups(self.handle)
        if h_ret == <_c_api.ListGnameHandle>0:
            return None
        return list_gname._list_gname_from_capi(h_ret)

    def ohmic_in_charge_sensor(self, Connection ohmic):
        return _c_api.Config_ohmic_in_charge_sensor(self.handle, ohmic.handle)

    def get_associated_ohmic(self, Connection reservoir_gate):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_associated_ohmic(self.handle, reservoir_gate.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_current_channels(self, ):
        cdef _c_api.ChannelsHandle h_ret = _c_api.Config_get_current_channels(self.handle)
        if h_ret == <_c_api.ChannelsHandle>0:
            return None
        return channels._channels_from_capi(h_ret)

    def get_gname(self, Channel channel):
        cdef _c_api.GnameHandle h_ret = _c_api.Config_get_gname(self.handle, channel.handle)
        if h_ret == <_c_api.GnameHandle>0:
            return None
        return gname._gname_from_capi(h_ret)

    def get_group_barrier_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_barrier_gates(self.handle, gname.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_group_plunger_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_plunger_gates(self.handle, gname.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_group_reservoir_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_reservoir_gates(self.handle, gname.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_group_screening_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_screening_gates(self.handle, gname.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_group_dot_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_dot_gates(self.handle, gname.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_group_gates(self, Gname gname):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_group_gates(self.handle, gname.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_channel_barrier_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_barrier_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_channel_plunger_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_plunger_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_channel_reservoir_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_reservoir_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_channel_screening_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_screening_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_channel_dot_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_dot_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_channel_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_channel_ohmics(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_ohmics(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_channel_order_no_ohmics(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_channel_order_no_ohmics(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_num_unique_channels(self, ):
        return _c_api.Config_get_num_unique_channels(self.handle)

    def return_channels_from_gate(self, Connection gate):
        cdef _c_api.ChannelsHandle h_ret = _c_api.Config_return_channels_from_gate(self.handle, gate.handle)
        if h_ret == <_c_api.ChannelsHandle>0:
            return None
        return channels._channels_from_capi(h_ret)

    def return_channel_from_gate(self, Connection gate):
        cdef _c_api.ChannelHandle h_ret = _c_api.Config_return_channel_from_gate(self.handle, gate.handle)
        if h_ret == <_c_api.ChannelHandle>0:
            return None
        return channel._channel_from_capi(h_ret)

    def ohmic_in_channel(self, Connection ohmic, Channel channel):
        return _c_api.Config_ohmic_in_channel(self.handle, ohmic.handle, channel.handle)

    def get_dot_channel_neighbors(self, Connection dot_gate):
        cdef _c_api.PairConnectionConnectionHandle h_ret = _c_api.Config_get_dot_channel_neighbors(self.handle, dot_gate.handle)
        if h_ret == <_c_api.PairConnectionConnectionHandle>0:
            return None
        return pair_connection_connection._pair_connection_connection_from_capi(h_ret)

    def get_barrier_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_barrier_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_plunger_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_plunger_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_reservoir_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_reservoir_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_screening_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_screening_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_dot_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_dot_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_gate_dict(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_gate_dict(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_isolated_barrier_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_barrier_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_plunger_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_plunger_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_reservoir_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_reservoir_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_dot_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_dot_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_barrier_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_barrier_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_plunger_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_plunger_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_reservoir_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_reservoir_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_dot_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_dot_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_channel_barrier_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_barrier_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_channel_plunger_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_plunger_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_channel_reservoir_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_reservoir_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_channel_screening_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_screening_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_channel_dot_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_dot_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_shared_channel_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_shared_channel_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_channel_barrier_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_barrier_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_channel_plunger_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_plunger_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_channel_reservoir_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_reservoir_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_channel_screening_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_screening_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_channel_dot_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_dot_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_channel_gates(self, Channel channel):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_isolated_channel_gates(self.handle, channel.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_isolated_barrier_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_barrier_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_isolated_plunger_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_plunger_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_isolated_reservoir_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_reservoir_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_isolated_screening_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_screening_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_isolated_dot_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_dot_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def get_isolated_gates_by_channel(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.Config_get_isolated_gates_by_channel(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return map_channel_connections._map_channel_connections_from_capi(h_ret)

    def generate_gate_relations(self, ):
        cdef _c_api.GateRelationsHandle h_ret = _c_api.Config_generate_gate_relations(self.handle)
        if h_ret == <_c_api.GateRelationsHandle>0:
            return None
        return gate_relations._gate_relations_from_capi(h_ret)

    def screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def reservoir_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_reservoir_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def plunger_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_plunger_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def barrier_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_barrier_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def ohmics(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_ohmics(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def dot_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_dot_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_ohmic(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_ohmic(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_barrier_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_barrier_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_plunger_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_plunger_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_reservoir_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_reservoir_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_screening_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_screening_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_dot_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_dot_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Config_get_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_all_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_all_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_all_connections(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Config_get_all_connections(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def has_ohmic(self, Connection ohmic):
        return _c_api.Config_has_ohmic(self.handle, ohmic.handle)

    def has_gate(self, Connection gate):
        return _c_api.Config_has_gate(self.handle, gate.handle)

    def has_barrier_gate(self, Connection barrier_gate):
        return _c_api.Config_has_barrier_gate(self.handle, barrier_gate.handle)

    def has_plunger_gate(self, Connection plunger_gate):
        return _c_api.Config_has_plunger_gate(self.handle, plunger_gate.handle)

    def has_reservoir_gate(self, Connection reservoir_gate):
        return _c_api.Config_has_reservoir_gate(self.handle, reservoir_gate.handle)

    def has_screening_gate(self, Connection screening_gate):
        return _c_api.Config_has_screening_gate(self.handle, screening_gate.handle)

    def equal(self, Config other):
        return _c_api.Config_equal(self.handle, other.handle)

    def __eq__(self, Config other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Config other):
        return _c_api.Config_not_equal(self.handle, other.handle)

    def __ne__(self, Config other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
