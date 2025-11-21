# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class PairStringDouble:
    cdef c_api.PairStringDoubleHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairStringDoubleHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairStringDoubleHandle>0 and self.owned:
            c_api.PairStringDouble_destroy(self.handle)
        self.handle = <c_api.PairStringDoubleHandle>0

    cdef PairStringDouble from_capi(cls, c_api.PairStringDoubleHandle h):
        cdef PairStringDouble obj = <PairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, first, second):
        first_bytes = first.encode("utf-8")
        cdef const char* raw_first = first_bytes
        cdef size_t len_first = len(first_bytes)
        cdef c_api.StringHandle s_first = c_api.String_create(raw_first, len_first)
        cdef c_api.PairStringDoubleHandle h
        try:
            h = c_api.PairStringDouble_create(s_first, second)
        finally:
            c_api.String_destroy(s_first)
        if h == <c_api.PairStringDoubleHandle>0:
            raise MemoryError("Failed to create PairStringDouble")
        cdef PairStringDouble obj = <PairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PairStringDoubleHandle h
        try:
            h = c_api.PairStringDouble_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PairStringDoubleHandle>0:
            raise MemoryError("Failed to create PairStringDouble")
        cdef PairStringDouble obj = <PairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self):
        if self.handle == <c_api.PairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairStringDouble_first(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def second(self):
        if self.handle == <c_api.PairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairStringDouble_second(self.handle)

    def equal(self, b):
        if self.handle == <c_api.PairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairStringDouble_equal(self.handle, <c_api.PairStringDoubleHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairStringDouble_not_equal(self.handle, <c_api.PairStringDoubleHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairStringDouble_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PairStringDouble _pairstringdouble_from_capi(c_api.PairStringDoubleHandle h):
    cdef PairStringDouble obj = <PairStringDouble>PairStringDouble.__new__(PairStringDouble)
    obj.handle = h