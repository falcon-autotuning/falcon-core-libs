# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .list_double cimport ListDouble
from .list_pair_string_double cimport ListPairStringDouble
from .list_string cimport ListString
from .pair_string_double cimport PairStringDouble

cdef class MapStringDouble:
    cdef c_api.MapStringDoubleHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapStringDoubleHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapStringDoubleHandle>0 and self.owned:
            c_api.MapStringDouble_destroy(self.handle)
        self.handle = <c_api.MapStringDoubleHandle>0

    cdef MapStringDouble from_capi(cls, c_api.MapStringDoubleHandle h):
        cdef MapStringDouble obj = <MapStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapStringDoubleHandle h
        h = c_api.MapStringDouble_create_empty()
        if h == <c_api.MapStringDoubleHandle>0:
            raise MemoryError("Failed to create MapStringDouble")
        cdef MapStringDouble obj = <MapStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapStringDoubleHandle h
        h = c_api.MapStringDouble_create(<c_api.PairStringDoubleHandle>data.handle, count)
        if h == <c_api.MapStringDoubleHandle>0:
            raise MemoryError("Failed to create MapStringDouble")
        cdef MapStringDouble obj = <MapStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapStringDoubleHandle h
        try:
            h = c_api.MapStringDouble_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapStringDoubleHandle>0:
            raise MemoryError("Failed to create MapStringDouble")
        cdef MapStringDouble obj = <MapStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        try:
            c_api.MapStringDouble_insert_or_assign(self.handle, s_key, value)
        finally:
            c_api.String_destroy(s_key)

    def insert(self, key, value):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        try:
            c_api.MapStringDouble_insert(self.handle, s_key, value)
        finally:
            c_api.String_destroy(s_key)

    def at(self, key):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        cdef double ret_val
        try:
            ret_val = c_api.MapStringDouble_at(self.handle, s_key)
        finally:
            c_api.String_destroy(s_key)
        return ret_val

    def erase(self, key):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        try:
            c_api.MapStringDouble_erase(self.handle, s_key)
        finally:
            c_api.String_destroy(s_key)

    def size(self):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringDouble_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringDouble_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapStringDouble_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        cdef bool ret_val
        try:
            ret_val = c_api.MapStringDouble_contains(self.handle, s_key)
        finally:
            c_api.String_destroy(s_key)
        return ret_val

    def keys(self):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.MapStringDouble_keys(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def values(self):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListDoubleHandle h_ret
        h_ret = c_api.MapStringDouble_values(self.handle)
        if h_ret == <c_api.ListDoubleHandle>0:
            return None
        return ListDouble.from_capi(ListDouble, h_ret)

    def items(self):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairStringDoubleHandle h_ret
        h_ret = c_api.MapStringDouble_items(self.handle)
        if h_ret == <c_api.ListPairStringDoubleHandle>0:
            return None
        return ListPairStringDouble.from_capi(ListPairStringDouble, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringDouble_equal(self.handle, <c_api.MapStringDoubleHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringDouble_not_equal(self.handle, <c_api.MapStringDoubleHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapStringDouble_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapStringDouble _mapstringdouble_from_capi(c_api.MapStringDoubleHandle h):
    cdef MapStringDouble obj = <MapStringDouble>MapStringDouble.__new__(MapStringDouble)
    obj.handle = h