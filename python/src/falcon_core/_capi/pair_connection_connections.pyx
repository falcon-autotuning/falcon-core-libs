cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport connections

cdef class PairConnectionConnections:
    def __cinit__(self):
        self.handle = <_c_api.PairConnectionConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairConnectionConnectionsHandle>0 and self.owned:
            _c_api.PairConnectionConnections_destroy(self.handle)
        self.handle = <_c_api.PairConnectionConnectionsHandle>0


cdef PairConnectionConnections _pair_connection_connections_from_capi(_c_api.PairConnectionConnectionsHandle h):
    if h == <_c_api.PairConnectionConnectionsHandle>0:
        return None
    cdef PairConnectionConnections obj = PairConnectionConnections.__new__(PairConnectionConnections)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, Connection first, Connections second):
        cdef _c_api.PairConnectionConnectionsHandle h
        h = _c_api.PairConnectionConnections_create(first.handle, second.handle)
        if h == <_c_api.PairConnectionConnectionsHandle>0:
            raise MemoryError("Failed to create PairConnectionConnections")
        cdef PairConnectionConnections obj = <PairConnectionConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def first(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.PairConnectionConnections_first(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.PairConnectionConnections_second(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def equal(self, PairConnectionConnections b):
        return _c_api.PairConnectionConnections_equal(self.handle, b.handle)

    def __eq__(self, PairConnectionConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairConnectionConnections b):
        return _c_api.PairConnectionConnections_not_equal(self.handle, b.handle)

    def __ne__(self, PairConnectionConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
