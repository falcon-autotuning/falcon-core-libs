cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class PairIntInt:
    def __cinit__(self):
        self.handle = <_c_api.PairIntIntHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairIntIntHandle>0 and self.owned:
            _c_api.PairIntInt_destroy(self.handle)
        self.handle = <_c_api.PairIntIntHandle>0


cdef PairIntInt _pair_int_int_from_capi(_c_api.PairIntIntHandle h):
    if h == <_c_api.PairIntIntHandle>0:
        return None
    cdef PairIntInt obj = PairIntInt.__new__(PairIntInt)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, int first, int second):
        cdef _c_api.PairIntIntHandle h
        h = _c_api.PairIntInt_create(first, second)
        if h == <_c_api.PairIntIntHandle>0:
            raise MemoryError("Failed to create PairIntInt")
        cdef PairIntInt obj = <PairIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairIntIntHandle h
        try:
            h = _c_api.PairIntInt_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairIntIntHandle>0:
            raise MemoryError("Failed to create PairIntInt")
        cdef PairIntInt obj = <PairIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        return _c_api.PairIntInt_first(self.handle)

    def second(self, ):
        return _c_api.PairIntInt_second(self.handle)

    def equal(self, PairIntInt b):
        return _c_api.PairIntInt_equal(self.handle, b.handle)

    def __eq__(self, PairIntInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairIntInt b):
        return _c_api.PairIntInt_not_equal(self.handle, b.handle)

    def __ne__(self, PairIntInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
