cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport list_connection

cdef class Connections:
    def __cinit__(self):
        self.handle = <_c_api.ConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ConnectionsHandle>0 and self.owned:
            _c_api.Connections_destroy(self.handle)
        self.handle = <_c_api.ConnectionsHandle>0


cdef Connections _connections_from_capi(_c_api.ConnectionsHandle h):
    if h == <_c_api.ConnectionsHandle>0:
        return None
    cdef Connections obj = Connections.__new__(Connections)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ConnectionsHandle h
        h = _c_api.Connections_create_empty()
        if h == <_c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListConnection items):
        cdef _c_api.ConnectionsHandle h
        h = _c_api.Connections_create(items.handle)
        if h == <_c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ConnectionsHandle h
        try:
            h = _c_api.Connections_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def is_gates(self, ):
        return _c_api.Connections_is_gates(self.handle)

    def is_ohmics(self, ):
        return _c_api.Connections_is_ohmics(self.handle)

    def is_dot_gates(self, ):
        return _c_api.Connections_is_dot_gates(self.handle)

    def is_plunger_gates(self, ):
        return _c_api.Connections_is_plunger_gates(self.handle)

    def is_barrier_gates(self, ):
        return _c_api.Connections_is_barrier_gates(self.handle)

    def is_reservoir_gates(self, ):
        return _c_api.Connections_is_reservoir_gates(self.handle)

    def is_screening_gates(self, ):
        return _c_api.Connections_is_screening_gates(self.handle)

    def intersection(self, Connections other):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Connections_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def push_back(self, Connection value):
        _c_api.Connections_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.Connections_size(self.handle)

    def empty(self, ):
        return _c_api.Connections_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.Connections_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.Connections_clear(self.handle)

    def const_at(self, size_t idx):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Connections_const_at(self.handle, idx)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def at(self, size_t idx):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Connections_at(self.handle, idx)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.Connections_items(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return list_connection._list_connection_from_capi(h_ret)

    def contains(self, Connection value):
        return _c_api.Connections_contains(self.handle, value.handle)

    def index(self, Connection value):
        return _c_api.Connections_index(self.handle, value.handle)

    def equal(self, Connections b):
        return _c_api.Connections_equal(self.handle, b.handle)

    def __eq__(self, Connections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Connections b):
        return _c_api.Connections_not_equal(self.handle, b.handle)

    def __ne__(self, Connections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
