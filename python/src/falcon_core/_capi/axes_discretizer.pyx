# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .discretizer cimport Discretizer
from .list_discretizer cimport ListDiscretizer

cdef class AxesDiscretizer:
    cdef c_api.AxesDiscretizerHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.AxesDiscretizerHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.AxesDiscretizerHandle>0 and self.owned:
            c_api.AxesDiscretizer_destroy(self.handle)
        self.handle = <c_api.AxesDiscretizerHandle>0

    cdef AxesDiscretizer from_capi(cls, c_api.AxesDiscretizerHandle h):
        cdef AxesDiscretizer obj = <AxesDiscretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.AxesDiscretizerHandle h
        h = c_api.AxesDiscretizer_create_empty()
        if h == <c_api.AxesDiscretizerHandle>0:
            raise MemoryError("Failed to create AxesDiscretizer")
        cdef AxesDiscretizer obj = <AxesDiscretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, data, count):
        cdef c_api.AxesDiscretizerHandle h
        h = c_api.AxesDiscretizer_create_raw(<c_api.DiscretizerHandle>data.handle, count)
        if h == <c_api.AxesDiscretizerHandle>0:
            raise MemoryError("Failed to create AxesDiscretizer")
        cdef AxesDiscretizer obj = <AxesDiscretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data):
        cdef c_api.AxesDiscretizerHandle h
        h = c_api.AxesDiscretizer_create(<c_api.ListDiscretizerHandle>data.handle)
        if h == <c_api.AxesDiscretizerHandle>0:
            raise MemoryError("Failed to create AxesDiscretizer")
        cdef AxesDiscretizer obj = <AxesDiscretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.AxesDiscretizerHandle h
        try:
            h = c_api.AxesDiscretizer_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.AxesDiscretizerHandle>0:
            raise MemoryError("Failed to create AxesDiscretizer")
        cdef AxesDiscretizer obj = <AxesDiscretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, value):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesDiscretizer_push_back(self.handle, <c_api.DiscretizerHandle>value.handle)

    def size(self):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDiscretizer_size(self.handle)

    def empty(self):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDiscretizer_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesDiscretizer_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesDiscretizer_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DiscretizerHandle h_ret
        h_ret = c_api.AxesDiscretizer_at(self.handle, idx)
        if h_ret == <c_api.DiscretizerHandle>0:
            return None
        return Discretizer.from_capi(Discretizer, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDiscretizer_items(self.handle, <c_api.DiscretizerHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDiscretizer_contains(self.handle, <c_api.DiscretizerHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDiscretizer_index(self.handle, <c_api.DiscretizerHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesDiscretizerHandle h_ret
        h_ret = c_api.AxesDiscretizer_intersection(self.handle, <c_api.AxesDiscretizerHandle>other.handle)
        if h_ret == <c_api.AxesDiscretizerHandle>0:
            return None
        return AxesDiscretizer.from_capi(AxesDiscretizer, h_ret)

    def equal(self, b):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDiscretizer_equal(self.handle, <c_api.AxesDiscretizerHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesDiscretizer_not_equal(self.handle, <c_api.AxesDiscretizerHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.AxesDiscretizerHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.AxesDiscretizer_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef AxesDiscretizer _axesdiscretizer_from_capi(c_api.AxesDiscretizerHandle h):
    cdef AxesDiscretizer obj = <AxesDiscretizer>AxesDiscretizer.__new__(AxesDiscretizer)
    obj.handle = h