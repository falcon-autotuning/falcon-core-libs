# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .adjacency cimport Adjacency
from .f_array_double cimport FArrayDouble
from .pair_double_double cimport PairDoubleDouble

cdef class VoltageConstraints:
    cdef c_api.VoltageConstraintsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.VoltageConstraintsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.VoltageConstraintsHandle>0 and self.owned:
            c_api.VoltageConstraints_destroy(self.handle)
        self.handle = <c_api.VoltageConstraintsHandle>0

    cdef VoltageConstraints from_capi(cls, c_api.VoltageConstraintsHandle h):
        cdef VoltageConstraints obj = <VoltageConstraints>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, adjacency, max_safe_diff, bounds):
        cdef c_api.VoltageConstraintsHandle h
        h = c_api.VoltageConstraints_create(<c_api.AdjacencyHandle>adjacency.handle, max_safe_diff, <c_api.PairDoubleDoubleHandle>bounds.handle)
        if h == <c_api.VoltageConstraintsHandle>0:
            raise MemoryError("Failed to create VoltageConstraints")
        cdef VoltageConstraints obj = <VoltageConstraints>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.VoltageConstraintsHandle h
        try:
            h = c_api.VoltageConstraints_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.VoltageConstraintsHandle>0:
            raise MemoryError("Failed to create VoltageConstraints")
        cdef VoltageConstraints obj = <VoltageConstraints>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def matrix(self):
        if self.handle == <c_api.VoltageConstraintsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.FArrayDoubleHandle h_ret
        h_ret = c_api.VoltageConstraints_matrix(self.handle)
        if h_ret == <c_api.FArrayDoubleHandle>0:
            return None
        return FArrayDouble.from_capi(FArrayDouble, h_ret)

    def adjacency(self):
        if self.handle == <c_api.VoltageConstraintsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AdjacencyHandle h_ret
        h_ret = c_api.VoltageConstraints_adjacency(self.handle)
        if h_ret == <c_api.AdjacencyHandle>0:
            return None
        return Adjacency.from_capi(Adjacency, h_ret)

    def limits(self):
        if self.handle == <c_api.VoltageConstraintsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.FArrayDoubleHandle h_ret
        h_ret = c_api.VoltageConstraints_limits(self.handle)
        if h_ret == <c_api.FArrayDoubleHandle>0:
            return None
        return FArrayDouble.from_capi(FArrayDouble, h_ret)

    def equal(self, b):
        if self.handle == <c_api.VoltageConstraintsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.VoltageConstraints_equal(self.handle, <c_api.VoltageConstraintsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.VoltageConstraintsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.VoltageConstraints_not_equal(self.handle, <c_api.VoltageConstraintsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.VoltageConstraintsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.VoltageConstraints_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef VoltageConstraints _voltageconstraints_from_capi(c_api.VoltageConstraintsHandle h):
    cdef VoltageConstraints obj = <VoltageConstraints>VoltageConstraints.__new__(VoltageConstraints)
    obj.handle = h