cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection

cdef class PairConnectionConnection:
    def __cinit__(self):
        self.handle = <_c_api.PairConnectionConnectionHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairConnectionConnectionHandle>0 and self.owned:
            _c_api.PairConnectionConnection_destroy(self.handle)
        self.handle = <_c_api.PairConnectionConnectionHandle>0


cdef PairConnectionConnection _pair_connection_connection_from_capi(_c_api.PairConnectionConnectionHandle h):
    if h == <_c_api.PairConnectionConnectionHandle>0:
        return None
    cdef PairConnectionConnection obj = PairConnectionConnection.__new__(PairConnectionConnection)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, Connection first, Connection second):
        cdef _c_api.PairConnectionConnectionHandle h
        h = _c_api.PairConnectionConnection_create(first.handle, second.handle)
        if h == <_c_api.PairConnectionConnectionHandle>0:
            raise MemoryError("Failed to create PairConnectionConnection")
        cdef PairConnectionConnection obj = <PairConnectionConnection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairConnectionConnectionHandle h
        try:
            h = _c_api.PairConnectionConnection_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairConnectionConnectionHandle>0:
            raise MemoryError("Failed to create PairConnectionConnection")
        cdef PairConnectionConnection obj = <PairConnectionConnection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.PairConnectionConnection_first(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.PairConnectionConnection_second(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def equal(self, PairConnectionConnection b):
        return _c_api.PairConnectionConnection_equal(self.handle, b.handle)

    def __eq__(self, PairConnectionConnection b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairConnectionConnection b):
        return _c_api.PairConnectionConnection_not_equal(self.handle, b.handle)

    def __ne__(self, PairConnectionConnection b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
