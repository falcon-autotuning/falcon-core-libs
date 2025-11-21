# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .dot_gate_with_neighbors cimport DotGateWithNeighbors
from .list_dot_gate_with_neighbors cimport ListDotGateWithNeighbors
from .const _dot_gate_with_neighbors cimport const DotGateWithNeighbors

cdef class DotGatesWithNeighbors:
    cdef c_api.DotGatesWithNeighborsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.DotGatesWithNeighborsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.DotGatesWithNeighborsHandle>0 and self.owned:
            c_api.DotGatesWithNeighbors_destroy(self.handle)
        self.handle = <c_api.DotGatesWithNeighborsHandle>0

    cdef DotGatesWithNeighbors from_capi(cls, c_api.DotGatesWithNeighborsHandle h):
        cdef DotGatesWithNeighbors obj = <DotGatesWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.DotGatesWithNeighborsHandle h
        h = c_api.DotGatesWithNeighbors_create_empty()
        if h == <c_api.DotGatesWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGatesWithNeighbors")
        cdef DotGatesWithNeighbors obj = <DotGatesWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, items):
        cdef c_api.DotGatesWithNeighborsHandle h
        h = c_api.DotGatesWithNeighbors_create(<c_api.ListDotGateWithNeighborsHandle>items.handle)
        if h == <c_api.DotGatesWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGatesWithNeighbors")
        cdef DotGatesWithNeighbors obj = <DotGatesWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.DotGatesWithNeighborsHandle h
        try:
            h = c_api.DotGatesWithNeighbors_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.DotGatesWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGatesWithNeighbors")
        cdef DotGatesWithNeighbors obj = <DotGatesWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def is_plunger_gates(self):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGatesWithNeighbors_is_plunger_gates(self.handle)

    def is_barrier_gates(self):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGatesWithNeighbors_is_barrier_gates(self.handle)

    def intersection(self, other):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DotGatesWithNeighborsHandle h_ret
        h_ret = c_api.DotGatesWithNeighbors_intersection(self.handle, <c_api.DotGatesWithNeighborsHandle>other.handle)
        if h_ret == <c_api.DotGatesWithNeighborsHandle>0:
            return None
        return DotGatesWithNeighbors.from_capi(DotGatesWithNeighbors, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DotGatesWithNeighbors_push_back(self.handle, <c_api.DotGateWithNeighborsHandle>value.handle)

    def size(self):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGatesWithNeighbors_size(self.handle)

    def empty(self):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGatesWithNeighbors_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DotGatesWithNeighbors_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DotGatesWithNeighbors_clear(self.handle)

    def const_at(self, idx):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.const DotGateWithNeighborsHandle h_ret
        h_ret = c_api.DotGatesWithNeighbors_const_at(self.handle, idx)
        if h_ret == <c_api.const DotGateWithNeighborsHandle>0:
            return None
        return const DotGateWithNeighbors.from_capi(const DotGateWithNeighbors, h_ret)

    def at(self, idx):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DotGateWithNeighborsHandle h_ret
        h_ret = c_api.DotGatesWithNeighbors_at(self.handle, idx)
        if h_ret == <c_api.DotGateWithNeighborsHandle>0:
            return None
        return DotGateWithNeighbors.from_capi(DotGateWithNeighbors, h_ret)

    def items(self):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListDotGateWithNeighborsHandle h_ret
        h_ret = c_api.DotGatesWithNeighbors_items(self.handle)
        if h_ret == <c_api.ListDotGateWithNeighborsHandle>0:
            return None
        return ListDotGateWithNeighbors.from_capi(ListDotGateWithNeighbors, h_ret)

    def contains(self, value):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGatesWithNeighbors_contains(self.handle, <c_api.DotGateWithNeighborsHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGatesWithNeighbors_index(self.handle, <c_api.DotGateWithNeighborsHandle>value.handle)

    def equal(self, b):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGatesWithNeighbors_equal(self.handle, <c_api.DotGatesWithNeighborsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGatesWithNeighbors_not_equal(self.handle, <c_api.DotGatesWithNeighborsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.DotGatesWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.DotGatesWithNeighbors_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef DotGatesWithNeighbors _dotgateswithneighbors_from_capi(c_api.DotGatesWithNeighborsHandle h):
    cdef DotGatesWithNeighbors obj = <DotGatesWithNeighbors>DotGatesWithNeighbors.__new__(DotGatesWithNeighbors)
    obj.handle = h