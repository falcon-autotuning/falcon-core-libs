# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .interpretation_context cimport InterpretationContext
from .list_interpretation_context cimport ListInterpretationContext
from .list_pair_interpretation_context_quantity cimport ListPairInterpretationContextQuantity
from .list_quantity cimport ListQuantity
from .pair_interpretation_context_quantity cimport PairInterpretationContextQuantity
from .quantity cimport Quantity

cdef class MapInterpretationContextQuantity:
    cdef c_api.MapInterpretationContextQuantityHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapInterpretationContextQuantityHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapInterpretationContextQuantityHandle>0 and self.owned:
            c_api.MapInterpretationContextQuantity_destroy(self.handle)
        self.handle = <c_api.MapInterpretationContextQuantityHandle>0

    cdef MapInterpretationContextQuantity from_capi(cls, c_api.MapInterpretationContextQuantityHandle h):
        cdef MapInterpretationContextQuantity obj = <MapInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapInterpretationContextQuantityHandle h
        h = c_api.MapInterpretationContextQuantity_create_empty()
        if h == <c_api.MapInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextQuantity")
        cdef MapInterpretationContextQuantity obj = <MapInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapInterpretationContextQuantityHandle h
        h = c_api.MapInterpretationContextQuantity_create(<c_api.PairInterpretationContextQuantityHandle>data.handle, count)
        if h == <c_api.MapInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextQuantity")
        cdef MapInterpretationContextQuantity obj = <MapInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapInterpretationContextQuantityHandle h
        try:
            h = c_api.MapInterpretationContextQuantity_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextQuantity")
        cdef MapInterpretationContextQuantity obj = <MapInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInterpretationContextQuantity_insert_or_assign(self.handle, <c_api.InterpretationContextHandle>key.handle, <c_api.QuantityHandle>value.handle)

    def insert(self, key, value):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInterpretationContextQuantity_insert(self.handle, <c_api.InterpretationContextHandle>key.handle, <c_api.QuantityHandle>value.handle)

    def at(self, key):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.MapInterpretationContextQuantity_at(self.handle, <c_api.InterpretationContextHandle>key.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def erase(self, key):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInterpretationContextQuantity_erase(self.handle, <c_api.InterpretationContextHandle>key.handle)

    def size(self):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextQuantity_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextQuantity_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapInterpretationContextQuantity_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextQuantity_contains(self.handle, <c_api.InterpretationContextHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.MapInterpretationContextQuantity_keys(self.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def values(self):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListQuantityHandle h_ret
        h_ret = c_api.MapInterpretationContextQuantity_values(self.handle)
        if h_ret == <c_api.ListQuantityHandle>0:
            return None
        return ListQuantity.from_capi(ListQuantity, h_ret)

    def items(self):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairInterpretationContextQuantityHandle h_ret
        h_ret = c_api.MapInterpretationContextQuantity_items(self.handle)
        if h_ret == <c_api.ListPairInterpretationContextQuantityHandle>0:
            return None
        return ListPairInterpretationContextQuantity.from_capi(ListPairInterpretationContextQuantity, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextQuantity_equal(self.handle, <c_api.MapInterpretationContextQuantityHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapInterpretationContextQuantity_not_equal(self.handle, <c_api.MapInterpretationContextQuantityHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapInterpretationContextQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapInterpretationContextQuantity_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapInterpretationContextQuantity _mapinterpretationcontextquantity_from_capi(c_api.MapInterpretationContextQuantityHandle h):
    cdef MapInterpretationContextQuantity obj = <MapInterpretationContextQuantity>MapInterpretationContextQuantity.__new__(MapInterpretationContextQuantity)
    obj.handle = h