# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .channel cimport Channel
from .list_channel cimport ListChannel
from .list_string cimport ListString

cdef class Channels:
    cdef c_api.ChannelsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ChannelsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ChannelsHandle>0 and self.owned:
            c_api.Channels_destroy(self.handle)
        self.handle = <c_api.ChannelsHandle>0

    cdef Channels from_capi(cls, c_api.ChannelsHandle h):
        cdef Channels obj = <Channels>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ChannelsHandle h
        h = c_api.Channels_create_empty()
        if h == <c_api.ChannelsHandle>0:
            raise MemoryError("Failed to create Channels")
        cdef Channels obj = <Channels>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, items):
        cdef c_api.ChannelsHandle h
        h = c_api.Channels_create(<c_api.ListChannelHandle>items.handle)
        if h == <c_api.ChannelsHandle>0:
            raise MemoryError("Failed to create Channels")
        cdef Channels obj = <Channels>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ChannelsHandle h
        try:
            h = c_api.Channels_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ChannelsHandle>0:
            raise MemoryError("Failed to create Channels")
        cdef Channels obj = <Channels>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def intersection(self, other):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ChannelsHandle h_ret
        h_ret = c_api.Channels_intersection(self.handle, <c_api.ChannelsHandle>other.handle)
        if h_ret == <c_api.ChannelsHandle>0:
            return None
        return Channels.from_capi(Channels, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Channels_push_back(self.handle, <c_api.ChannelHandle>value.handle)

    def size(self):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Channels_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Channels_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Channels_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Channels_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ChannelHandle h_ret
        h_ret = c_api.Channels_at(self.handle, idx)
        if h_ret == <c_api.ChannelHandle>0:
            return None
        return Channel.from_capi(Channel, h_ret)

    def items(self):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.Channels_items(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def contains(self, value):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Channels_contains(self.handle, <c_api.ChannelHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Channels_index(self.handle, <c_api.ChannelHandle>value.handle)

    def equal(self, b):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Channels_equal(self.handle, <c_api.ChannelsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Channels_not_equal(self.handle, <c_api.ChannelsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ChannelsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Channels_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Channels _channels_from_capi(c_api.ChannelsHandle h):
    cdef Channels obj = <Channels>Channels.__new__(Channels)
    obj.handle = h