cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connections

cdef class ListConnections:
    def __cinit__(self):
        self.handle = <_c_api.ListConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListConnectionsHandle>0 and self.owned:
            _c_api.ListConnections_destroy(self.handle)
        self.handle = <_c_api.ListConnectionsHandle>0


cdef ListConnections _list_connections_from_capi(_c_api.ListConnectionsHandle h):
    if h == <_c_api.ListConnectionsHandle>0:
        return None
    cdef ListConnections obj = ListConnections.__new__(ListConnections)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListConnectionsHandle h
        h = _c_api.ListConnections_create_empty()
        if h == <_c_api.ListConnectionsHandle>0:
            raise MemoryError("Failed to create ListConnections")
        cdef ListConnections obj = <ListConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, Connections data, size_t count):
        cdef _c_api.ListConnectionsHandle h
        h = _c_api.ListConnections_create(data.handle, count)
        if h == <_c_api.ListConnectionsHandle>0:
            raise MemoryError("Failed to create ListConnections")
        cdef ListConnections obj = <ListConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListConnectionsHandle h
        try:
            h = _c_api.ListConnections_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListConnectionsHandle>0:
            raise MemoryError("Failed to create ListConnections")
        cdef ListConnections obj = <ListConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, Connections value):
        cdef _c_api.ListConnectionsHandle h_ret = _c_api.ListConnections_fill_value(count, value.handle)
        if h_ret == <_c_api.ListConnectionsHandle>0:
            return None
        return _list_connections_from_capi(h_ret)

    def push_back(self, Connections value):
        _c_api.ListConnections_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListConnections_size(self.handle)

    def empty(self, ):
        return _c_api.ListConnections_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListConnections_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListConnections_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.ListConnections_at(self.handle, idx)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def items(self, Connections out_buffer, size_t buffer_size):
        return _c_api.ListConnections_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, Connections value):
        return _c_api.ListConnections_contains(self.handle, value.handle)

    def index(self, Connections value):
        return _c_api.ListConnections_index(self.handle, value.handle)

    def intersection(self, ListConnections other):
        cdef _c_api.ListConnectionsHandle h_ret = _c_api.ListConnections_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListConnectionsHandle>0:
            return None
        return _list_connections_from_capi(h_ret)

    def equal(self, ListConnections b):
        return _c_api.ListConnections_equal(self.handle, b.handle)

    def __eq__(self, ListConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListConnections b):
        return _c_api.ListConnections_not_equal(self.handle, b.handle)

    def __ne__(self, ListConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
