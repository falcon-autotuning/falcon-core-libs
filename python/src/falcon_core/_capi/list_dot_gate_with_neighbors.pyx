# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .dot_gate_with_neighbors cimport DotGateWithNeighbors

cdef class ListDotGateWithNeighbors:
    cdef c_api.ListDotGateWithNeighborsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ListDotGateWithNeighborsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ListDotGateWithNeighborsHandle>0 and self.owned:
            c_api.ListDotGateWithNeighbors_destroy(self.handle)
        self.handle = <c_api.ListDotGateWithNeighborsHandle>0

    cdef ListDotGateWithNeighbors from_capi(cls, c_api.ListDotGateWithNeighborsHandle h):
        cdef ListDotGateWithNeighbors obj = <ListDotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ListDotGateWithNeighborsHandle h
        h = c_api.ListDotGateWithNeighbors_create_empty()
        if h == <c_api.ListDotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create ListDotGateWithNeighbors")
        cdef ListDotGateWithNeighbors obj = <ListDotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.ListDotGateWithNeighborsHandle h
        h = c_api.ListDotGateWithNeighbors_create(<c_api.DotGateWithNeighborsHandle>data.handle, count)
        if h == <c_api.ListDotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create ListDotGateWithNeighbors")
        cdef ListDotGateWithNeighbors obj = <ListDotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ListDotGateWithNeighborsHandle h
        try:
            h = c_api.ListDotGateWithNeighbors_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ListDotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create ListDotGateWithNeighbors")
        cdef ListDotGateWithNeighbors obj = <ListDotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(count, value):
        cdef c_api.ListDotGateWithNeighborsHandle h_ret
        h_ret = c_api.ListDotGateWithNeighbors_fill_value(count, <c_api.DotGateWithNeighborsHandle>value.handle)
        if h_ret == <c_api.ListDotGateWithNeighborsHandle>0:
            return None
        return ListDotGateWithNeighbors.from_capi(ListDotGateWithNeighbors, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListDotGateWithNeighbors_push_back(self.handle, <c_api.DotGateWithNeighborsHandle>value.handle)

    def size(self):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListDotGateWithNeighbors_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListDotGateWithNeighbors_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListDotGateWithNeighbors_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListDotGateWithNeighbors_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DotGateWithNeighborsHandle h_ret
        h_ret = c_api.ListDotGateWithNeighbors_at(self.handle, idx)
        if h_ret == <c_api.DotGateWithNeighborsHandle>0:
            return None
        return DotGateWithNeighbors.from_capi(DotGateWithNeighbors, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListDotGateWithNeighbors_items(self.handle, <c_api.DotGateWithNeighborsHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListDotGateWithNeighbors_contains(self.handle, <c_api.DotGateWithNeighborsHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListDotGateWithNeighbors_index(self.handle, <c_api.DotGateWithNeighborsHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListDotGateWithNeighborsHandle h_ret
        h_ret = c_api.ListDotGateWithNeighbors_intersection(self.handle, <c_api.ListDotGateWithNeighborsHandle>other.handle)
        if h_ret == <c_api.ListDotGateWithNeighborsHandle>0:
            return None
        return ListDotGateWithNeighbors.from_capi(ListDotGateWithNeighbors, h_ret)

    def equal(self, b):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListDotGateWithNeighbors_equal(self.handle, <c_api.ListDotGateWithNeighborsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListDotGateWithNeighbors_not_equal(self.handle, <c_api.ListDotGateWithNeighborsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ListDotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ListDotGateWithNeighbors_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ListDotGateWithNeighbors _listdotgatewithneighbors_from_capi(c_api.ListDotGateWithNeighborsHandle h):
    cdef ListDotGateWithNeighbors obj = <ListDotGateWithNeighbors>ListDotGateWithNeighbors.__new__(ListDotGateWithNeighbors)
    obj.handle = h