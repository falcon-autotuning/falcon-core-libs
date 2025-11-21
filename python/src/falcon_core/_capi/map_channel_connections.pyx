# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .channel cimport Channel
from .connections cimport Connections
from .list_channel cimport ListChannel
from .list_connections cimport ListConnections
from .list_pair_channel_connections cimport ListPairChannelConnections
from .pair_channel_connections cimport PairChannelConnections

cdef class MapChannelConnections:
    cdef c_api.MapChannelConnectionsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapChannelConnectionsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapChannelConnectionsHandle>0 and self.owned:
            c_api.MapChannelConnections_destroy(self.handle)
        self.handle = <c_api.MapChannelConnectionsHandle>0

    cdef MapChannelConnections from_capi(cls, c_api.MapChannelConnectionsHandle h):
        cdef MapChannelConnections obj = <MapChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapChannelConnectionsHandle h
        h = c_api.MapChannelConnections_create_empty()
        if h == <c_api.MapChannelConnectionsHandle>0:
            raise MemoryError("Failed to create MapChannelConnections")
        cdef MapChannelConnections obj = <MapChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapChannelConnectionsHandle h
        h = c_api.MapChannelConnections_create(<c_api.PairChannelConnectionsHandle>data.handle, count)
        if h == <c_api.MapChannelConnectionsHandle>0:
            raise MemoryError("Failed to create MapChannelConnections")
        cdef MapChannelConnections obj = <MapChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapChannelConnectionsHandle h
        try:
            h = c_api.MapChannelConnections_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapChannelConnectionsHandle>0:
            raise MemoryError("Failed to create MapChannelConnections")
        cdef MapChannelConnections obj = <MapChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapChannelConnections_insert_or_assign(self.handle, <c_api.ChannelHandle>key.handle, <c_api.ConnectionsHandle>value.handle)

    def insert(self, key, value):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapChannelConnections_insert(self.handle, <c_api.ChannelHandle>key.handle, <c_api.ConnectionsHandle>value.handle)

    def at(self, key):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.MapChannelConnections_at(self.handle, <c_api.ChannelHandle>key.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def erase(self, key):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapChannelConnections_erase(self.handle, <c_api.ChannelHandle>key.handle)

    def size(self):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapChannelConnections_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapChannelConnections_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapChannelConnections_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapChannelConnections_contains(self.handle, <c_api.ChannelHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListChannelHandle h_ret
        h_ret = c_api.MapChannelConnections_keys(self.handle)
        if h_ret == <c_api.ListChannelHandle>0:
            return None
        return ListChannel.from_capi(ListChannel, h_ret)

    def values(self):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionsHandle h_ret
        h_ret = c_api.MapChannelConnections_values(self.handle)
        if h_ret == <c_api.ListConnectionsHandle>0:
            return None
        return ListConnections.from_capi(ListConnections, h_ret)

    def items(self):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairChannelConnectionsHandle h_ret
        h_ret = c_api.MapChannelConnections_items(self.handle)
        if h_ret == <c_api.ListPairChannelConnectionsHandle>0:
            return None
        return ListPairChannelConnections.from_capi(ListPairChannelConnections, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapChannelConnections_equal(self.handle, <c_api.MapChannelConnectionsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapChannelConnections_not_equal(self.handle, <c_api.MapChannelConnectionsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapChannelConnections_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapChannelConnections _mapchannelconnections_from_capi(c_api.MapChannelConnectionsHandle h):
    cdef MapChannelConnections obj = <MapChannelConnections>MapChannelConnections.__new__(MapChannelConnections)
    obj.handle = h