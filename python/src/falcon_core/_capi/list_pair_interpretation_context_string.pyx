# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .pair_interpretation_context_string cimport PairInterpretationContextString

cdef class ListPairInterpretationContextString:
    cdef c_api.ListPairInterpretationContextStringHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ListPairInterpretationContextStringHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ListPairInterpretationContextStringHandle>0 and self.owned:
            c_api.ListPairInterpretationContextString_destroy(self.handle)
        self.handle = <c_api.ListPairInterpretationContextStringHandle>0

    cdef ListPairInterpretationContextString from_capi(cls, c_api.ListPairInterpretationContextStringHandle h):
        cdef ListPairInterpretationContextString obj = <ListPairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ListPairInterpretationContextStringHandle h
        h = c_api.ListPairInterpretationContextString_create_empty()
        if h == <c_api.ListPairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextString")
        cdef ListPairInterpretationContextString obj = <ListPairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.ListPairInterpretationContextStringHandle h
        h = c_api.ListPairInterpretationContextString_create(<c_api.PairInterpretationContextStringHandle>data.handle, count)
        if h == <c_api.ListPairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextString")
        cdef ListPairInterpretationContextString obj = <ListPairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ListPairInterpretationContextStringHandle h
        try:
            h = c_api.ListPairInterpretationContextString_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ListPairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextString")
        cdef ListPairInterpretationContextString obj = <ListPairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(count, value):
        cdef c_api.ListPairInterpretationContextStringHandle h_ret
        h_ret = c_api.ListPairInterpretationContextString_fill_value(count, <c_api.PairInterpretationContextStringHandle>value.handle)
        if h_ret == <c_api.ListPairInterpretationContextStringHandle>0:
            return None
        return ListPairInterpretationContextString.from_capi(ListPairInterpretationContextString, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairInterpretationContextString_push_back(self.handle, <c_api.PairInterpretationContextStringHandle>value.handle)

    def size(self):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairInterpretationContextString_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairInterpretationContextString_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairInterpretationContextString_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairInterpretationContextString_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PairInterpretationContextStringHandle h_ret
        h_ret = c_api.ListPairInterpretationContextString_at(self.handle, idx)
        if h_ret == <c_api.PairInterpretationContextStringHandle>0:
            return None
        return PairInterpretationContextString.from_capi(PairInterpretationContextString, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairInterpretationContextString_items(self.handle, <c_api.PairInterpretationContextStringHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairInterpretationContextString_contains(self.handle, <c_api.PairInterpretationContextStringHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairInterpretationContextString_index(self.handle, <c_api.PairInterpretationContextStringHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairInterpretationContextStringHandle h_ret
        h_ret = c_api.ListPairInterpretationContextString_intersection(self.handle, <c_api.ListPairInterpretationContextStringHandle>other.handle)
        if h_ret == <c_api.ListPairInterpretationContextStringHandle>0:
            return None
        return ListPairInterpretationContextString.from_capi(ListPairInterpretationContextString, h_ret)

    def equal(self, b):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairInterpretationContextString_equal(self.handle, <c_api.ListPairInterpretationContextStringHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairInterpretationContextString_not_equal(self.handle, <c_api.ListPairInterpretationContextStringHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ListPairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ListPairInterpretationContextString_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ListPairInterpretationContextString _listpairinterpretationcontextstring_from_capi(c_api.ListPairInterpretationContextStringHandle h):
    cdef ListPairInterpretationContextString obj = <ListPairInterpretationContextString>ListPairInterpretationContextString.__new__(ListPairInterpretationContextString)
    obj.handle = h