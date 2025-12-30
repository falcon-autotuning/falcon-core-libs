cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class StandardRequest:
    def __cinit__(self):
        self.handle = <_c_api.StandardRequestHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.StandardRequestHandle>0 and self.owned:
            _c_api.StandardRequest_destroy(self.handle)
        self.handle = <_c_api.StandardRequestHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.StandardRequestHandle h
        try:
            h = _c_api.StandardRequest_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.StandardRequestHandle>0:
            raise MemoryError("Failed to create StandardRequest")
        cdef StandardRequest obj = <StandardRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, str message):
        cdef bytes b_message = message.encode("utf-8")
        cdef _c_api.StringHandle s_message = _c_api.String_create(b_message, len(b_message))
        cdef _c_api.StandardRequestHandle h
        try:
            h = _c_api.StandardRequest_create(s_message)
        finally:
            _c_api.String_destroy(s_message)
        if h == <_c_api.StandardRequestHandle>0:
            raise MemoryError("Failed to create StandardRequest")
        cdef StandardRequest obj = <StandardRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.StandardRequestHandle h_ret = _c_api.StandardRequest_copy(self.handle)
        if h_ret == <_c_api.StandardRequestHandle>0:
            return None
        return _standard_request_from_capi(h_ret)

    def equal(self, StandardRequest other):
        return _c_api.StandardRequest_equal(self.handle, other.handle if other is not None else <_c_api.StandardRequestHandle>0)

    def __eq__(self, StandardRequest other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, StandardRequest other):
        return _c_api.StandardRequest_not_equal(self.handle, other.handle if other is not None else <_c_api.StandardRequestHandle>0)

    def __ne__(self, StandardRequest other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.StandardRequest_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def message(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.StandardRequest_message(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef StandardRequest _standard_request_from_capi(_c_api.StandardRequestHandle h, bint owned=True):
    if h == <_c_api.StandardRequestHandle>0:
        return None
    cdef StandardRequest obj = StandardRequest.__new__(StandardRequest)
    obj.handle = h
    obj.owned = owned
    return obj
