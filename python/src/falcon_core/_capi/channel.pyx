cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class Channel:
    def __cinit__(self):
        self.handle = <_c_api.ChannelHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ChannelHandle>0 and self.owned:
            _c_api.Channel_destroy(self.handle)
        self.handle = <_c_api.ChannelHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ChannelHandle h
        try:
            h = _c_api.Channel_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ChannelHandle>0:
            raise MemoryError("Failed to create Channel")
        cdef Channel obj = <Channel>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.ChannelHandle h
        try:
            h = _c_api.Channel_create(s_name)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.ChannelHandle>0:
            raise MemoryError("Failed to create Channel")
        cdef Channel obj = <Channel>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.ChannelHandle h_ret = _c_api.Channel_copy(self.handle)
        if h_ret == <_c_api.ChannelHandle>0:
            return None
        return _channel_from_capi(h_ret)

    def equal(self, Channel other):
        return _c_api.Channel_equal(self.handle, other.handle if other is not None else <_c_api.ChannelHandle>0)

    def __eq__(self, Channel other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Channel other):
        return _c_api.Channel_not_equal(self.handle, other.handle if other is not None else <_c_api.ChannelHandle>0)

    def __ne__(self, Channel other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Channel_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def name(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Channel_name(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef Channel _channel_from_capi(_c_api.ChannelHandle h, bint owned=True):
    if h == <_c_api.ChannelHandle>0:
        return None
    cdef Channel obj = Channel.__new__(Channel)
    obj.handle = h
    obj.owned = owned
    return obj
