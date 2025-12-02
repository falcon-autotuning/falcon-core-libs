cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class PairFloatFloat:
    def __cinit__(self):
        self.handle = <_c_api.PairFloatFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairFloatFloatHandle>0 and self.owned:
            _c_api.PairFloatFloat_destroy(self.handle)
        self.handle = <_c_api.PairFloatFloatHandle>0


cdef PairFloatFloat _pair_float_float_from_capi(_c_api.PairFloatFloatHandle h):
    if h == <_c_api.PairFloatFloatHandle>0:
        return None
    cdef PairFloatFloat obj = PairFloatFloat.__new__(PairFloatFloat)
    obj.handle = h
    obj.owned = True
    return obj

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
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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
        return _c_api.PairFloatFloat_equal(self.handle, b.handle)

    def __eq__(self, PairFloatFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairFloatFloat b):
        return _c_api.PairFloatFloat_not_equal(self.handle, b.handle)

    def __ne__(self, PairFloatFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
