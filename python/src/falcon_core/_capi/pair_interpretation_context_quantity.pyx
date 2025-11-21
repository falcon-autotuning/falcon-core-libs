# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .interpretation_context cimport InterpretationContext
from .quantity cimport Quantity

cdef class PairInterpretationContextQuantity:
    cdef c_api.PairInterpretationContextQuantityHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairInterpretationContextQuantityHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairInterpretationContextQuantityHandle>0 and self.owned:
            c_api.PairInterpretationContextQuantity_destroy(self.handle)
        self.handle = <c_api.PairInterpretationContextQuantityHandle>0

    cdef PairInterpretationContextQuantity from_capi(cls, c_api.PairInterpretationContextQuantityHandle h):
        cdef PairInterpretationContextQuantity obj = <PairInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, first, second):
        cdef c_api.PairInterpretationContextQuantityHandle h
        h = c_api.PairInterpretationContextQuantity_create(<c_api.InterpretationContextHandle>first.handle, <c_api.QuantityHandle>second.handle)
        if h == <c_api.PairInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextQuantity")
        cdef PairInterpretationContextQuantity obj = <PairInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PairInterpretationContextQuantityHandle h
        try:
            h = c_api.PairInterpretationContextQuantity_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PairInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextQuantity")
        cdef PairInterpretationContextQuantity obj = <PairInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self):
        if self.handle == <c_api.PairInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.InterpretationContextHandle h_ret
        h_ret = c_api.PairInterpretationContextQuantity_first(self.handle)
        if h_ret == <c_api.InterpretationContextHandle>0:
            return None
        return InterpretationContext.from_capi(InterpretationContext, h_ret)

    def second(self):
        if self.handle == <c_api.PairInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.PairInterpretationContextQuantity_second(self.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def equal(self, b):
        if self.handle == <c_api.PairInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairInterpretationContextQuantity_equal(self.handle, <c_api.PairInterpretationContextQuantityHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PairInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairInterpretationContextQuantity_not_equal(self.handle, <c_api.PairInterpretationContextQuantityHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PairInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairInterpretationContextQuantity_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PairInterpretationContextQuantity _pairinterpretationcontextquantity_from_capi(c_api.PairInterpretationContextQuantityHandle h):
    cdef PairInterpretationContextQuantity obj = <PairInterpretationContextQuantity>PairInterpretationContextQuantity.__new__(PairInterpretationContextQuantity)
    obj.handle = h