# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection

cdef class PairConnectionConnection:
    cdef c_api.PairConnectionConnectionHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairConnectionConnectionHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairConnectionConnectionHandle>0 and self.owned:
            c_api.PairConnectionConnection_destroy(self.handle)
        self.handle = <c_api.PairConnectionConnectionHandle>0

    cdef PairConnectionConnection from_capi(cls, c_api.PairConnectionConnectionHandle h):
        cdef PairConnectionConnection obj = <PairConnectionConnection>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, first, second):
        cdef c_api.PairConnectionConnectionHandle h
        h = c_api.PairConnectionConnection_create(<c_api.ConnectionHandle>first.handle, <c_api.ConnectionHandle>second.handle)
        if h == <c_api.PairConnectionConnectionHandle>0:
            raise MemoryError("Failed to create PairConnectionConnection")
        cdef PairConnectionConnection obj = <PairConnectionConnection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PairConnectionConnectionHandle h
        try:
            h = c_api.PairConnectionConnection_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PairConnectionConnectionHandle>0:
            raise MemoryError("Failed to create PairConnectionConnection")
        cdef PairConnectionConnection obj = <PairConnectionConnection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self):
        if self.handle == <c_api.PairConnectionConnectionHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.PairConnectionConnection_first(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def second(self):
        if self.handle == <c_api.PairConnectionConnectionHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.PairConnectionConnection_second(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def equal(self, b):
        if self.handle == <c_api.PairConnectionConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairConnectionConnection_equal(self.handle, <c_api.PairConnectionConnectionHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PairConnectionConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairConnectionConnection_not_equal(self.handle, <c_api.PairConnectionConnectionHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PairConnectionConnectionHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairConnectionConnection_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PairConnectionConnection _pairconnectionconnection_from_capi(c_api.PairConnectionConnectionHandle h):
    cdef PairConnectionConnection obj = <PairConnectionConnection>PairConnectionConnection.__new__(PairConnectionConnection)
    obj.handle = h