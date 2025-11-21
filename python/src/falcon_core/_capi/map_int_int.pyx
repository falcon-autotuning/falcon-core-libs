# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .list_int cimport ListInt
from .list_pair_int_int cimport ListPairIntInt
from .pair_int_int cimport PairIntInt

cdef class MapIntInt:
    cdef c_api.MapIntIntHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapIntIntHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapIntIntHandle>0 and self.owned:
            c_api.MapIntInt_destroy(self.handle)
        self.handle = <c_api.MapIntIntHandle>0

    cdef MapIntInt from_capi(cls, c_api.MapIntIntHandle h):
        cdef MapIntInt obj = <MapIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapIntIntHandle h
        h = c_api.MapIntInt_create_empty()
        if h == <c_api.MapIntIntHandle>0:
            raise MemoryError("Failed to create MapIntInt")
        cdef MapIntInt obj = <MapIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapIntIntHandle h
        h = c_api.MapIntInt_create(<c_api.PairIntIntHandle>data.handle, count)
        if h == <c_api.MapIntIntHandle>0:
            raise MemoryError("Failed to create MapIntInt")
        cdef MapIntInt obj = <MapIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapIntIntHandle h
        try:
            h = c_api.MapIntInt_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapIntIntHandle>0:
            raise MemoryError("Failed to create MapIntInt")
        cdef MapIntInt obj = <MapIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapIntInt_insert_or_assign(self.handle, key, value)

    def insert(self, key, value):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapIntInt_insert(self.handle, key, value)

    def at(self, key):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapIntInt_at(self.handle, key)

    def erase(self, key):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapIntInt_erase(self.handle, key)

    def size(self):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapIntInt_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapIntInt_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapIntInt_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapIntInt_contains(self.handle, key)

    def keys(self):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListIntHandle h_ret
        h_ret = c_api.MapIntInt_keys(self.handle)
        if h_ret == <c_api.ListIntHandle>0:
            return None
        return ListInt.from_capi(ListInt, h_ret)

    def values(self):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListIntHandle h_ret
        h_ret = c_api.MapIntInt_values(self.handle)
        if h_ret == <c_api.ListIntHandle>0:
            return None
        return ListInt.from_capi(ListInt, h_ret)

    def items(self):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairIntIntHandle h_ret
        h_ret = c_api.MapIntInt_items(self.handle)
        if h_ret == <c_api.ListPairIntIntHandle>0:
            return None
        return ListPairIntInt.from_capi(ListPairIntInt, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapIntInt_equal(self.handle, <c_api.MapIntIntHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapIntInt_not_equal(self.handle, <c_api.MapIntIntHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapIntInt_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapIntInt _mapintint_from_capi(c_api.MapIntIntHandle h):
    cdef MapIntInt obj = <MapIntInt>MapIntInt.__new__(MapIntInt)
    obj.handle = h