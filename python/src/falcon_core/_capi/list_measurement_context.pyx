# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .measurement_context cimport MeasurementContext

cdef class ListMeasurementContext:
    cdef c_api.ListMeasurementContextHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ListMeasurementContextHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ListMeasurementContextHandle>0 and self.owned:
            c_api.ListMeasurementContext_destroy(self.handle)
        self.handle = <c_api.ListMeasurementContextHandle>0

    cdef ListMeasurementContext from_capi(cls, c_api.ListMeasurementContextHandle h):
        cdef ListMeasurementContext obj = <ListMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ListMeasurementContextHandle h
        h = c_api.ListMeasurementContext_create_empty()
        if h == <c_api.ListMeasurementContextHandle>0:
            raise MemoryError("Failed to create ListMeasurementContext")
        cdef ListMeasurementContext obj = <ListMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.ListMeasurementContextHandle h
        h = c_api.ListMeasurementContext_create(<c_api.MeasurementContextHandle>data.handle, count)
        if h == <c_api.ListMeasurementContextHandle>0:
            raise MemoryError("Failed to create ListMeasurementContext")
        cdef ListMeasurementContext obj = <ListMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ListMeasurementContextHandle h
        try:
            h = c_api.ListMeasurementContext_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ListMeasurementContextHandle>0:
            raise MemoryError("Failed to create ListMeasurementContext")
        cdef ListMeasurementContext obj = <ListMeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(count, value):
        cdef c_api.ListMeasurementContextHandle h_ret
        h_ret = c_api.ListMeasurementContext_fill_value(count, <c_api.MeasurementContextHandle>value.handle)
        if h_ret == <c_api.ListMeasurementContextHandle>0:
            return None
        return ListMeasurementContext.from_capi(ListMeasurementContext, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListMeasurementContext_push_back(self.handle, <c_api.MeasurementContextHandle>value.handle)

    def size(self):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListMeasurementContext_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListMeasurementContext_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListMeasurementContext_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListMeasurementContext_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasurementContextHandle h_ret
        h_ret = c_api.ListMeasurementContext_at(self.handle, idx)
        if h_ret == <c_api.MeasurementContextHandle>0:
            return None
        return MeasurementContext.from_capi(MeasurementContext, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListMeasurementContext_items(self.handle, <c_api.MeasurementContextHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListMeasurementContext_contains(self.handle, <c_api.MeasurementContextHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListMeasurementContext_index(self.handle, <c_api.MeasurementContextHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListMeasurementContextHandle h_ret
        h_ret = c_api.ListMeasurementContext_intersection(self.handle, <c_api.ListMeasurementContextHandle>other.handle)
        if h_ret == <c_api.ListMeasurementContextHandle>0:
            return None
        return ListMeasurementContext.from_capi(ListMeasurementContext, h_ret)

    def equal(self, b):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListMeasurementContext_equal(self.handle, <c_api.ListMeasurementContextHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListMeasurementContext_not_equal(self.handle, <c_api.ListMeasurementContextHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ListMeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ListMeasurementContext_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ListMeasurementContext _listmeasurementcontext_from_capi(c_api.ListMeasurementContextHandle h):
    cdef ListMeasurementContext obj = <ListMeasurementContext>ListMeasurementContext.__new__(ListMeasurementContext)
    obj.handle = h