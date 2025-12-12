cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport quantity

cdef class PairQuantityQuantity:
    def __cinit__(self):
        self.handle = <_c_api.PairQuantityQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairQuantityQuantityHandle>0 and self.owned:
            _c_api.PairQuantityQuantity_destroy(self.handle)
        self.handle = <_c_api.PairQuantityQuantityHandle>0


cdef PairQuantityQuantity _pair_quantity_quantity_from_capi(_c_api.PairQuantityQuantityHandle h):
    if h == <_c_api.PairQuantityQuantityHandle>0:
        return None
    cdef PairQuantityQuantity obj = PairQuantityQuantity.__new__(PairQuantityQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, Quantity first, Quantity second):
        cdef _c_api.PairQuantityQuantityHandle h
        h = _c_api.PairQuantityQuantity_create(first.handle, second.handle)
        if h == <_c_api.PairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create PairQuantityQuantity")
        cdef PairQuantityQuantity obj = <PairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairQuantityQuantityHandle h
        try:
            h = _c_api.PairQuantityQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create PairQuantityQuantity")
        cdef PairQuantityQuantity obj = <PairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.QuantityHandle h_ret = _c_api.PairQuantityQuantity_first(self.handle)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return quantity._quantity_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.QuantityHandle h_ret = _c_api.PairQuantityQuantity_second(self.handle)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return quantity._quantity_from_capi(h_ret)

    def equal(self, PairQuantityQuantity b):
        return _c_api.PairQuantityQuantity_equal(self.handle, b.handle)

    def __eq__(self, PairQuantityQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairQuantityQuantity b):
        return _c_api.PairQuantityQuantity_not_equal(self.handle, b.handle)

    def __ne__(self, PairQuantityQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
