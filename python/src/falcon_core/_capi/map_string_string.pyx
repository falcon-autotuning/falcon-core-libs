# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .list_pair_string_string cimport ListPairStringString
from .list_string cimport ListString
from .pair_string_string cimport PairStringString

cdef class MapStringString:
    cdef c_api.MapStringStringHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapStringStringHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapStringStringHandle>0 and self.owned:
            c_api.MapStringString_destroy(self.handle)
        self.handle = <c_api.MapStringStringHandle>0

    cdef MapStringString from_capi(cls, c_api.MapStringStringHandle h):
        cdef MapStringString obj = <MapStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapStringStringHandle h
        h = c_api.MapStringString_create_empty()
        if h == <c_api.MapStringStringHandle>0:
            raise MemoryError("Failed to create MapStringString")
        cdef MapStringString obj = <MapStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapStringStringHandle h
        h = c_api.MapStringString_create(<c_api.PairStringStringHandle>data.handle, count)
        if h == <c_api.MapStringStringHandle>0:
            raise MemoryError("Failed to create MapStringString")
        cdef MapStringString obj = <MapStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapStringStringHandle h
        try:
            h = c_api.MapStringString_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapStringStringHandle>0:
            raise MemoryError("Failed to create MapStringString")
        cdef MapStringString obj = <MapStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        try:
            c_api.MapStringString_insert_or_assign(self.handle, s_key, s_value)
        finally:
            c_api.String_destroy(s_key)
            c_api.String_destroy(s_value)

    def insert(self, key, value):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        try:
            c_api.MapStringString_insert(self.handle, s_key, s_value)
        finally:
            c_api.String_destroy(s_key)
            c_api.String_destroy(s_value)

    def at(self, key):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        cdef c_api.StringHandle s_ret
        try:
            s_ret = c_api.MapStringString_at(self.handle, s_key)
        finally:
            c_api.String_destroy(s_key)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def erase(self, key):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        try:
            c_api.MapStringString_erase(self.handle, s_key)
        finally:
            c_api.String_destroy(s_key)

    def size(self):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringString_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringString_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapStringString_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        cdef bool ret_val
        try:
            ret_val = c_api.MapStringString_contains(self.handle, s_key)
        finally:
            c_api.String_destroy(s_key)
        return ret_val

    def keys(self):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.MapStringString_keys(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def values(self):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.MapStringString_values(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def items(self):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairStringStringHandle h_ret
        h_ret = c_api.MapStringString_items(self.handle)
        if h_ret == <c_api.ListPairStringStringHandle>0:
            return None
        return ListPairStringString.from_capi(ListPairStringString, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringString_equal(self.handle, <c_api.MapStringStringHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringString_not_equal(self.handle, <c_api.MapStringStringHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapStringStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapStringString_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapStringString _mapstringstring_from_capi(c_api.MapStringStringHandle h):
    cdef MapStringString obj = <MapStringString>MapStringString.__new__(MapStringString)
    obj.handle = h