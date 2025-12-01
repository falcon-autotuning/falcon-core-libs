cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class PairStringString:
    def __cinit__(self):
        self.handle = <_c_api.PairStringStringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairStringStringHandle>0 and self.owned:
            _c_api.PairStringString_destroy(self.handle)
        self.handle = <_c_api.PairStringStringHandle>0


cdef PairStringString _pair_string_string_from_capi(_c_api.PairStringStringHandle h):
    if h == <_c_api.PairStringStringHandle>0:
        return None
    cdef PairStringString obj = PairStringString.__new__(PairStringString)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, str first, str second):
        cdef bytes b_first = first.encode("utf-8")
        cdef StringHandle s_first = _c_api.String_create(b_first, len(b_first))
        cdef bytes b_second = second.encode("utf-8")
        cdef StringHandle s_second = _c_api.String_create(b_second, len(b_second))
        cdef _c_api.PairStringStringHandle h
        try:
            h = _c_api.PairStringString_create(s_first, s_second)
        finally:
            _c_api.String_destroy(s_first)
            _c_api.String_destroy(s_second)
        if h == <_c_api.PairStringStringHandle>0:
            raise MemoryError("Failed to create PairStringString")
        cdef PairStringString obj = <PairStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairStringStringHandle h
        try:
            h = _c_api.PairStringString_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairStringStringHandle>0:
            raise MemoryError("Failed to create PairStringString")
        cdef PairStringString obj = <PairStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.PairStringString_first(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def second(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.PairStringString_second(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def equal(self, PairStringString b):
        return _c_api.PairStringString_equal(self.handle, b.handle)

    def __eq__(self, PairStringString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairStringString b):
        return _c_api.PairStringString_not_equal(self.handle, b.handle)

    def __ne__(self, PairStringString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
