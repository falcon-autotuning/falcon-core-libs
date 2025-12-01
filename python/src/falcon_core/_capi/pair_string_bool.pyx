cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class PairStringBool:
    def __cinit__(self):
        self.handle = <_c_api.PairStringBoolHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairStringBoolHandle>0 and self.owned:
            _c_api.PairStringBool_destroy(self.handle)
        self.handle = <_c_api.PairStringBoolHandle>0


cdef PairStringBool _pair_string_bool_from_capi(_c_api.PairStringBoolHandle h):
    if h == <_c_api.PairStringBoolHandle>0:
        return None
    cdef PairStringBool obj = PairStringBool.__new__(PairStringBool)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, str first, bool second):
        cdef bytes b_first = first.encode("utf-8")
        cdef StringHandle s_first = _c_api.String_create(b_first, len(b_first))
        cdef _c_api.PairStringBoolHandle h
        try:
            h = _c_api.PairStringBool_create(s_first, second)
        finally:
            _c_api.String_destroy(s_first)
        if h == <_c_api.PairStringBoolHandle>0:
            raise MemoryError("Failed to create PairStringBool")
        cdef PairStringBool obj = <PairStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairStringBoolHandle h
        try:
            h = _c_api.PairStringBool_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairStringBoolHandle>0:
            raise MemoryError("Failed to create PairStringBool")
        cdef PairStringBool obj = <PairStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.PairStringBool_first(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def second(self, ):
        return _c_api.PairStringBool_second(self.handle)

    def equal(self, PairStringBool b):
        return _c_api.PairStringBool_equal(self.handle, b.handle)

    def __eq__(self, PairStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairStringBool b):
        return _c_api.PairStringBool_not_equal(self.handle, b.handle)

    def __ne__(self, PairStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
