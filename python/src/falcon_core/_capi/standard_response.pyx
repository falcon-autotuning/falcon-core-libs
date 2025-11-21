# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class StandardResponse:
    cdef c_api.StandardResponseHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.StandardResponseHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.StandardResponseHandle>0 and self.owned:
            c_api.StandardResponse_destroy(self.handle)
        self.handle = <c_api.StandardResponseHandle>0

    cdef StandardResponse from_capi(cls, c_api.StandardResponseHandle h):
        cdef StandardResponse obj = <StandardResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, message):
        message_bytes = message.encode("utf-8")
        cdef const char* raw_message = message_bytes
        cdef size_t len_message = len(message_bytes)
        cdef c_api.StringHandle s_message = c_api.String_create(raw_message, len_message)
        cdef c_api.StandardResponseHandle h
        try:
            h = c_api.StandardResponse_create(s_message)
        finally:
            c_api.String_destroy(s_message)
        if h == <c_api.StandardResponseHandle>0:
            raise MemoryError("Failed to create StandardResponse")
        cdef StandardResponse obj = <StandardResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.StandardResponseHandle h
        try:
            h = c_api.StandardResponse_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.StandardResponseHandle>0:
            raise MemoryError("Failed to create StandardResponse")
        cdef StandardResponse obj = <StandardResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def message(self):
        if self.handle == <c_api.StandardResponseHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.StandardResponse_message(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def equal(self, other):
        if self.handle == <c_api.StandardResponseHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.StandardResponse_equal(self.handle, <c_api.StandardResponseHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.StandardResponseHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.StandardResponse_not_equal(self.handle, <c_api.StandardResponseHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.StandardResponseHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.StandardResponse_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef StandardResponse _standardresponse_from_capi(c_api.StandardResponseHandle h):
    cdef StandardResponse obj = <StandardResponse>StandardResponse.__new__(StandardResponse)
    obj.handle = h