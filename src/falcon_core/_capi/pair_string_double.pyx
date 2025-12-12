cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class PairStringDouble:
    def __cinit__(self):
        self.handle = <_c_api.PairStringDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairStringDoubleHandle>0 and self.owned:
            _c_api.PairStringDouble_destroy(self.handle)
        self.handle = <_c_api.PairStringDoubleHandle>0


cdef PairStringDouble _pair_string_double_from_capi(_c_api.PairStringDoubleHandle h):
    if h == <_c_api.PairStringDoubleHandle>0:
        return None
    cdef PairStringDouble obj = PairStringDouble.__new__(PairStringDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, str first, double second):
        cdef bytes b_first = first.encode("utf-8")
        cdef StringHandle s_first = _c_api.String_create(b_first, len(b_first))
        cdef _c_api.PairStringDoubleHandle h
        try:
            h = _c_api.PairStringDouble_create(s_first, second)
        finally:
            _c_api.String_destroy(s_first)
        if h == <_c_api.PairStringDoubleHandle>0:
            raise MemoryError("Failed to create PairStringDouble")
        cdef PairStringDouble obj = <PairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairStringDoubleHandle h
        try:
            h = _c_api.PairStringDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairStringDoubleHandle>0:
            raise MemoryError("Failed to create PairStringDouble")
        cdef PairStringDouble obj = <PairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.PairStringDouble_first(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def second(self, ):
        return _c_api.PairStringDouble_second(self.handle)

    def equal(self, PairStringDouble b):
        return _c_api.PairStringDouble_equal(self.handle, b.handle)

    def __eq__(self, PairStringDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairStringDouble b):
        return _c_api.PairStringDouble_not_equal(self.handle, b.handle)

    def __ne__(self, PairStringDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
