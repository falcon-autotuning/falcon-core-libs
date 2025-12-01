cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport channel
from . cimport connections

cdef class PairChannelConnections:
    def __cinit__(self):
        self.handle = <_c_api.PairChannelConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairChannelConnectionsHandle>0 and self.owned:
            _c_api.PairChannelConnections_destroy(self.handle)
        self.handle = <_c_api.PairChannelConnectionsHandle>0


cdef PairChannelConnections _pair_channel_connections_from_capi(_c_api.PairChannelConnectionsHandle h):
    if h == <_c_api.PairChannelConnectionsHandle>0:
        return None
    cdef PairChannelConnections obj = PairChannelConnections.__new__(PairChannelConnections)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, Channel first, Connections second):
        cdef _c_api.PairChannelConnectionsHandle h
        h = _c_api.PairChannelConnections_create(first.handle, second.handle)
        if h == <_c_api.PairChannelConnectionsHandle>0:
            raise MemoryError("Failed to create PairChannelConnections")
        cdef PairChannelConnections obj = <PairChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairChannelConnectionsHandle h
        try:
            h = _c_api.PairChannelConnections_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairChannelConnectionsHandle>0:
            raise MemoryError("Failed to create PairChannelConnections")
        cdef PairChannelConnections obj = <PairChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.ChannelHandle h_ret = _c_api.PairChannelConnections_first(self.handle)
        if h_ret == <_c_api.ChannelHandle>0:
            return None
        return channel._channel_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.PairChannelConnections_second(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def equal(self, PairChannelConnections b):
        return _c_api.PairChannelConnections_equal(self.handle, b.handle)

    def __eq__(self, PairChannelConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairChannelConnections b):
        return _c_api.PairChannelConnections_not_equal(self.handle, b.handle)

    def __ne__(self, PairChannelConnections b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
