# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .list_float cimport ListFloat
from .list_pair_float_float cimport ListPairFloatFloat
from .pair_float_float cimport PairFloatFloat

cdef class MapFloatFloat:
    cdef c_api.MapFloatFloatHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapFloatFloatHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapFloatFloatHandle>0 and self.owned:
            c_api.MapFloatFloat_destroy(self.handle)
        self.handle = <c_api.MapFloatFloatHandle>0

    cdef MapFloatFloat from_capi(cls, c_api.MapFloatFloatHandle h):
        cdef MapFloatFloat obj = <MapFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapFloatFloatHandle h
        h = c_api.MapFloatFloat_create_empty()
        if h == <c_api.MapFloatFloatHandle>0:
            raise MemoryError("Failed to create MapFloatFloat")
        cdef MapFloatFloat obj = <MapFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapFloatFloatHandle h
        h = c_api.MapFloatFloat_create(<c_api.PairFloatFloatHandle>data.handle, count)
        if h == <c_api.MapFloatFloatHandle>0:
            raise MemoryError("Failed to create MapFloatFloat")
        cdef MapFloatFloat obj = <MapFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapFloatFloatHandle h
        try:
            h = c_api.MapFloatFloat_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapFloatFloatHandle>0:
            raise MemoryError("Failed to create MapFloatFloat")
        cdef MapFloatFloat obj = <MapFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapFloatFloat_insert_or_assign(self.handle, key, value)

    def insert(self, key, value):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapFloatFloat_insert(self.handle, key, value)

    def at(self, key):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapFloatFloat_at(self.handle, key)

    def erase(self, key):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapFloatFloat_erase(self.handle, key)

    def size(self):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapFloatFloat_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapFloatFloat_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapFloatFloat_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapFloatFloat_contains(self.handle, key)

    def keys(self):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListFloatHandle h_ret
        h_ret = c_api.MapFloatFloat_keys(self.handle)
        if h_ret == <c_api.ListFloatHandle>0:
            return None
        return ListFloat.from_capi(ListFloat, h_ret)

    def values(self):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListFloatHandle h_ret
        h_ret = c_api.MapFloatFloat_values(self.handle)
        if h_ret == <c_api.ListFloatHandle>0:
            return None
        return ListFloat.from_capi(ListFloat, h_ret)

    def items(self):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairFloatFloatHandle h_ret
        h_ret = c_api.MapFloatFloat_items(self.handle)
        if h_ret == <c_api.ListPairFloatFloatHandle>0:
            return None
        return ListPairFloatFloat.from_capi(ListPairFloatFloat, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapFloatFloat_equal(self.handle, <c_api.MapFloatFloatHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapFloatFloat_not_equal(self.handle, <c_api.MapFloatFloatHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapFloatFloatHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapFloatFloat_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapFloatFloat _mapfloatfloat_from_capi(c_api.MapFloatFloatHandle h):
    cdef MapFloatFloat obj = <MapFloatFloat>MapFloatFloat.__new__(MapFloatFloat)
    obj.handle = h