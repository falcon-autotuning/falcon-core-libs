# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .list_bool cimport ListBool
from .list_pair_string_bool cimport ListPairStringBool
from .list_string cimport ListString
from .pair_string_bool cimport PairStringBool

cdef class MapStringBool:
    cdef c_api.MapStringBoolHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapStringBoolHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapStringBoolHandle>0 and self.owned:
            c_api.MapStringBool_destroy(self.handle)
        self.handle = <c_api.MapStringBoolHandle>0

    cdef MapStringBool from_capi(cls, c_api.MapStringBoolHandle h):
        cdef MapStringBool obj = <MapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapStringBoolHandle h
        h = c_api.MapStringBool_create_empty()
        if h == <c_api.MapStringBoolHandle>0:
            raise MemoryError("Failed to create MapStringBool")
        cdef MapStringBool obj = <MapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapStringBoolHandle h
        h = c_api.MapStringBool_create(<c_api.PairStringBoolHandle>data.handle, count)
        if h == <c_api.MapStringBoolHandle>0:
            raise MemoryError("Failed to create MapStringBool")
        cdef MapStringBool obj = <MapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapStringBoolHandle h
        try:
            h = c_api.MapStringBool_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapStringBoolHandle>0:
            raise MemoryError("Failed to create MapStringBool")
        cdef MapStringBool obj = <MapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        try:
            c_api.MapStringBool_insert_or_assign(self.handle, s_key, value)
        finally:
            c_api.String_destroy(s_key)

    def insert(self, key, value):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        try:
            c_api.MapStringBool_insert(self.handle, s_key, value)
        finally:
            c_api.String_destroy(s_key)

    def at(self, key):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        cdef bool ret_val
        try:
            ret_val = c_api.MapStringBool_at(self.handle, s_key)
        finally:
            c_api.String_destroy(s_key)
        return ret_val

    def erase(self, key):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        try:
            c_api.MapStringBool_erase(self.handle, s_key)
        finally:
            c_api.String_destroy(s_key)

    def size(self):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringBool_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringBool_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapStringBool_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        key_bytes = key.encode("utf-8")
        cdef const char* raw_key = key_bytes
        cdef size_t len_key = len(key_bytes)
        cdef c_api.StringHandle s_key = c_api.String_create(raw_key, len_key)
        cdef bool ret_val
        try:
            ret_val = c_api.MapStringBool_contains(self.handle, s_key)
        finally:
            c_api.String_destroy(s_key)
        return ret_val

    def keys(self):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.MapStringBool_keys(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def values(self):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListBoolHandle h_ret
        h_ret = c_api.MapStringBool_values(self.handle)
        if h_ret == <c_api.ListBoolHandle>0:
            return None
        return ListBool.from_capi(ListBool, h_ret)

    def items(self):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairStringBoolHandle h_ret
        h_ret = c_api.MapStringBool_items(self.handle)
        if h_ret == <c_api.ListPairStringBoolHandle>0:
            return None
        return ListPairStringBool.from_capi(ListPairStringBool, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringBool_equal(self.handle, <c_api.MapStringBoolHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapStringBool_not_equal(self.handle, <c_api.MapStringBoolHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapStringBool_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapStringBool _mapstringbool_from_capi(c_api.MapStringBoolHandle h):
    cdef MapStringBool obj = <MapStringBool>MapStringBool.__new__(MapStringBool)
    obj.handle = h