cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .channel cimport Channel, _channel_from_capi
from .list_channel cimport ListChannel, _list_channel_from_capi
from .list_string cimport ListString, _list_string_from_capi

cdef class Channels:
    def __cinit__(self):
        self.handle = <_c_api.ChannelsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ChannelsHandle>0 and self.owned:
            _c_api.Channels_destroy(self.handle)
        self.handle = <_c_api.ChannelsHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ChannelsHandle h
        h = _c_api.Channels_create_empty()
        if h == <_c_api.ChannelsHandle>0:
            raise MemoryError("Failed to create Channels")
        cdef Channels obj = <Channels>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListChannel items):
        cdef _c_api.ChannelsHandle h
        h = _c_api.Channels_create(items.handle if items is not None else <_c_api.ListChannelHandle>0)
        if h == <_c_api.ChannelsHandle>0:
            raise MemoryError("Failed to create Channels")
        cdef Channels obj = <Channels>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ChannelsHandle h
        try:
            h = _c_api.Channels_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ChannelsHandle>0:
            raise MemoryError("Failed to create Channels")
        cdef Channels obj = <Channels>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def intersection(self, Channels other):
        cdef _c_api.ChannelsHandle h_ret = _c_api.Channels_intersection(self.handle, other.handle if other is not None else <_c_api.ChannelsHandle>0)
        if h_ret == <_c_api.ChannelsHandle>0:
            return None
        return _channels_from_capi(h_ret)

    def push_back(self, Channel value):
        _c_api.Channels_push_back(self.handle, value.handle if value is not None else <_c_api.ChannelHandle>0)

    def size(self, ):
        return _c_api.Channels_size(self.handle)

    def empty(self, ):
        return _c_api.Channels_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.Channels_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.Channels_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ChannelHandle h_ret = _c_api.Channels_at(self.handle, idx)
        if h_ret == <_c_api.ChannelHandle>0:
            return None
        return _channel_from_capi(h_ret, owned=False)

    def items(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.Channels_items(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def contains(self, Channel value):
        return _c_api.Channels_contains(self.handle, value.handle if value is not None else <_c_api.ChannelHandle>0)

    def index(self, Channel value):
        return _c_api.Channels_index(self.handle, value.handle if value is not None else <_c_api.ChannelHandle>0)

    def equal(self, Channels b):
        return _c_api.Channels_equal(self.handle, b.handle if b is not None else <_c_api.ChannelsHandle>0)

    def __eq__(self, Channels b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Channels b):
        return _c_api.Channels_not_equal(self.handle, b.handle if b is not None else <_c_api.ChannelsHandle>0)

    def __ne__(self, Channels b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Channels_to_json_string(self.handle)
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

    def append(self, value):
        self.push_back(value)

    @classmethod
    def from_list(cls, items):
        cdef Channels obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef Channels _channels_from_capi(_c_api.ChannelsHandle h, bint owned=True):
    if h == <_c_api.ChannelsHandle>0:
        return None
    cdef Channels obj = Channels.__new__(Channels)
    obj.handle = h
    obj.owned = owned
    return obj
