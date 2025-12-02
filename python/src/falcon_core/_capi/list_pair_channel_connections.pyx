cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_channel_connections

cdef class ListPairChannelConnections:
    def __cinit__(self):
        self.handle = <_c_api.ListPairChannelConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairChannelConnectionsHandle>0 and self.owned:
            _c_api.ListPairChannelConnections_destroy(self.handle)
        self.handle = <_c_api.ListPairChannelConnectionsHandle>0


cdef ListPairChannelConnections _list_pair_channel_connections_from_capi(_c_api.ListPairChannelConnectionsHandle h):
    if h == <_c_api.ListPairChannelConnectionsHandle>0:
        return None
    cdef ListPairChannelConnections obj = ListPairChannelConnections.__new__(ListPairChannelConnections)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListPairChannelConnectionsHandle h
        h = _c_api.ListPairChannelConnections_create_empty()
        if h == <_c_api.ListPairChannelConnectionsHandle>0:
            raise MemoryError("Failed to create ListPairChannelConnections")
        cdef ListPairChannelConnections obj = <ListPairChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairChannelConnections data, size_t count):
        cdef _c_api.ListPairChannelConnectionsHandle h
        h = _c_api.ListPairChannelConnections_create(data.handle, count)
        if h == <_c_api.ListPairChannelConnectionsHandle>0:
            raise MemoryError("Failed to create ListPairChannelConnections")
        cdef ListPairChannelConnections obj = <ListPairChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairChannelConnectionsHandle h
        try:
            h = _c_api.ListPairChannelConnections_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairChannelConnectionsHandle>0:
            raise MemoryError("Failed to create ListPairChannelConnections")
        cdef ListPairChannelConnections obj = <ListPairChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairChannelConnections value):
        cdef _c_api.ListPairChannelConnectionsHandle h_ret = _c_api.ListPairChannelConnections_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairChannelConnectionsHandle>0:
            return None
        return _list_pair_channel_connections_from_capi(h_ret)

    def push_back(self, PairChannelConnections value):
        _c_api.ListPairChannelConnections_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairChannelConnections_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairChannelConnections_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairChannelConnections_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairChannelConnections_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairChannelConnectionsHandle h_ret = _c_api.ListPairChannelConnections_at(self.handle, idx)
        if h_ret == <_c_api.PairChannelConnectionsHandle>0:
            return None
        return pair_channel_connections._pair_channel_connections_from_capi(h_ret)

    def items(self, PairChannelConnections out_buffer, size_t buffer_size):
        return _c_api.ListPairChannelConnections_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairChannelConnections value):
        return _c_api.ListPairChannelConnections_contains(self.handle, value.handle)

    def index(self, PairChannelConnections value):
        return _c_api.ListPairChannelConnections_index(self.handle, value.handle)

    def intersection(self, ListPairChannelConnections other):
        cdef _c_api.ListPairChannelConnectionsHandle h_ret = _c_api.ListPairChannelConnections_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairChannelConnectionsHandle>0:
            return None
        return _list_pair_channel_connections_from_capi(h_ret)

    def equal(self, ListPairChannelConnections b):
        return _c_api.ListPairChannelConnections_equal(self.handle, b.handle)

    def __eq__(self, ListPairChannelConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairChannelConnections b):
        return _c_api.ListPairChannelConnections_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairChannelConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
