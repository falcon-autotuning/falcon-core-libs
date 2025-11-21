# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .channel cimport Channel
from .connections cimport Connections

cdef class PairChannelConnections:
    cdef c_api.PairChannelConnectionsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairChannelConnectionsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairChannelConnectionsHandle>0 and self.owned:
            c_api.PairChannelConnections_destroy(self.handle)
        self.handle = <c_api.PairChannelConnectionsHandle>0

    cdef PairChannelConnections from_capi(cls, c_api.PairChannelConnectionsHandle h):
        cdef PairChannelConnections obj = <PairChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, first, second):
        cdef c_api.PairChannelConnectionsHandle h
        h = c_api.PairChannelConnections_create(<c_api.ChannelHandle>first.handle, <c_api.ConnectionsHandle>second.handle)
        if h == <c_api.PairChannelConnectionsHandle>0:
            raise MemoryError("Failed to create PairChannelConnections")
        cdef PairChannelConnections obj = <PairChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PairChannelConnectionsHandle h
        try:
            h = c_api.PairChannelConnections_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PairChannelConnectionsHandle>0:
            raise MemoryError("Failed to create PairChannelConnections")
        cdef PairChannelConnections obj = <PairChannelConnections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self):
        if self.handle == <c_api.PairChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ChannelHandle h_ret
        h_ret = c_api.PairChannelConnections_first(self.handle)
        if h_ret == <c_api.ChannelHandle>0:
            return None
        return Channel.from_capi(Channel, h_ret)

    def second(self):
        if self.handle == <c_api.PairChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.PairChannelConnections_second(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def equal(self, b):
        if self.handle == <c_api.PairChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairChannelConnections_equal(self.handle, <c_api.PairChannelConnectionsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PairChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairChannelConnections_not_equal(self.handle, <c_api.PairChannelConnectionsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PairChannelConnectionsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairChannelConnections_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PairChannelConnections _pairchannelconnections_from_capi(c_api.PairChannelConnectionsHandle h):
    cdef PairChannelConnections obj = <PairChannelConnections>PairChannelConnections.__new__(PairChannelConnections)
    obj.handle = h