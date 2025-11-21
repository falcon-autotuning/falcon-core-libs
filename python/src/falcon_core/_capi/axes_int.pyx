# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .list_int cimport ListInt

cdef class AxesInt:
    cdef c_api.AxesIntHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.AxesIntHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.AxesIntHandle>0 and self.owned:
            c_api.AxesInt_destroy(self.handle)
        self.handle = <c_api.AxesIntHandle>0

    cdef AxesInt from_capi(cls, c_api.AxesIntHandle h):
        cdef AxesInt obj = <AxesInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.AxesIntHandle h
        h = c_api.AxesInt_create_empty()
        if h == <c_api.AxesIntHandle>0:
            raise MemoryError("Failed to create AxesInt")
        cdef AxesInt obj = <AxesInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, data, count):
        cdef c_api.AxesIntHandle h
        h = c_api.AxesInt_create_raw(data, count)
        if h == <c_api.AxesIntHandle>0:
            raise MemoryError("Failed to create AxesInt")
        cdef AxesInt obj = <AxesInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data):
        cdef c_api.AxesIntHandle h
        h = c_api.AxesInt_create(<c_api.ListIntHandle>data.handle)
        if h == <c_api.AxesIntHandle>0:
            raise MemoryError("Failed to create AxesInt")
        cdef AxesInt obj = <AxesInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.AxesIntHandle h
        try:
            h = c_api.AxesInt_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.AxesIntHandle>0:
            raise MemoryError("Failed to create AxesInt")
        cdef AxesInt obj = <AxesInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, value):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesInt_push_back(self.handle, value)

    def size(self):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInt_size(self.handle)

    def empty(self):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInt_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesInt_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesInt_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInt_at(self.handle, idx)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInt_items(self.handle, out_buffer, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInt_contains(self.handle, value)

    def index(self, value):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInt_index(self.handle, value)

    def intersection(self, other):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesIntHandle h_ret
        h_ret = c_api.AxesInt_intersection(self.handle, <c_api.AxesIntHandle>other.handle)
        if h_ret == <c_api.AxesIntHandle>0:
            return None
        return AxesInt.from_capi(AxesInt, h_ret)

    def equal(self, b):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInt_equal(self.handle, <c_api.AxesIntHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesInt_not_equal(self.handle, <c_api.AxesIntHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.AxesIntHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.AxesInt_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef AxesInt _axesint_from_capi(c_api.AxesIntHandle h):
    cdef AxesInt obj = <AxesInt>AxesInt.__new__(AxesInt)
    obj.handle = h