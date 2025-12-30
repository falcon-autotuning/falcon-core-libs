cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .adjacency cimport Adjacency, _adjacency_from_capi
from .f_array_double cimport FArrayDouble, _f_array_double_from_capi
from .pair_double_double cimport PairDoubleDouble, _pair_double_double_from_capi

cdef class VoltageConstraints:
    def __cinit__(self):
        self.handle = <_c_api.VoltageConstraintsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.VoltageConstraintsHandle>0 and self.owned:
            _c_api.VoltageConstraints_destroy(self.handle)
        self.handle = <_c_api.VoltageConstraintsHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.VoltageConstraintsHandle h
        try:
            h = _c_api.VoltageConstraints_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.VoltageConstraintsHandle>0:
            raise MemoryError("Failed to create VoltageConstraints")
        cdef VoltageConstraints obj = <VoltageConstraints>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, Adjacency adjacency, double max_safe_diff, PairDoubleDouble bounds):
        cdef _c_api.VoltageConstraintsHandle h
        h = _c_api.VoltageConstraints_create(adjacency.handle if adjacency is not None else <_c_api.AdjacencyHandle>0, max_safe_diff, bounds.handle if bounds is not None else <_c_api.PairDoubleDoubleHandle>0)
        if h == <_c_api.VoltageConstraintsHandle>0:
            raise MemoryError("Failed to create VoltageConstraints")
        cdef VoltageConstraints obj = <VoltageConstraints>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.VoltageConstraintsHandle h_ret = _c_api.VoltageConstraints_copy(self.handle)
        if h_ret == <_c_api.VoltageConstraintsHandle>0:
            return None
        return _voltage_constraints_from_capi(h_ret, owned=(h_ret != <_c_api.VoltageConstraintsHandle>self.handle))

    def equal(self, VoltageConstraints other):
        return _c_api.VoltageConstraints_equal(self.handle, other.handle if other is not None else <_c_api.VoltageConstraintsHandle>0)

    def __eq__(self, VoltageConstraints other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, VoltageConstraints other):
        return _c_api.VoltageConstraints_not_equal(self.handle, other.handle if other is not None else <_c_api.VoltageConstraintsHandle>0)

    def __ne__(self, VoltageConstraints other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.VoltageConstraints_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def matrix(self, ):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.VoltageConstraints_matrix(self.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def adjacency(self, ):
        cdef _c_api.AdjacencyHandle h_ret = _c_api.VoltageConstraints_adjacency(self.handle)
        if h_ret == <_c_api.AdjacencyHandle>0:
            return None
        return _adjacency_from_capi(h_ret)

    def limits(self, ):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.VoltageConstraints_limits(self.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

cdef VoltageConstraints _voltage_constraints_from_capi(_c_api.VoltageConstraintsHandle h, bint owned=True):
    if h == <_c_api.VoltageConstraintsHandle>0:
        return None
    cdef VoltageConstraints obj = VoltageConstraints.__new__(VoltageConstraints)
    obj.handle = h
    obj.owned = owned
    return obj
