cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class Channel:
    def __cinit__(self):
        self.handle = <_c_api.ChannelHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ChannelHandle>0 and self.owned:
            _c_api.Channel_destroy(self.handle)
        self.handle = <_c_api.ChannelHandle>0


cdef Channel _channel_from_capi(_c_api.ChannelHandle h):
    if h == <_c_api.ChannelHandle>0:
        return None
    cdef Channel obj = Channel.__new__(Channel)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef StringHandle s_name = _c_api.String_create(b_name, len(b_name))
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

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def name(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.Channel_name(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def equal(self, Channel b):
        return _c_api.Channel_equal(self.handle, b.handle)

    def __eq__(self, Channel b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Channel b):
        return _c_api.Channel_not_equal(self.handle, b.handle)

    def __ne__(self, Channel b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
