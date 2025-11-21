# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class PairIntInt:
    cdef c_api.PairIntIntHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairIntIntHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairIntIntHandle>0 and self.owned:
            c_api.PairIntInt_destroy(self.handle)
        self.handle = <c_api.PairIntIntHandle>0

    cdef PairIntInt from_capi(cls, c_api.PairIntIntHandle h):
        cdef PairIntInt obj = <PairIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, first, second):
        cdef c_api.PairIntIntHandle h
        h = c_api.PairIntInt_create(first, second)
        if h == <c_api.PairIntIntHandle>0:
            raise MemoryError("Failed to create PairIntInt")
        cdef PairIntInt obj = <PairIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PairIntIntHandle h
        try:
            h = c_api.PairIntInt_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PairIntIntHandle>0:
            raise MemoryError("Failed to create PairIntInt")
        cdef PairIntInt obj = <PairIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self):
        if self.handle == <c_api.PairIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairIntInt_first(self.handle)

    def second(self):
        if self.handle == <c_api.PairIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairIntInt_second(self.handle)

    def equal(self, b):
        if self.handle == <c_api.PairIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairIntInt_equal(self.handle, <c_api.PairIntIntHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PairIntIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairIntInt_not_equal(self.handle, <c_api.PairIntIntHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PairIntIntHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairIntInt_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PairIntInt _pairintint_from_capi(c_api.PairIntIntHandle h):
    cdef PairIntInt obj = <PairIntInt>PairIntInt.__new__(PairIntInt)
    obj.handle = h