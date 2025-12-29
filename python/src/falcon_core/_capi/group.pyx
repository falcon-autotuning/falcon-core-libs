cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .channel cimport Channel, _channel_from_capi
from .connection cimport Connection, _connection_from_capi
from .connections cimport Connections, _connections_from_capi
from .gate_geometry_array1_d cimport GateGeometryArray1D, _gate_geometry_array1_d_from_capi

cdef class Group:
    def __cinit__(self):
        self.handle = <_c_api.GroupHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.GroupHandle>0 and self.owned:
            _c_api.Group_destroy(self.handle)
        self.handle = <_c_api.GroupHandle>0


    @classmethod
    def new(cls, Channel name, int num_dots, Connections screening_gates, Connections reservoir_gates, Connections plunger_gates, Connections barrier_gates, Connections order):
        cdef _c_api.GroupHandle h
        h = _c_api.Group_create(name.handle if name is not None else <_c_api.ChannelHandle>0, num_dots, screening_gates.handle if screening_gates is not None else <_c_api.ConnectionsHandle>0, reservoir_gates.handle if reservoir_gates is not None else <_c_api.ConnectionsHandle>0, plunger_gates.handle if plunger_gates is not None else <_c_api.ConnectionsHandle>0, barrier_gates.handle if barrier_gates is not None else <_c_api.ConnectionsHandle>0, order.handle if order is not None else <_c_api.ConnectionsHandle>0)
        if h == <_c_api.GroupHandle>0:
            raise MemoryError("Failed to create Group")
        cdef Group obj = <Group>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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
        return _channel_from_capi(h_ret)

    def num_dots(self, ):
        return _c_api.Group_num_dots(self.handle)

    def order(self, ):
        cdef _c_api.GateGeometryArray1DHandle h_ret = _c_api.Group_order(self.handle)
        if h_ret == <_c_api.GateGeometryArray1DHandle>0:
            return None
        return _gate_geometry_array1_d_from_capi(h_ret)

    def has_channel(self, Channel channel):
        return _c_api.Group_has_channel(self.handle, channel.handle if channel is not None else <_c_api.ChannelHandle>0)

    def is_charge_sensor(self, ):
        return _c_api.Group_is_charge_sensor(self.handle)

    def get_all_channel_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_get_all_channel_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def reservoir_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_reservoir_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def plunger_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_plunger_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def barrier_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_barrier_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def ohmics(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_ohmics(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def dot_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_dot_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def get_ohmic(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_ohmic(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_barrier_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_barrier_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_plunger_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_plunger_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_reservoir_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_reservoir_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_screening_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_screening_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_dot_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_dot_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_gate(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Group_get_gate(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def get_all_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_get_all_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def get_all_connections(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Group_get_all_connections(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def has_ohmic(self, Connection ohmic):
        return _c_api.Group_has_ohmic(self.handle, ohmic.handle if ohmic is not None else <_c_api.ConnectionHandle>0)

    def has_gate(self, Connection gate):
        return _c_api.Group_has_gate(self.handle, gate.handle if gate is not None else <_c_api.ConnectionHandle>0)

    def has_barrier_gate(self, Connection barrier_gate):
        return _c_api.Group_has_barrier_gate(self.handle, barrier_gate.handle if barrier_gate is not None else <_c_api.ConnectionHandle>0)

    def has_plunger_gate(self, Connection plunger_gate):
        return _c_api.Group_has_plunger_gate(self.handle, plunger_gate.handle if plunger_gate is not None else <_c_api.ConnectionHandle>0)

    def has_reservoir_gate(self, Connection reservoir_gate):
        return _c_api.Group_has_reservoir_gate(self.handle, reservoir_gate.handle if reservoir_gate is not None else <_c_api.ConnectionHandle>0)

    def has_screening_gate(self, Connection screening_gate):
        return _c_api.Group_has_screening_gate(self.handle, screening_gate.handle if screening_gate is not None else <_c_api.ConnectionHandle>0)

    def equal(self, Group other):
        return _c_api.Group_equal(self.handle, other.handle if other is not None else <_c_api.GroupHandle>0)

    def __eq__(self, Group other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Group other):
        return _c_api.Group_not_equal(self.handle, other.handle if other is not None else <_c_api.GroupHandle>0)

    def __ne__(self, Group other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Group_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef Group _group_from_capi(_c_api.GroupHandle h, bint owned=True):
    if h == <_c_api.GroupHandle>0:
        return None
    cdef Group obj = Group.__new__(Group)
    obj.handle = h
    obj.owned = owned
    return obj
