cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .connections cimport Connections, _connections_from_capi

cdef class PairConnectionConnections:
    def __cinit__(self):
        self.handle = <_c_api.PairConnectionConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairConnectionConnectionsHandle>0 and self.owned:
            _c_api.PairConnectionConnections_destroy(self.handle)
        self.handle = <_c_api.PairConnectionConnectionsHandle>0


    @classmethod
    def new(cls, Connection first, Connections second):
        cdef _c_api.PairConnectionConnectionsHandle h
        h = _c_api.PairConnectionConnections_create(first.handle if first is not None else <_c_api.ConnectionHandle>0, second.handle if second is not None else <_c_api.ConnectionsHandle>0)
        if h == <_c_api.PairConnectionConnectionsHandle>0:
            raise MemoryError("Failed to create PairConnectionConnections")
        cdef PairConnectionConnections obj = <PairConnectionConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairConnectionConnectionsHandle h
        try:
            h = _c_api.PairConnectionConnections_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairConnectionConnectionsHandle>0:
            raise MemoryError("Failed to create PairConnectionConnections")
        cdef PairConnectionConnections obj = <PairConnectionConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.PairConnectionConnectionsHandle h_ret = _c_api.PairConnectionConnections_copy(self.handle)
        if h_ret == <_c_api.PairConnectionConnectionsHandle>0:
            return None
        return _pair_connection_connections_from_capi(h_ret, owned=(h_ret != <_c_api.PairConnectionConnectionsHandle>self.handle))

    def first(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.PairConnectionConnections_first(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.PairConnectionConnections_second(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def equal(self, PairConnectionConnections other):
        return _c_api.PairConnectionConnections_equal(self.handle, other.handle if other is not None else <_c_api.PairConnectionConnectionsHandle>0)

    def __eq__(self, PairConnectionConnections other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, PairConnectionConnections other):
        return _c_api.PairConnectionConnections_not_equal(self.handle, other.handle if other is not None else <_c_api.PairConnectionConnectionsHandle>0)

    def __ne__(self, PairConnectionConnections other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PairConnectionConnections_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef PairConnectionConnections _pair_connection_connections_from_capi(_c_api.PairConnectionConnectionsHandle h, bint owned=True):
    if h == <_c_api.PairConnectionConnectionsHandle>0:
        return None
    cdef PairConnectionConnections obj = PairConnectionConnections.__new__(PairConnectionConnections)
    obj.handle = h
    obj.owned = owned
    return obj
