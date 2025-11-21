# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .interpretation_context cimport InterpretationContext

cdef class PairInterpretationContextString:
    cdef c_api.PairInterpretationContextStringHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairInterpretationContextStringHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairInterpretationContextStringHandle>0 and self.owned:
            c_api.PairInterpretationContextString_destroy(self.handle)
        self.handle = <c_api.PairInterpretationContextStringHandle>0

    cdef PairInterpretationContextString from_capi(cls, c_api.PairInterpretationContextStringHandle h):
        cdef PairInterpretationContextString obj = <PairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, first, second):
        second_bytes = second.encode("utf-8")
        cdef const char* raw_second = second_bytes
        cdef size_t len_second = len(second_bytes)
        cdef c_api.StringHandle s_second = c_api.String_create(raw_second, len_second)
        cdef c_api.PairInterpretationContextStringHandle h
        try:
            h = c_api.PairInterpretationContextString_create(<c_api.InterpretationContextHandle>first.handle, s_second)
        finally:
            c_api.String_destroy(s_second)
        if h == <c_api.PairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextString")
        cdef PairInterpretationContextString obj = <PairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PairInterpretationContextStringHandle h
        try:
            h = c_api.PairInterpretationContextString_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextString")
        cdef PairInterpretationContextString obj = <PairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self):
        if self.handle == <c_api.PairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.InterpretationContextHandle h_ret
        h_ret = c_api.PairInterpretationContextString_first(self.handle)
        if h_ret == <c_api.InterpretationContextHandle>0:
            return None
        return InterpretationContext.from_capi(InterpretationContext, h_ret)

    def second(self):
        if self.handle == <c_api.PairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairInterpretationContextString_second(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def equal(self, b):
        if self.handle == <c_api.PairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairInterpretationContextString_equal(self.handle, <c_api.PairInterpretationContextStringHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairInterpretationContextString_not_equal(self.handle, <c_api.PairInterpretationContextStringHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PairInterpretationContextStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairInterpretationContextString_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PairInterpretationContextString _pairinterpretationcontextstring_from_capi(c_api.PairInterpretationContextStringHandle h):
    cdef PairInterpretationContextString obj = <PairInterpretationContextString>PairInterpretationContextString.__new__(PairInterpretationContextString)
    obj.handle = h