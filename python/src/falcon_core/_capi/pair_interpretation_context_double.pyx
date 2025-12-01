cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport interpretation_context

cdef class PairInterpretationContextDouble:
    def __cinit__(self):
        self.handle = <_c_api.PairInterpretationContextDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairInterpretationContextDoubleHandle>0 and self.owned:
            _c_api.PairInterpretationContextDouble_destroy(self.handle)
        self.handle = <_c_api.PairInterpretationContextDoubleHandle>0


cdef PairInterpretationContextDouble _pair_interpretation_context_double_from_capi(_c_api.PairInterpretationContextDoubleHandle h):
    if h == <_c_api.PairInterpretationContextDoubleHandle>0:
        return None
    cdef PairInterpretationContextDouble obj = PairInterpretationContextDouble.__new__(PairInterpretationContextDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, InterpretationContext first, double second):
        cdef _c_api.PairInterpretationContextDoubleHandle h
        h = _c_api.PairInterpretationContextDouble_create(first.handle, second)
        if h == <_c_api.PairInterpretationContextDoubleHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextDouble")
        cdef PairInterpretationContextDouble obj = <PairInterpretationContextDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairInterpretationContextDoubleHandle h
        try:
            h = _c_api.PairInterpretationContextDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairInterpretationContextDoubleHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextDouble")
        cdef PairInterpretationContextDouble obj = <PairInterpretationContextDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.InterpretationContextHandle h_ret = _c_api.PairInterpretationContextDouble_first(self.handle)
        if h_ret == <_c_api.InterpretationContextHandle>0:
            return None
        return interpretation_context._interpretation_context_from_capi(h_ret)

    def second(self, ):
        return _c_api.PairInterpretationContextDouble_second(self.handle)

    def equal(self, PairInterpretationContextDouble b):
        return _c_api.PairInterpretationContextDouble_equal(self.handle, b.handle)

    def __eq__(self, PairInterpretationContextDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairInterpretationContextDouble b):
        return _c_api.PairInterpretationContextDouble_not_equal(self.handle, b.handle)

    def __ne__(self, PairInterpretationContextDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
