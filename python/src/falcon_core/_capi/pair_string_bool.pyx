# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class PairStringBool:
    cdef c_api.PairStringBoolHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairStringBoolHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairStringBoolHandle>0 and self.owned:
            c_api.PairStringBool_destroy(self.handle)
        self.handle = <c_api.PairStringBoolHandle>0

    cdef PairStringBool from_capi(cls, c_api.PairStringBoolHandle h):
        cdef PairStringBool obj = <PairStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, first, second):
        first_bytes = first.encode("utf-8")
        cdef const char* raw_first = first_bytes
        cdef size_t len_first = len(first_bytes)
        cdef c_api.StringHandle s_first = c_api.String_create(raw_first, len_first)
        cdef c_api.PairStringBoolHandle h
        try:
            h = c_api.PairStringBool_create(s_first, second)
        finally:
            c_api.String_destroy(s_first)
        if h == <c_api.PairStringBoolHandle>0:
            raise MemoryError("Failed to create PairStringBool")
        cdef PairStringBool obj = <PairStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PairStringBoolHandle h
        try:
            h = c_api.PairStringBool_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PairStringBoolHandle>0:
            raise MemoryError("Failed to create PairStringBool")
        cdef PairStringBool obj = <PairStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self):
        if self.handle == <c_api.PairStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairStringBool_first(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def second(self):
        if self.handle == <c_api.PairStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairStringBool_second(self.handle)

    def equal(self, b):
        if self.handle == <c_api.PairStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairStringBool_equal(self.handle, <c_api.PairStringBoolHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PairStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairStringBool_not_equal(self.handle, <c_api.PairStringBoolHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PairStringBoolHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairStringBool_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PairStringBool _pairstringbool_from_capi(c_api.PairStringBoolHandle h):
    cdef PairStringBool obj = <PairStringBool>PairStringBool.__new__(PairStringBool)
    obj.handle = h