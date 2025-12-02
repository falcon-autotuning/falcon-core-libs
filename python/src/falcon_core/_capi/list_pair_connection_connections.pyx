cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_connection_connections

cdef class ListPairConnectionConnections:
    def __cinit__(self):
        self.handle = <_c_api.ListPairConnectionConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairConnectionConnectionsHandle>0 and self.owned:
            _c_api.ListPairConnectionConnections_destroy(self.handle)
        self.handle = <_c_api.ListPairConnectionConnectionsHandle>0


cdef ListPairConnectionConnections _list_pair_connection_connections_from_capi(_c_api.ListPairConnectionConnectionsHandle h):
    if h == <_c_api.ListPairConnectionConnectionsHandle>0:
        return None
    cdef ListPairConnectionConnections obj = ListPairConnectionConnections.__new__(ListPairConnectionConnections)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListPairConnectionConnectionsHandle h
        h = _c_api.ListPairConnectionConnections_create_empty()
        if h == <_c_api.ListPairConnectionConnectionsHandle>0:
            raise MemoryError("Failed to create ListPairConnectionConnections")
        cdef ListPairConnectionConnections obj = <ListPairConnectionConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairConnectionConnections data, size_t count):
        cdef _c_api.ListPairConnectionConnectionsHandle h
        h = _c_api.ListPairConnectionConnections_create(data.handle, count)
        if h == <_c_api.ListPairConnectionConnectionsHandle>0:
            raise MemoryError("Failed to create ListPairConnectionConnections")
        cdef ListPairConnectionConnections obj = <ListPairConnectionConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairConnectionConnectionsHandle h
        try:
            h = _c_api.ListPairConnectionConnections_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairConnectionConnectionsHandle>0:
            raise MemoryError("Failed to create ListPairConnectionConnections")
        cdef ListPairConnectionConnections obj = <ListPairConnectionConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairConnectionConnections value):
        cdef _c_api.ListPairConnectionConnectionsHandle h_ret = _c_api.ListPairConnectionConnections_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairConnectionConnectionsHandle>0:
            return None
        return _list_pair_connection_connections_from_capi(h_ret)

    def push_back(self, PairConnectionConnections value):
        _c_api.ListPairConnectionConnections_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairConnectionConnections_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairConnectionConnections_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairConnectionConnections_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairConnectionConnections_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairConnectionConnectionsHandle h_ret = _c_api.ListPairConnectionConnections_at(self.handle, idx)
        if h_ret == <_c_api.PairConnectionConnectionsHandle>0:
            return None
        return pair_connection_connections._pair_connection_connections_from_capi(h_ret)

    def items(self, PairConnectionConnections out_buffer, size_t buffer_size):
        return _c_api.ListPairConnectionConnections_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairConnectionConnections value):
        return _c_api.ListPairConnectionConnections_contains(self.handle, value.handle)

    def index(self, PairConnectionConnections value):
        return _c_api.ListPairConnectionConnections_index(self.handle, value.handle)

    def intersection(self, ListPairConnectionConnections other):
        cdef _c_api.ListPairConnectionConnectionsHandle h_ret = _c_api.ListPairConnectionConnections_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairConnectionConnectionsHandle>0:
            return None
        return _list_pair_connection_connections_from_capi(h_ret)

    def equal(self, ListPairConnectionConnections b):
        return _c_api.ListPairConnectionConnections_equal(self.handle, b.handle)

    def __eq__(self, ListPairConnectionConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairConnectionConnections b):
        return _c_api.ListPairConnectionConnections_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairConnectionConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
