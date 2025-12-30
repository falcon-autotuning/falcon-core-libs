cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class PairStringString:
    def __cinit__(self):
        self.handle = <_c_api.PairStringStringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairStringStringHandle>0 and self.owned:
            _c_api.PairStringString_destroy(self.handle)
        self.handle = <_c_api.PairStringStringHandle>0


    @classmethod
    def new(cls, str first, str second):
        cdef bytes b_first = first.encode("utf-8")
        cdef _c_api.StringHandle s_first = _c_api.String_create(b_first, len(b_first))
        cdef bytes b_second = second.encode("utf-8")
        cdef _c_api.StringHandle s_second = _c_api.String_create(b_second, len(b_second))
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
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def copy(self, ):
        cdef _c_api.PairStringStringHandle h_ret = _c_api.PairStringString_copy(self.handle)
        if h_ret == <_c_api.PairStringStringHandle>0:
            return None
        return _pair_string_string_from_capi(h_ret, owned=(h_ret != <_c_api.PairStringStringHandle>self.handle))

    def first(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PairStringString_first(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def second(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PairStringString_second(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def equal(self, PairStringString other):
        return _c_api.PairStringString_equal(self.handle, other.handle if other is not None else <_c_api.PairStringStringHandle>0)

    def __eq__(self, PairStringString other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, PairStringString other):
        return _c_api.PairStringString_not_equal(self.handle, other.handle if other is not None else <_c_api.PairStringStringHandle>0)

    def __ne__(self, PairStringString other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PairStringString_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef PairStringString _pair_string_string_from_capi(_c_api.PairStringStringHandle h, bint owned=True):
    if h == <_c_api.PairStringStringHandle>0:
        return None
    cdef PairStringString obj = PairStringString.__new__(PairStringString)
    obj.handle = h
    obj.owned = owned
    return obj
