cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport dot_gate_with_neighbors

cdef class ListDotGateWithNeighbors:
    def __cinit__(self):
        self.handle = <_c_api.ListDotGateWithNeighborsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListDotGateWithNeighborsHandle>0 and self.owned:
            _c_api.ListDotGateWithNeighbors_destroy(self.handle)
        self.handle = <_c_api.ListDotGateWithNeighborsHandle>0


cdef ListDotGateWithNeighbors _list_dot_gate_with_neighbors_from_capi(_c_api.ListDotGateWithNeighborsHandle h):
    if h == <_c_api.ListDotGateWithNeighborsHandle>0:
        return None
    cdef ListDotGateWithNeighbors obj = ListDotGateWithNeighbors.__new__(ListDotGateWithNeighbors)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListDotGateWithNeighborsHandle h
        h = _c_api.ListDotGateWithNeighbors_create_empty()
        if h == <_c_api.ListDotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create ListDotGateWithNeighbors")
        cdef ListDotGateWithNeighbors obj = <ListDotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, DotGateWithNeighbors data, size_t count):
        cdef _c_api.ListDotGateWithNeighborsHandle h
        h = _c_api.ListDotGateWithNeighbors_create(data.handle, count)
        if h == <_c_api.ListDotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create ListDotGateWithNeighbors")
        cdef ListDotGateWithNeighbors obj = <ListDotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListDotGateWithNeighborsHandle h
        try:
            h = _c_api.ListDotGateWithNeighbors_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListDotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create ListDotGateWithNeighbors")
        cdef ListDotGateWithNeighbors obj = <ListDotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, DotGateWithNeighbors value):
        cdef _c_api.ListDotGateWithNeighborsHandle h_ret = _c_api.ListDotGateWithNeighbors_fill_value(count, value.handle)
        if h_ret == <_c_api.ListDotGateWithNeighborsHandle>0:
            return None
        return _list_dot_gate_with_neighbors_from_capi(h_ret)

    def push_back(self, DotGateWithNeighbors value):
        _c_api.ListDotGateWithNeighbors_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListDotGateWithNeighbors_size(self.handle)

    def empty(self, ):
        return _c_api.ListDotGateWithNeighbors_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListDotGateWithNeighbors_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListDotGateWithNeighbors_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.DotGateWithNeighborsHandle h_ret = _c_api.ListDotGateWithNeighbors_at(self.handle, idx)
        if h_ret == <_c_api.DotGateWithNeighborsHandle>0:
            return None
        return dot_gate_with_neighbors._dot_gate_with_neighbors_from_capi(h_ret)

    def items(self, DotGateWithNeighbors out_buffer, size_t buffer_size):
        return _c_api.ListDotGateWithNeighbors_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, DotGateWithNeighbors value):
        return _c_api.ListDotGateWithNeighbors_contains(self.handle, value.handle)

    def index(self, DotGateWithNeighbors value):
        return _c_api.ListDotGateWithNeighbors_index(self.handle, value.handle)

    def intersection(self, ListDotGateWithNeighbors other):
        cdef _c_api.ListDotGateWithNeighborsHandle h_ret = _c_api.ListDotGateWithNeighbors_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListDotGateWithNeighborsHandle>0:
            return None
        return _list_dot_gate_with_neighbors_from_capi(h_ret)

    def equal(self, ListDotGateWithNeighbors b):
        return _c_api.ListDotGateWithNeighbors_equal(self.handle, b.handle)

    def __eq__(self, ListDotGateWithNeighbors b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListDotGateWithNeighbors b):
        return _c_api.ListDotGateWithNeighbors_not_equal(self.handle, b.handle)

    def __ne__(self, ListDotGateWithNeighbors b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
