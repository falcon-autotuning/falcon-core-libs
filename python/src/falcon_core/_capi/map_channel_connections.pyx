cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .channel cimport Channel, _channel_from_capi
from .connections cimport Connections, _connections_from_capi
from .list_channel cimport ListChannel, _list_channel_from_capi
from .list_connections cimport ListConnections, _list_connections_from_capi
from .list_pair_channel_connections cimport ListPairChannelConnections, _list_pair_channel_connections_from_capi
from .pair_channel_connections cimport PairChannelConnections, _pair_channel_connections_from_capi

cdef class MapChannelConnections:
    def __cinit__(self):
        self.handle = <_c_api.MapChannelConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapChannelConnectionsHandle>0 and self.owned:
            _c_api.MapChannelConnections_destroy(self.handle)
        self.handle = <_c_api.MapChannelConnectionsHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapChannelConnectionsHandle h
        h = _c_api.MapChannelConnections_create_empty()
        if h == <_c_api.MapChannelConnectionsHandle>0:
            raise MemoryError("Failed to create MapChannelConnections")
        cdef MapChannelConnections obj = <MapChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.MapChannelConnectionsHandle h
        h = _c_api.MapChannelConnections_create(<_c_api.PairChannelConnectionsHandle*>&data[0], count)
        if h == <_c_api.MapChannelConnectionsHandle>0:
            raise MemoryError("Failed to create MapChannelConnections")
        cdef MapChannelConnections obj = <MapChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def copy(self, ):
        cdef _c_api.MapChannelConnectionsHandle h_ret = _c_api.MapChannelConnections_copy(self.handle)
        if h_ret == <_c_api.MapChannelConnectionsHandle>0:
            return None
        return _map_channel_connections_from_capi(h_ret, owned=(h_ret != <_c_api.MapChannelConnectionsHandle>self.handle))

    def insert_or_assign(self, Channel key, Connections value):
        _c_api.MapChannelConnections_insert_or_assign(self.handle, key.handle if key is not None else <_c_api.ChannelHandle>0, value.handle if value is not None else <_c_api.ConnectionsHandle>0)

    def insert(self, Channel key, Connections value):
        _c_api.MapChannelConnections_insert(self.handle, key.handle if key is not None else <_c_api.ChannelHandle>0, value.handle if value is not None else <_c_api.ConnectionsHandle>0)

    def at(self, Channel key):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.MapChannelConnections_at(self.handle, key.handle if key is not None else <_c_api.ChannelHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def erase(self, Channel key):
        _c_api.MapChannelConnections_erase(self.handle, key.handle if key is not None else <_c_api.ChannelHandle>0)

    def size(self, ):
        return _c_api.MapChannelConnections_size(self.handle)

    def empty(self, ):
        return _c_api.MapChannelConnections_empty(self.handle)

    def clear(self, ):
        _c_api.MapChannelConnections_clear(self.handle)

    def contains(self, Channel key):
        return _c_api.MapChannelConnections_contains(self.handle, key.handle if key is not None else <_c_api.ChannelHandle>0)

    def keys(self, ):
        cdef _c_api.ListChannelHandle h_ret = _c_api.MapChannelConnections_keys(self.handle)
        if h_ret == <_c_api.ListChannelHandle>0:
            return None
        return _list_channel_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListConnectionsHandle h_ret = _c_api.MapChannelConnections_values(self.handle)
        if h_ret == <_c_api.ListConnectionsHandle>0:
            return None
        return _list_connections_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairChannelConnectionsHandle h_ret = _c_api.MapChannelConnections_items(self.handle)
        if h_ret == <_c_api.ListPairChannelConnectionsHandle>0:
            return None
        return _list_pair_channel_connections_from_capi(h_ret)

    def equal(self, MapChannelConnections other):
        return _c_api.MapChannelConnections_equal(self.handle, other.handle if other is not None else <_c_api.MapChannelConnectionsHandle>0)

    def __eq__(self, MapChannelConnections other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, MapChannelConnections other):
        return _c_api.MapChannelConnections_not_equal(self.handle, other.handle if other is not None else <_c_api.MapChannelConnectionsHandle>0)

    def __ne__(self, MapChannelConnections other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.MapChannelConnections_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

cdef MapChannelConnections _map_channel_connections_from_capi(_c_api.MapChannelConnectionsHandle h, bint owned=True):
    if h == <_c_api.MapChannelConnectionsHandle>0:
        return None
    cdef MapChannelConnections obj = MapChannelConnections.__new__(MapChannelConnections)
    obj.handle = h
    obj.owned = owned
    return obj
