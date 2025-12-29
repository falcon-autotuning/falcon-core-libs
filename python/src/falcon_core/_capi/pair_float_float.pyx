cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class PairFloatFloat:
    def __cinit__(self):
        self.handle = <_c_api.PairFloatFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairFloatFloatHandle>0 and self.owned:
            _c_api.PairFloatFloat_destroy(self.handle)
        self.handle = <_c_api.PairFloatFloatHandle>0


    @classmethod
    def new(cls, float first, float second):
        cdef _c_api.PairFloatFloatHandle h
        h = _c_api.PairFloatFloat_create(first, second)
        if h == <_c_api.PairFloatFloatHandle>0:
            raise MemoryError("Failed to create PairFloatFloat")
        cdef PairFloatFloat obj = <PairFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairFloatFloatHandle h
        try:
            h = _c_api.PairFloatFloat_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairFloatFloatHandle>0:
            raise MemoryError("Failed to create PairFloatFloat")
        cdef PairFloatFloat obj = <PairFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        return _c_api.PairFloatFloat_first(self.handle)

    def second(self, ):
        return _c_api.PairFloatFloat_second(self.handle)

    def equal(self, PairFloatFloat b):
        return _c_api.PairFloatFloat_equal(self.handle, b.handle if b is not None else <_c_api.PairFloatFloatHandle>0)

    def __eq__(self, PairFloatFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairFloatFloat b):
        return _c_api.PairFloatFloat_not_equal(self.handle, b.handle if b is not None else <_c_api.PairFloatFloatHandle>0)

    def __ne__(self, PairFloatFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PairFloatFloat_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef PairFloatFloat _pair_float_float_from_capi(_c_api.PairFloatFloatHandle h, bint owned=True):
    if h == <_c_api.PairFloatFloatHandle>0:
        return None
    cdef PairFloatFloat obj = PairFloatFloat.__new__(PairFloatFloat)
    obj.handle = h
    obj.owned = owned
    return obj
