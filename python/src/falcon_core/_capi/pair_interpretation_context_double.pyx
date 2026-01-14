cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .interpretation_context cimport InterpretationContext, _interpretation_context_from_capi

cdef class PairInterpretationContextDouble:
    def __cinit__(self):
        self.handle = <_c_api.PairInterpretationContextDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairInterpretationContextDoubleHandle>0 and self.owned:
            _c_api.PairInterpretationContextDouble_destroy(self.handle)
        self.handle = <_c_api.PairInterpretationContextDoubleHandle>0


    @classmethod
    def new(cls, InterpretationContext first, double second):
        cdef _c_api.PairInterpretationContextDoubleHandle h
        h = _c_api.PairInterpretationContextDouble_create(first.handle if first is not None else <_c_api.InterpretationContextHandle>0, second)
        if h == <_c_api.PairInterpretationContextDoubleHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextDouble")
        cdef PairInterpretationContextDouble obj = <PairInterpretationContextDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def copy(self):
        cdef _c_api.PairInterpretationContextDoubleHandle h_ret = _c_api.PairInterpretationContextDouble_copy(self.handle)
        if h_ret == <_c_api.PairInterpretationContextDoubleHandle>0: return None
        return _pair_interpretation_context_double_from_capi(h_ret, owned=(h_ret != <_c_api.PairInterpretationContextDoubleHandle>self.handle))

    def first(self):
        cdef _c_api.InterpretationContextHandle h_ret = _c_api.PairInterpretationContextDouble_first(self.handle)
        if h_ret == <_c_api.InterpretationContextHandle>0: return None
        return _interpretation_context_from_capi(h_ret, owned=True)

    def second(self):
        return _c_api.PairInterpretationContextDouble_second(self.handle)

    def equal(self, PairInterpretationContextDouble other):
        return _c_api.PairInterpretationContextDouble_equal(self.handle, other.handle if other is not None else <_c_api.PairInterpretationContextDoubleHandle>0)

    def __eq__(self, PairInterpretationContextDouble other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.equal(other)

    def not_equal(self, PairInterpretationContextDouble other):
        return _c_api.PairInterpretationContextDouble_not_equal(self.handle, other.handle if other is not None else <_c_api.PairInterpretationContextDoubleHandle>0)

    def __ne__(self, PairInterpretationContextDouble other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.not_equal(other)

    def to_json(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PairInterpretationContextDouble_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def __repr__(self):
        return f"{self.__class__.__name__}({self.to_json()})"

    def __str__(self):
        return self.to_json()

cdef PairInterpretationContextDouble _pair_interpretation_context_double_from_capi(_c_api.PairInterpretationContextDoubleHandle h, bint owned=True):
    if h == <_c_api.PairInterpretationContextDoubleHandle>0:
        return None
    cdef PairInterpretationContextDouble obj = PairInterpretationContextDouble.__new__(PairInterpretationContextDouble)
    obj.handle = h
    obj.owned = owned
    return obj
