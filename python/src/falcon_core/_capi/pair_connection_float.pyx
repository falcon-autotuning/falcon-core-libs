cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection

cdef class PairConnectionFloat:
    def __cinit__(self):
        self.handle = <_c_api.PairConnectionFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairConnectionFloatHandle>0 and self.owned:
            _c_api.PairConnectionFloat_destroy(self.handle)
        self.handle = <_c_api.PairConnectionFloatHandle>0


cdef PairConnectionFloat _pair_connection_float_from_capi(_c_api.PairConnectionFloatHandle h):
    if h == <_c_api.PairConnectionFloatHandle>0:
        return None
    cdef PairConnectionFloat obj = PairConnectionFloat.__new__(PairConnectionFloat)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, Connection first, float second):
        cdef _c_api.PairConnectionFloatHandle h
        h = _c_api.PairConnectionFloat_create(first.handle, second)
        if h == <_c_api.PairConnectionFloatHandle>0:
            raise MemoryError("Failed to create PairConnectionFloat")
        cdef PairConnectionFloat obj = <PairConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairConnectionFloatHandle h
        try:
            h = _c_api.PairConnectionFloat_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairConnectionFloatHandle>0:
            raise MemoryError("Failed to create PairConnectionFloat")
        cdef PairConnectionFloat obj = <PairConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.PairConnectionFloat_first(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def second(self, ):
        return _c_api.PairConnectionFloat_second(self.handle)

    def equal(self, PairConnectionFloat b):
        return _c_api.PairConnectionFloat_equal(self.handle, b.handle)

    def __eq__(self, PairConnectionFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairConnectionFloat b):
        return _c_api.PairConnectionFloat_not_equal(self.handle, b.handle)

    def __ne__(self, PairConnectionFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
