cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport adjacency
from . cimport f_array_double
from . cimport pair_double_double

cdef class VoltageConstraints:
    def __cinit__(self):
        self.handle = <_c_api.VoltageConstraintsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.VoltageConstraintsHandle>0 and self.owned:
            _c_api.VoltageConstraints_destroy(self.handle)
        self.handle = <_c_api.VoltageConstraintsHandle>0


cdef VoltageConstraints _voltage_constraints_from_capi(_c_api.VoltageConstraintsHandle h):
    if h == <_c_api.VoltageConstraintsHandle>0:
        return None
    cdef VoltageConstraints obj = VoltageConstraints.__new__(VoltageConstraints)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, Adjacency adjacency, double max_safe_diff, PairDoubleDouble bounds):
        cdef _c_api.VoltageConstraintsHandle h
        h = _c_api.VoltageConstraints_create(adjacency.handle, max_safe_diff, bounds.handle)
        if h == <_c_api.VoltageConstraintsHandle>0:
            raise MemoryError("Failed to create VoltageConstraints")
        cdef VoltageConstraints obj = <VoltageConstraints>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def matrix(self, ):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.VoltageConstraints_matrix(self.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def adjacency(self, ):
        cdef _c_api.AdjacencyHandle h_ret = _c_api.VoltageConstraints_adjacency(self.handle)
        if h_ret == <_c_api.AdjacencyHandle>0:
            return None
        return adjacency._adjacency_from_capi(h_ret)

    def limits(self, ):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.VoltageConstraints_limits(self.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def equal(self, VoltageConstraints b):
        return _c_api.VoltageConstraints_equal(self.handle, b.handle)

    def __eq__(self, VoltageConstraints b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, VoltageConstraints b):
        return _c_api.VoltageConstraints_not_equal(self.handle, b.handle)

    def __ne__(self, VoltageConstraints b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
