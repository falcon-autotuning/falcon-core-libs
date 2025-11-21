# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .interpretation_context cimport InterpretationContext
from .list_interpretation_context cimport ListInterpretationContext
from .list_pair_interpretation_context_string cimport ListPairInterpretationContextString
from .list_string cimport ListString
from .pair_interpretation_context_string cimport PairInterpretationContextString

cdef class MapInterpretationContextString:
    cdef c_api.MapInterpretationContextStringHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapInterpretationContextStringHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapInterpretationContextStringHandle>0 and self.owned:
            c_api.MapInterpretationContextString_destroy(self.handle)
        self.handle = <c_api.MapInterpretationContextStringHandle>0

    cdef MapInterpretationContextString from_capi(cls, c_api.MapInterpretationContextStringHandle h):
        cdef MapInterpretationContextString obj = <MapInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapInterpretationContextStringHandle h
        h = c_api.MapInterpretationContextString_create_empty()
        if h == <c_api.MapInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextString")
        cdef MapInterpretationContextString obj = <MapInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapInterpretationContextStringHandle h
        h = c_api.MapInterpretationContextString_create(<c_api.PairInterpretationContextStringHandle>data.handle, count)
        if h == <c_api.MapInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextString")
        cdef MapInterpretationContextString obj = <MapInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapInterpretationContextStringHandle h
        try:
            h = c_api.MapInterpretationContextString_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextString")
        cdef MapInterpretationContextString obj = <MapInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        try:
            c_api.MapInterpretationContextString_insert_or_assign(self.handle, <c_api.InterpretationContextHandle>key.handle, s_value)
        finally:
            c_api.String_destroy(s_value)

    def insert(self, key, value):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        try:
            c_api.MapInterpretationContextString_insert(self.handle, <c_api.InterpretationContextHandle>key.handle, s_value)
        finally:
            c_api.String_destroy(s_value)

    def at(self, key):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapInterpretationContextString_at(self.handle, <c_api.InterpretationContextHandle>key.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def erase(self, key):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInterpretationContextString_erase(self.handle, <c_api.InterpretationContextHandle>key.handle)

    def size(self):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextString_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextString_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInterpretationContextString_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextString_contains(self.handle, <c_api.InterpretationContextHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.MapInterpretationContextString_keys(self.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def values(self):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.MapInterpretationContextString_values(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def items(self):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairInterpretationContextStringHandle h_ret
        h_ret = c_api.MapInterpretationContextString_items(self.handle)
        if h_ret == <c_api.ListPairInterpretationContextStringHandle>0:
            return None
        return ListPairInterpretationContextString.from_capi(ListPairInterpretationContextString, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextString_equal(self.handle, <c_api.MapInterpretationContextStringHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextString_not_equal(self.handle, <c_api.MapInterpretationContextStringHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapInterpretationContextString_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapInterpretationContextString _mapinterpretationcontextstring_from_capi(c_api.MapInterpretationContextStringHandle h):
    cdef MapInterpretationContextString obj = <MapInterpretationContextString>MapInterpretationContextString.__new__(MapInterpretationContextString)
    obj.handle = h