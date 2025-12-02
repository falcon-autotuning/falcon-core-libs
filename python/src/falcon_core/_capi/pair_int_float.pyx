cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class PairIntFloat:
    def __cinit__(self):
        self.handle = <_c_api.PairIntFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairIntFloatHandle>0 and self.owned:
            _c_api.PairIntFloat_destroy(self.handle)
        self.handle = <_c_api.PairIntFloatHandle>0


cdef PairIntFloat _pair_int_float_from_capi(_c_api.PairIntFloatHandle h):
    if h == <_c_api.PairIntFloatHandle>0:
        return None
    cdef PairIntFloat obj = PairIntFloat.__new__(PairIntFloat)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, int first, float second):
        cdef _c_api.PairIntFloatHandle h
        h = _c_api.PairIntFloat_create(first, second)
        if h == <_c_api.PairIntFloatHandle>0:
            raise MemoryError("Failed to create PairIntFloat")
        cdef PairIntFloat obj = <PairIntFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairIntFloatHandle h
        try:
            h = _c_api.PairIntFloat_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairIntFloatHandle>0:
            raise MemoryError("Failed to create PairIntFloat")
        cdef PairIntFloat obj = <PairIntFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        return _c_api.PairIntFloat_first(self.handle)

    def second(self, ):
        return _c_api.PairIntFloat_second(self.handle)

    def equal(self, PairIntFloat b):
        return _c_api.PairIntFloat_equal(self.handle, b.handle)

    def __eq__(self, PairIntFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairIntFloat b):
        return _c_api.PairIntFloat_not_equal(self.handle, b.handle)

    def __ne__(self, PairIntFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
