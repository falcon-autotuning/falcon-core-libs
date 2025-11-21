# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .list_connection cimport ListConnection
from .list_float cimport ListFloat
from .list_pair_connection_float cimport ListPairConnectionFloat
from .pair_connection_float cimport PairConnectionFloat

cdef class MapConnectionFloat:
    cdef c_api.MapConnectionFloatHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapConnectionFloatHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapConnectionFloatHandle>0 and self.owned:
            c_api.MapConnectionFloat_destroy(self.handle)
        self.handle = <c_api.MapConnectionFloatHandle>0

    cdef MapConnectionFloat from_capi(cls, c_api.MapConnectionFloatHandle h):
        cdef MapConnectionFloat obj = <MapConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapConnectionFloatHandle h
        h = c_api.MapConnectionFloat_create_empty()
        if h == <c_api.MapConnectionFloatHandle>0:
            raise MemoryError("Failed to create MapConnectionFloat")
        cdef MapConnectionFloat obj = <MapConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapConnectionFloatHandle h
        h = c_api.MapConnectionFloat_create(<c_api.PairConnectionFloatHandle>data.handle, count)
        if h == <c_api.MapConnectionFloatHandle>0:
            raise MemoryError("Failed to create MapConnectionFloat")
        cdef MapConnectionFloat obj = <MapConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapConnectionFloatHandle h
        try:
            h = c_api.MapConnectionFloat_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapConnectionFloatHandle>0:
            raise MemoryError("Failed to create MapConnectionFloat")
        cdef MapConnectionFloat obj = <MapConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapConnectionFloat_insert_or_assign(self.handle, <c_api.ConnectionHandle>key.handle, value)

    def insert(self, key, value):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapConnectionFloat_insert(self.handle, <c_api.ConnectionHandle>key.handle, value)

    def at(self, key):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionFloat_at(self.handle, <c_api.ConnectionHandle>key.handle)

    def erase(self, key):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapConnectionFloat_erase(self.handle, <c_api.ConnectionHandle>key.handle)

    def size(self):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionFloat_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionFloat_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapConnectionFloat_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionFloat_contains(self.handle, <c_api.ConnectionHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionHandle h_ret
        h_ret = c_api.MapConnectionFloat_keys(self.handle)
        if h_ret == <c_api.ListConnectionHandle>0:
            return None
        return ListConnection.from_capi(ListConnection, h_ret)

    def values(self):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListFloatHandle h_ret
        h_ret = c_api.MapConnectionFloat_values(self.handle)
        if h_ret == <c_api.ListFloatHandle>0:
            return None
        return ListFloat.from_capi(ListFloat, h_ret)

    def items(self):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairConnectionFloatHandle h_ret
        h_ret = c_api.MapConnectionFloat_items(self.handle)
        if h_ret == <c_api.ListPairConnectionFloatHandle>0:
            return None
        return ListPairConnectionFloat.from_capi(ListPairConnectionFloat, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionFloat_equal(self.handle, <c_api.MapConnectionFloatHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionFloat_not_equal(self.handle, <c_api.MapConnectionFloatHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapConnectionFloatHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapConnectionFloat_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapConnectionFloat _mapconnectionfloat_from_capi(c_api.MapConnectionFloatHandle h):
    cdef MapConnectionFloat obj = <MapConnectionFloat>MapConnectionFloat.__new__(MapConnectionFloat)
    obj.handle = h