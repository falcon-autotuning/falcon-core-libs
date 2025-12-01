cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class Time:
    def __cinit__(self):
        self.handle = <_c_api.TimeHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.TimeHandle>0 and self.owned:
            _c_api.Time_destroy(self.handle)
        self.handle = <_c_api.TimeHandle>0


cdef Time _time_from_capi(_c_api.TimeHandle h):
    if h == <_c_api.TimeHandle>0:
        return None
    cdef Time obj = Time.__new__(Time)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def now(cls, ):
        cdef _c_api.TimeHandle h
        h = _c_api.Time_create_now()
        if h == <_c_api.TimeHandle>0:
            raise MemoryError("Failed to create Time")
        cdef Time obj = <Time>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def at(cls, long long micro_seconds_since_epoch):
        cdef _c_api.TimeHandle h
        h = _c_api.Time_create_at(micro_seconds_since_epoch)
        if h == <_c_api.TimeHandle>0:
            raise MemoryError("Failed to create Time")
        cdef Time obj = <Time>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.TimeHandle h
        try:
            h = _c_api.Time_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.TimeHandle>0:
            raise MemoryError("Failed to create Time")
        cdef Time obj = <Time>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def micro_seconds_since_epoch(self, ):
        return _c_api.Time_micro_seconds_since_epoch(self.handle)

    def time(self, ):
        return _c_api.Time_time(self.handle)

    def to_string(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.Time_to_string(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def equal(self, Time b):
        return _c_api.Time_equal(self.handle, b.handle)

    def __eq__(self, Time b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Time b):
        return _c_api.Time_not_equal(self.handle, b.handle)

    def __ne__(self, Time b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
