# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .list_connection cimport ListConnection
from .const _connection cimport const Connection

cdef class Connections:
    cdef c_api.ConnectionsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ConnectionsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ConnectionsHandle>0 and self.owned:
            c_api.Connections_destroy(self.handle)
        self.handle = <c_api.ConnectionsHandle>0

    cdef Connections from_capi(cls, c_api.ConnectionsHandle h):
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ConnectionsHandle h
        h = c_api.Connections_create_empty()
        if h == <c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, items):
        cdef c_api.ConnectionsHandle h
        h = c_api.Connections_create(<c_api.ListConnectionHandle>items.handle)
        if h == <c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ConnectionsHandle h
        try:
            h = c_api.Connections_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def is_gates(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_is_gates(self.handle)

    def is_ohmics(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_is_ohmics(self.handle)

    def is_dot_gates(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_is_dot_gates(self.handle)

    def is_plunger_gates(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_is_plunger_gates(self.handle)

    def is_barrier_gates(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_is_barrier_gates(self.handle)

    def is_reservoir_gates(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_is_reservoir_gates(self.handle)

    def is_screening_gates(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_is_screening_gates(self.handle)

    def intersection(self, other):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Connections_intersection(self.handle, <c_api.ConnectionsHandle>other.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Connections_push_back(self.handle, <c_api.ConnectionHandle>value.handle)

    def size(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Connections_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Connections_clear(self.handle)

    def const_at(self, idx):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.const ConnectionHandle h_ret
        h_ret = c_api.Connections_const_at(self.handle, idx)
        if h_ret == <c_api.const ConnectionHandle>0:
            return None
        return const Connection.from_capi(const Connection, h_ret)

    def at(self, idx):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Connections_at(self.handle, idx)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def items(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionHandle h_ret
        h_ret = c_api.Connections_items(self.handle)
        if h_ret == <c_api.ListConnectionHandle>0:
            return None
        return ListConnection.from_capi(ListConnection, h_ret)

    def contains(self, value):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_contains(self.handle, <c_api.ConnectionHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_index(self.handle, <c_api.ConnectionHandle>value.handle)

    def equal(self, b):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_equal(self.handle, <c_api.ConnectionsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connections_not_equal(self.handle, <c_api.ConnectionsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Connections_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Connections _connections_from_capi(c_api.ConnectionsHandle h):
    cdef Connections obj = <Connections>Connections.__new__(Connections)
    obj.handle = h