cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport dot_gate_with_neighbors
from . cimport list_dot_gate_with_neighbors

cdef class DotGatesWithNeighbors:
    def __cinit__(self):
        self.handle = <_c_api.DotGatesWithNeighborsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.DotGatesWithNeighborsHandle>0 and self.owned:
            _c_api.DotGatesWithNeighbors_destroy(self.handle)
        self.handle = <_c_api.DotGatesWithNeighborsHandle>0


cdef DotGatesWithNeighbors _dot_gates_with_neighbors_from_capi(_c_api.DotGatesWithNeighborsHandle h):
    if h == <_c_api.DotGatesWithNeighborsHandle>0:
        return None
    cdef DotGatesWithNeighbors obj = DotGatesWithNeighbors.__new__(DotGatesWithNeighbors)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.DotGatesWithNeighborsHandle h
        h = _c_api.DotGatesWithNeighbors_create_empty()
        if h == <_c_api.DotGatesWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGatesWithNeighbors")
        cdef DotGatesWithNeighbors obj = <DotGatesWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListDotGateWithNeighbors items):
        cdef _c_api.DotGatesWithNeighborsHandle h
        h = _c_api.DotGatesWithNeighbors_create(items.handle)
        if h == <_c_api.DotGatesWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGatesWithNeighbors")
        cdef DotGatesWithNeighbors obj = <DotGatesWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.DotGatesWithNeighborsHandle h
        try:
            h = _c_api.DotGatesWithNeighbors_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.DotGatesWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGatesWithNeighbors")
        cdef DotGatesWithNeighbors obj = <DotGatesWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def is_plunger_gates(self, ):
        return _c_api.DotGatesWithNeighbors_is_plunger_gates(self.handle)

    def is_barrier_gates(self, ):
        return _c_api.DotGatesWithNeighbors_is_barrier_gates(self.handle)

    def intersection(self, DotGatesWithNeighbors other):
        cdef _c_api.DotGatesWithNeighborsHandle h_ret = _c_api.DotGatesWithNeighbors_intersection(self.handle, other.handle)
        if h_ret == <_c_api.DotGatesWithNeighborsHandle>0:
            return None
        return _dot_gates_with_neighbors_from_capi(h_ret)

    def push_back(self, DotGateWithNeighbors value):
        _c_api.DotGatesWithNeighbors_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.DotGatesWithNeighbors_size(self.handle)

    def empty(self, ):
        return _c_api.DotGatesWithNeighbors_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.DotGatesWithNeighbors_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.DotGatesWithNeighbors_clear(self.handle)

    def const_at(self, size_t idx):
        cdef _c_api.DotGateWithNeighborsHandle h_ret = _c_api.DotGatesWithNeighbors_const_at(self.handle, idx)
        if h_ret == <_c_api.DotGateWithNeighborsHandle>0:
            return None
        return dot_gate_with_neighbors._dot_gate_with_neighbors_from_capi(h_ret)

    def at(self, size_t idx):
        cdef _c_api.DotGateWithNeighborsHandle h_ret = _c_api.DotGatesWithNeighbors_at(self.handle, idx)
        if h_ret == <_c_api.DotGateWithNeighborsHandle>0:
            return None
        return dot_gate_with_neighbors._dot_gate_with_neighbors_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListDotGateWithNeighborsHandle h_ret = _c_api.DotGatesWithNeighbors_items(self.handle)
        if h_ret == <_c_api.ListDotGateWithNeighborsHandle>0:
            return None
        return list_dot_gate_with_neighbors._list_dot_gate_with_neighbors_from_capi(h_ret)

    def contains(self, DotGateWithNeighbors value):
        return _c_api.DotGatesWithNeighbors_contains(self.handle, value.handle)

    def index(self, DotGateWithNeighbors value):
        return _c_api.DotGatesWithNeighbors_index(self.handle, value.handle)

    def equal(self, DotGatesWithNeighbors b):
        return _c_api.DotGatesWithNeighbors_equal(self.handle, b.handle)

    def __eq__(self, DotGatesWithNeighbors b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, DotGatesWithNeighbors b):
        return _c_api.DotGatesWithNeighbors_not_equal(self.handle, b.handle)

    def __ne__(self, DotGatesWithNeighbors b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
