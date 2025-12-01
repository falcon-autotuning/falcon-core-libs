cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport interpretation_context

cdef class PairInterpretationContextString:
    def __cinit__(self):
        self.handle = <_c_api.PairInterpretationContextStringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairInterpretationContextStringHandle>0 and self.owned:
            _c_api.PairInterpretationContextString_destroy(self.handle)
        self.handle = <_c_api.PairInterpretationContextStringHandle>0


cdef PairInterpretationContextString _pair_interpretation_context_string_from_capi(_c_api.PairInterpretationContextStringHandle h):
    if h == <_c_api.PairInterpretationContextStringHandle>0:
        return None
    cdef PairInterpretationContextString obj = PairInterpretationContextString.__new__(PairInterpretationContextString)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, InterpretationContext first, str second):
        cdef bytes b_second = second.encode("utf-8")
        cdef StringHandle s_second = _c_api.String_create(b_second, len(b_second))
        cdef _c_api.PairInterpretationContextStringHandle h
        try:
            h = _c_api.PairInterpretationContextString_create(first.handle, s_second)
        finally:
            _c_api.String_destroy(s_second)
        if h == <_c_api.PairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextString")
        cdef PairInterpretationContextString obj = <PairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairInterpretationContextStringHandle h
        try:
            h = _c_api.PairInterpretationContextString_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextString")
        cdef PairInterpretationContextString obj = <PairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.InterpretationContextHandle h_ret = _c_api.PairInterpretationContextString_first(self.handle)
        if h_ret == <_c_api.InterpretationContextHandle>0:
            return None
        return interpretation_context._interpretation_context_from_capi(h_ret)

    def second(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.PairInterpretationContextString_second(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def equal(self, PairInterpretationContextString b):
        return _c_api.PairInterpretationContextString_equal(self.handle, b.handle)

    def __eq__(self, PairInterpretationContextString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairInterpretationContextString b):
        return _c_api.PairInterpretationContextString_not_equal(self.handle, b.handle)

    def __ne__(self, PairInterpretationContextString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
