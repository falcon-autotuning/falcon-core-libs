cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport channel
from . cimport connection
from . cimport connections
from . cimport gate_geometry_array1_d

cdef class Group:
    def __cinit__(self):
        self.handle = <_c_api.GroupHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.GroupHandle>0 and self.owned:
            _c_api.Group_destroy(self.handle)
        self.handle = <_c_api.GroupHandle>0


cdef Group _group_from_capi(_c_api.GroupHandle h):
    if h == <_c_api.GroupHandle>0:
        return None
    cdef Group obj = Group.__new__(Group)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, Channel name, int num_dots, Connections screening_gates, Connections reservoir_gates, Connections plunger_gates, Connections barrier_gates, Connections order):
        cdef _c_api.GroupHandle h
        h = _c_api.Group_create(name.handle, num_dots, screening_gates.handle, reservoir_gates.handle, plunger_gates.handle, barrier_gates.handle, order.handle)
        if h == <_c_api.GroupHandle>0:
            raise MemoryError("Failed to create Group")
        cdef Group obj = <Group>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.GroupHandle h
        try:
            h = _c_api.Group_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.GroupHandle>0:
            raise MemoryError("Failed to create Group")
        cdef Group obj = <Group>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def name(self, ):
        cdef _c_api.ChannelHandle h_ret = _c_api.Group_name(self.handle)
        if h_ret == <_c_api.ChannelHandle>0:
            return None
        return channel._channel_from_capi(h_ret)

    def num_dots(self, ):
        return _c_api.Group_num_dots(self.handle)

    def order(self, ):
        cdef _c_api.GateGeometryArray1DHandle h_ret = _c_api.Group_order(self.handle)
        if h_ret == <_c_api.GateGeometryArray1DHandle>0:
            return None
        return gate_geometry_array1_d._gate_geometry_array1_d_from_capi(h_ret)

    def has_channel(self, Channel channel):
        return _c_api.Group_has_channel(self.handle, channel.handle)

    def is_charge_sensor(self, ):
        return _c_api.Group_is_charge_sensor(self.handle)

    def get_all_channel_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_get_all_channel_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def reservoir_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_reservoir_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def plunger_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_plunger_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def barrier_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_barrier_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def ohmics(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_ohmics(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def dot_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_dot_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_ohmic(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_ohmic(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_barrier_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_barrier_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_plunger_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_plunger_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_reservoir_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_reservoir_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_screening_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_screening_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_dot_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_dot_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def get_all_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_get_all_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_all_connections(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_get_all_connections(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def has_ohmic(self, Connection ohmic):
        return _c_api.Group_has_ohmic(self.handle, ohmic.handle)

    def has_gate(self, Connection gate):
        return _c_api.Group_has_gate(self.handle, gate.handle)

    def has_barrier_gate(self, Connection barrier_gate):
        return _c_api.Group_has_barrier_gate(self.handle, barrier_gate.handle)

    def has_plunger_gate(self, Connection plunger_gate):
        return _c_api.Group_has_plunger_gate(self.handle, plunger_gate.handle)

    def has_reservoir_gate(self, Connection reservoir_gate):
        return _c_api.Group_has_reservoir_gate(self.handle, reservoir_gate.handle)

    def has_screening_gate(self, Connection screening_gate):
        return _c_api.Group_has_screening_gate(self.handle, screening_gate.handle)

    def equal(self, Group other):
        return _c_api.Group_equal(self.handle, other.handle)

    def __eq__(self, Group other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Group other):
        return _c_api.Group_not_equal(self.handle, other.handle)

    def __ne__(self, Group other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
