cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport interpretation_context
from . cimport list_interpretation_context
from . cimport list_pair_interpretation_context_quantity
from . cimport list_quantity
from . cimport pair_interpretation_context_quantity
from . cimport quantity

cdef class MapInterpretationContextQuantity:
    def __cinit__(self):
        self.handle = <_c_api.MapInterpretationContextQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapInterpretationContextQuantityHandle>0 and self.owned:
            _c_api.MapInterpretationContextQuantity_destroy(self.handle)
        self.handle = <_c_api.MapInterpretationContextQuantityHandle>0


cdef MapInterpretationContextQuantity _map_interpretation_context_quantity_from_capi(_c_api.MapInterpretationContextQuantityHandle h):
    if h == <_c_api.MapInterpretationContextQuantityHandle>0:
        return None
    cdef MapInterpretationContextQuantity obj = MapInterpretationContextQuantity.__new__(MapInterpretationContextQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.MapInterpretationContextQuantityHandle h
        h = _c_api.MapInterpretationContextQuantity_create_empty()
        if h == <_c_api.MapInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextQuantity")
        cdef MapInterpretationContextQuantity obj = <MapInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairInterpretationContextQuantity data, size_t count):
        cdef _c_api.MapInterpretationContextQuantityHandle h
        h = _c_api.MapInterpretationContextQuantity_create(data.handle, count)
        if h == <_c_api.MapInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextQuantity")
        cdef MapInterpretationContextQuantity obj = <MapInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapInterpretationContextQuantityHandle h
        try:
            h = _c_api.MapInterpretationContextQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextQuantity")
        cdef MapInterpretationContextQuantity obj = <MapInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, InterpretationContext key, Quantity value):
        _c_api.MapInterpretationContextQuantity_insert_or_assign(self.handle, key.handle, value.handle)

    def insert(self, InterpretationContext key, Quantity value):
        _c_api.MapInterpretationContextQuantity_insert(self.handle, key.handle, value.handle)

    def at(self, InterpretationContext key):
        cdef _c_api.QuantityHandle h_ret = _c_api.MapInterpretationContextQuantity_at(self.handle, key.handle)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return quantity._quantity_from_capi(h_ret)

    def erase(self, InterpretationContext key):
        _c_api.MapInterpretationContextQuantity_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.MapInterpretationContextQuantity_size(self.handle)

    def empty(self, ):
        return _c_api.MapInterpretationContextQuantity_empty(self.handle)

    def clear(self, ):
        _c_api.MapInterpretationContextQuantity_clear(self.handle)

    def contains(self, InterpretationContext key):
        return _c_api.MapInterpretationContextQuantity_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.MapInterpretationContextQuantity_keys(self.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return list_interpretation_context._list_interpretation_context_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListQuantityHandle h_ret = _c_api.MapInterpretationContextQuantity_values(self.handle)
        if h_ret == <_c_api.ListQuantityHandle>0:
            return None
        return list_quantity._list_quantity_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairInterpretationContextQuantityHandle h_ret = _c_api.MapInterpretationContextQuantity_items(self.handle)
        if h_ret == <_c_api.ListPairInterpretationContextQuantityHandle>0:
            return None
        return list_pair_interpretation_context_quantity._list_pair_interpretation_context_quantity_from_capi(h_ret)

    def equal(self, MapInterpretationContextQuantity b):
        return _c_api.MapInterpretationContextQuantity_equal(self.handle, b.handle)

    def __eq__(self, MapInterpretationContextQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapInterpretationContextQuantity b):
        return _c_api.MapInterpretationContextQuantity_not_equal(self.handle, b.handle)

    def __ne__(self, MapInterpretationContextQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
