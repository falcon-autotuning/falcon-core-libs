# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .channel cimport Channel
from .connection cimport Connection
from .connections cimport Connections
from .gate_geometry_array1_d cimport GateGeometryArray1D

cdef class Group:
    cdef c_api.GroupHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.GroupHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.GroupHandle>0 and self.owned:
            c_api.Group_destroy(self.handle)
        self.handle = <c_api.GroupHandle>0

    cdef Group from_capi(cls, c_api.GroupHandle h):
        cdef Group obj = <Group>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, name, num_dots, screening_gates, reservoir_gates, plunger_gates, barrier_gates, order):
        cdef c_api.GroupHandle h
        h = c_api.Group_create(<c_api.ChannelHandle>name.handle, num_dots, <c_api.ConnectionsHandle>screening_gates.handle, <c_api.ConnectionsHandle>reservoir_gates.handle, <c_api.ConnectionsHandle>plunger_gates.handle, <c_api.ConnectionsHandle>barrier_gates.handle, <c_api.ConnectionsHandle>order.handle)
        if h == <c_api.GroupHandle>0:
            raise MemoryError("Failed to create Group")
        cdef Group obj = <Group>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.GroupHandle h
        try:
            h = c_api.Group_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.GroupHandle>0:
            raise MemoryError("Failed to create Group")
        cdef Group obj = <Group>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def name(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ChannelHandle h_ret
        h_ret = c_api.Group_name(self.handle)
        if h_ret == <c_api.ChannelHandle>0:
            return None
        return Channel.from_capi(Channel, h_ret)

    def num_dots(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_num_dots(self.handle)

    def order(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.GateGeometryArray1DHandle h_ret
        h_ret = c_api.Group_order(self.handle)
        if h_ret == <c_api.GateGeometryArray1DHandle>0:
            return None
        return GateGeometryArray1D.from_capi(GateGeometryArray1D, h_ret)

    def has_channel(self, channel):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_has_channel(self.handle, <c_api.ChannelHandle>channel.handle)

    def is_charge_sensor(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_is_charge_sensor(self.handle)

    def get_all_channel_gates(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Group_get_all_channel_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def screening_gates(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Group_screening_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def reservoir_gates(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Group_reservoir_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def plunger_gates(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Group_plunger_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def barrier_gates(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Group_barrier_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def ohmics(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Group_ohmics(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def dot_gates(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Group_dot_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_ohmic(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Group_get_ohmic(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_barrier_gate(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Group_get_barrier_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_plunger_gate(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Group_get_plunger_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_reservoir_gate(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Group_get_reservoir_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_screening_gate(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Group_get_screening_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_dot_gate(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Group_get_dot_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_gate(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Group_get_gate(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def get_all_gates(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Group_get_all_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_all_connections(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Group_get_all_connections(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def has_ohmic(self, ohmic):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_has_ohmic(self.handle, <c_api.ConnectionHandle>ohmic.handle)

    def has_gate(self, gate):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_has_gate(self.handle, <c_api.ConnectionHandle>gate.handle)

    def has_barrier_gate(self, barrier_gate):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_has_barrier_gate(self.handle, <c_api.ConnectionHandle>barrier_gate.handle)

    def has_plunger_gate(self, plunger_gate):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_has_plunger_gate(self.handle, <c_api.ConnectionHandle>plunger_gate.handle)

    def has_reservoir_gate(self, reservoir_gate):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_has_reservoir_gate(self.handle, <c_api.ConnectionHandle>reservoir_gate.handle)

    def has_screening_gate(self, screening_gate):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_has_screening_gate(self.handle, <c_api.ConnectionHandle>screening_gate.handle)

    def equal(self, other):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_equal(self.handle, <c_api.GroupHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Group_not_equal(self.handle, <c_api.GroupHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.GroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Group_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Group _group_from_capi(c_api.GroupHandle h):
    cdef Group obj = <Group>Group.__new__(Group)
    obj.handle = h