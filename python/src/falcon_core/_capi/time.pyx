# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class Time:
    cdef c_api.TimeHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.TimeHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.TimeHandle>0 and self.owned:
            c_api.Time_destroy(self.handle)
        self.handle = <c_api.TimeHandle>0

    cdef Time from_capi(cls, c_api.TimeHandle h):
        cdef Time obj = <Time>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_now(cls, ):
        cdef c_api.TimeHandle h
        h = c_api.Time_create_now()
        if h == <c_api.TimeHandle>0:
            raise MemoryError("Failed to create Time")
        cdef Time obj = <Time>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_at(cls, micro_seconds_since_epoch):
        cdef c_api.TimeHandle h
        h = c_api.Time_create_at(micro_seconds_since_epoch)
        if h == <c_api.TimeHandle>0:
            raise MemoryError("Failed to create Time")
        cdef Time obj = <Time>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.TimeHandle h
        try:
            h = c_api.Time_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.TimeHandle>0:
            raise MemoryError("Failed to create Time")
        cdef Time obj = <Time>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def micro_seconds_since_epoch(self):
        if self.handle == <c_api.TimeHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Time_micro_seconds_since_epoch(self.handle)

    def time(self):
        if self.handle == <c_api.TimeHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Time_time(self.handle)

    def to_string(self):
        if self.handle == <c_api.TimeHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Time_to_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def equal(self, b):
        if self.handle == <c_api.TimeHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Time_equal(self.handle, <c_api.TimeHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.TimeHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Time_not_equal(self.handle, <c_api.TimeHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.TimeHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Time_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Time _time_from_capi(c_api.TimeHandle h):
    cdef Time obj = <Time>Time.__new__(Time)
    obj.handle = h