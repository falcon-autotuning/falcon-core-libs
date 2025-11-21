# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class PairStringString:
    cdef c_api.PairStringStringHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairStringStringHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairStringStringHandle>0 and self.owned:
            c_api.PairStringString_destroy(self.handle)
        self.handle = <c_api.PairStringStringHandle>0

    cdef PairStringString from_capi(cls, c_api.PairStringStringHandle h):
        cdef PairStringString obj = <PairStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, first, second):
        first_bytes = first.encode("utf-8")
        cdef const char* raw_first = first_bytes
        cdef size_t len_first = len(first_bytes)
        cdef c_api.StringHandle s_first = c_api.String_create(raw_first, len_first)
        second_bytes = second.encode("utf-8")
        cdef const char* raw_second = second_bytes
        cdef size_t len_second = len(second_bytes)
        cdef c_api.StringHandle s_second = c_api.String_create(raw_second, len_second)
        cdef c_api.PairStringStringHandle h
        try:
            h = c_api.PairStringString_create(s_first, s_second)
        finally:
            c_api.String_destroy(s_first)
            c_api.String_destroy(s_second)
        if h == <c_api.PairStringStringHandle>0:
            raise MemoryError("Failed to create PairStringString")
        cdef PairStringString obj = <PairStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PairStringStringHandle h
        try:
            h = c_api.PairStringString_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PairStringStringHandle>0:
            raise MemoryError("Failed to create PairStringString")
        cdef PairStringString obj = <PairStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self):
        if self.handle == <c_api.PairStringStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairStringString_first(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def second(self):
        if self.handle == <c_api.PairStringStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairStringString_second(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def equal(self, b):
        if self.handle == <c_api.PairStringStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairStringString_equal(self.handle, <c_api.PairStringStringHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PairStringStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairStringString_not_equal(self.handle, <c_api.PairStringStringHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PairStringStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairStringString_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PairStringString _pairstringstring_from_capi(c_api.PairStringStringHandle h):
    cdef PairStringString obj = <PairStringString>PairStringString.__new__(PairStringString)
    obj.handle = h