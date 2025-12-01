cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport channel
from . cimport connections
from . cimport list_channel
from . cimport list_connections
from . cimport list_pair_channel_connections
from . cimport pair_channel_connections

cdef class MapChannelConnections:
    def __cinit__(self):
        self.handle = <_c_api.MapChannelConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapChannelConnectionsHandle>0 and self.owned:
            _c_api.MapChannelConnections_destroy(self.handle)
        self.handle = <_c_api.MapChannelConnectionsHandle>0


cdef MapChannelConnections _map_channel_connections_from_capi(_c_api.MapChannelConnectionsHandle h):
    if h == <_c_api.MapChannelConnectionsHandle>0:
        return None
    cdef MapChannelConnections obj = MapChannelConnections.__new__(MapChannelConnections)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.MapChannelConnectionsHandle h
        h = _c_api.MapChannelConnections_create_empty()
        if h == <_c_api.MapChannelConnectionsHandle>0:
            raise MemoryError("Failed to create MapChannelConnections")
        cdef MapChannelConnections obj = <MapChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairChannelConnections data, size_t count):
        cdef _c_api.MapChannelConnectionsHandle h
        h = _c_api.MapChannelConnections_create(data.handle, count)
        if h == <_c_api.MapChannelConnectionsHandle>0:
            raise MemoryError("Failed to create MapChannelConnections")
        cdef MapChannelConnections obj = <MapChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapChannelConnectionsHandle h
        try:
            h = _c_api.MapChannelConnections_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapChannelConnectionsHandle>0:
            raise MemoryError("Failed to create MapChannelConnections")
        cdef MapChannelConnections obj = <MapChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, Channel key, Connections value):
        _c_api.MapChannelConnections_insert_or_assign(self.handle, key.handle, value.handle)

    def insert(self, Channel key, Connections value):
        _c_api.MapChannelConnections_insert(self.handle, key.handle, value.handle)

    def at(self, Channel key):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.MapChannelConnections_at(self.handle, key.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def erase(self, Channel key):
        _c_api.MapChannelConnections_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.MapChannelConnections_size(self.handle)

    def empty(self, ):
        return _c_api.MapChannelConnections_empty(self.handle)

    def clear(self, ):
        _c_api.MapChannelConnections_clear(self.handle)

    def contains(self, Channel key):
        return _c_api.MapChannelConnections_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListChannelHandle h_ret = _c_api.MapChannelConnections_keys(self.handle)
        if h_ret == <_c_api.ListChannelHandle>0:
            return None
        return list_channel._list_channel_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListConnectionsHandle h_ret = _c_api.MapChannelConnections_values(self.handle)
        if h_ret == <_c_api.ListConnectionsHandle>0:
            return None
        return list_connections._list_connections_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairChannelConnectionsHandle h_ret = _c_api.MapChannelConnections_items(self.handle)
        if h_ret == <_c_api.ListPairChannelConnectionsHandle>0:
            return None
        return list_pair_channel_connections._list_pair_channel_connections_from_capi(h_ret)

    def equal(self, MapChannelConnections b):
        return _c_api.MapChannelConnections_equal(self.handle, b.handle)

    def __eq__(self, MapChannelConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapChannelConnections b):
        return _c_api.MapChannelConnections_not_equal(self.handle, b.handle)

    def __ne__(self, MapChannelConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
