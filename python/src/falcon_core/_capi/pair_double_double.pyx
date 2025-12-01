cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class PairDoubleDouble:
    def __cinit__(self):
        self.handle = <_c_api.PairDoubleDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairDoubleDoubleHandle>0 and self.owned:
            _c_api.PairDoubleDouble_destroy(self.handle)
        self.handle = <_c_api.PairDoubleDoubleHandle>0


cdef PairDoubleDouble _pair_double_double_from_capi(_c_api.PairDoubleDoubleHandle h):
    if h == <_c_api.PairDoubleDoubleHandle>0:
        return None
    cdef PairDoubleDouble obj = PairDoubleDouble.__new__(PairDoubleDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, double first, double second):
        cdef _c_api.PairDoubleDoubleHandle h
        h = _c_api.PairDoubleDouble_create(first, second)
        if h == <_c_api.PairDoubleDoubleHandle>0:
            raise MemoryError("Failed to create PairDoubleDouble")
        cdef PairDoubleDouble obj = <PairDoubleDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairDoubleDoubleHandle h
        try:
            h = _c_api.PairDoubleDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairDoubleDoubleHandle>0:
            raise MemoryError("Failed to create PairDoubleDouble")
        cdef PairDoubleDouble obj = <PairDoubleDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        return _c_api.PairDoubleDouble_first(self.handle)

    def second(self, ):
        return _c_api.PairDoubleDouble_second(self.handle)

    def equal(self, PairDoubleDouble b):
        return _c_api.PairDoubleDouble_equal(self.handle, b.handle)

    def __eq__(self, PairDoubleDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairDoubleDouble b):
        return _c_api.PairDoubleDouble_not_equal(self.handle, b.handle)

    def __ne__(self, PairDoubleDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
