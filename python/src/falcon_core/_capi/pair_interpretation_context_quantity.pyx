cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport interpretation_context
from . cimport quantity

cdef class PairInterpretationContextQuantity:
    def __cinit__(self):
        self.handle = <_c_api.PairInterpretationContextQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairInterpretationContextQuantityHandle>0 and self.owned:
            _c_api.PairInterpretationContextQuantity_destroy(self.handle)
        self.handle = <_c_api.PairInterpretationContextQuantityHandle>0


cdef PairInterpretationContextQuantity _pair_interpretation_context_quantity_from_capi(_c_api.PairInterpretationContextQuantityHandle h):
    if h == <_c_api.PairInterpretationContextQuantityHandle>0:
        return None
    cdef PairInterpretationContextQuantity obj = PairInterpretationContextQuantity.__new__(PairInterpretationContextQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, InterpretationContext first, Quantity second):
        cdef _c_api.PairInterpretationContextQuantityHandle h
        h = _c_api.PairInterpretationContextQuantity_create(first.handle, second.handle)
        if h == <_c_api.PairInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextQuantity")
        cdef PairInterpretationContextQuantity obj = <PairInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairInterpretationContextQuantityHandle h
        try:
            h = _c_api.PairInterpretationContextQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create PairInterpretationContextQuantity")
        cdef PairInterpretationContextQuantity obj = <PairInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.InterpretationContextHandle h_ret = _c_api.PairInterpretationContextQuantity_first(self.handle)
        if h_ret == <_c_api.InterpretationContextHandle>0:
            return None
        return interpretation_context._interpretation_context_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.QuantityHandle h_ret = _c_api.PairInterpretationContextQuantity_second(self.handle)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return quantity._quantity_from_capi(h_ret)

    def equal(self, PairInterpretationContextQuantity b):
        return _c_api.PairInterpretationContextQuantity_equal(self.handle, b.handle)

    def __eq__(self, PairInterpretationContextQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairInterpretationContextQuantity b):
        return _c_api.PairInterpretationContextQuantity_not_equal(self.handle, b.handle)

    def __ne__(self, PairInterpretationContextQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
