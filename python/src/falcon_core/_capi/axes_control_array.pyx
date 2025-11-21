# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .control_array cimport ControlArray
from .list_control_array cimport ListControlArray

cdef class AxesControlArray:
    cdef c_api.AxesControlArrayHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.AxesControlArrayHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.AxesControlArrayHandle>0 and self.owned:
            c_api.AxesControlArray_destroy(self.handle)
        self.handle = <c_api.AxesControlArrayHandle>0

    cdef AxesControlArray from_capi(cls, c_api.AxesControlArrayHandle h):
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.AxesControlArrayHandle h
        h = c_api.AxesControlArray_create_empty()
        if h == <c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, data, count):
        cdef c_api.AxesControlArrayHandle h
        h = c_api.AxesControlArray_create_raw(<c_api.ControlArrayHandle>data.handle, count)
        if h == <c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data):
        cdef c_api.AxesControlArrayHandle h
        h = c_api.AxesControlArray_create(<c_api.ListControlArrayHandle>data.handle)
        if h == <c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.AxesControlArrayHandle h
        try:
            h = c_api.AxesControlArray_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, value):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesControlArray_push_back(self.handle, <c_api.ControlArrayHandle>value.handle)

    def size(self):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesControlArray_size(self.handle)

    def empty(self):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesControlArray_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesControlArray_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesControlArray_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.AxesControlArray_at(self.handle, idx)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesControlArray_items(self.handle, <c_api.ControlArrayHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesControlArray_contains(self.handle, <c_api.ControlArrayHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesControlArray_index(self.handle, <c_api.ControlArrayHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesControlArrayHandle h_ret
        h_ret = c_api.AxesControlArray_intersection(self.handle, <c_api.AxesControlArrayHandle>other.handle)
        if h_ret == <c_api.AxesControlArrayHandle>0:
            return None
        return AxesControlArray.from_capi(AxesControlArray, h_ret)

    def equal(self, b):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesControlArray_equal(self.handle, <c_api.AxesControlArrayHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesControlArray_not_equal(self.handle, <c_api.AxesControlArrayHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.AxesControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.AxesControlArray_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef AxesControlArray _axescontrolarray_from_capi(c_api.AxesControlArrayHandle h):
    cdef AxesControlArray obj = <AxesControlArray>AxesControlArray.__new__(AxesControlArray)
    obj.handle = h