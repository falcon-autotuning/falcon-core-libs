# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .list_double cimport ListDouble

cdef class AxesDouble:
    cdef c_api.AxesDoubleHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.AxesDoubleHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.AxesDoubleHandle>0 and self.owned:
            c_api.AxesDouble_destroy(self.handle)
        self.handle = <c_api.AxesDoubleHandle>0

    cdef AxesDouble from_capi(cls, c_api.AxesDoubleHandle h):
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.AxesDoubleHandle h
        h = c_api.AxesDouble_create_empty()
        if h == <c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, data, count):
        cdef c_api.AxesDoubleHandle h
        h = c_api.AxesDouble_create_raw(data, count)
        if h == <c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data):
        cdef c_api.AxesDoubleHandle h
        h = c_api.AxesDouble_create(<c_api.ListDoubleHandle>data.handle)
        if h == <c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.AxesDoubleHandle h
        try:
            h = c_api.AxesDouble_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, value):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesDouble_push_back(self.handle, value)

    def size(self):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDouble_size(self.handle)

    def empty(self):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDouble_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesDouble_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesDouble_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDouble_at(self.handle, idx)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDouble_items(self.handle, out_buffer, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDouble_contains(self.handle, value)

    def index(self, value):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDouble_index(self.handle, value)

    def intersection(self, other):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesDoubleHandle h_ret
        h_ret = c_api.AxesDouble_intersection(self.handle, <c_api.AxesDoubleHandle>other.handle)
        if h_ret == <c_api.AxesDoubleHandle>0:
            return None
        return AxesDouble.from_capi(AxesDouble, h_ret)

    def equal(self, b):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDouble_equal(self.handle, <c_api.AxesDoubleHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDouble_not_equal(self.handle, <c_api.AxesDoubleHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.AxesDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.AxesDouble_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef AxesDouble _axesdouble_from_capi(c_api.AxesDoubleHandle h):
    cdef AxesDouble obj = <AxesDouble>AxesDouble.__new__(AxesDouble)
    obj.handle = h