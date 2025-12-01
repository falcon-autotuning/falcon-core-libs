cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport connections
from . cimport interpretation_context
from . cimport list_connection
from . cimport list_interpretation_context
from . cimport list_pair_interpretation_context_quantity
from . cimport list_quantity
from . cimport map_interpretation_context_quantity
from . cimport quantity
from . cimport symbol_unit

cdef class InterpretationContainerQuantity:
    def __cinit__(self):
        self.handle = <_c_api.InterpretationContainerQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.InterpretationContainerQuantityHandle>0 and self.owned:
            _c_api.InterpretationContainerQuantity_destroy(self.handle)
        self.handle = <_c_api.InterpretationContainerQuantityHandle>0


cdef InterpretationContainerQuantity _interpretation_container_quantity_from_capi(_c_api.InterpretationContainerQuantityHandle h):
    if h == <_c_api.InterpretationContainerQuantityHandle>0:
        return None
    cdef InterpretationContainerQuantity obj = InterpretationContainerQuantity.__new__(InterpretationContainerQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, MapInterpretationContextQuantity map):
        cdef _c_api.InterpretationContainerQuantityHandle h
        h = _c_api.InterpretationContainerQuantity_create(map.handle)
        if h == <_c_api.InterpretationContainerQuantityHandle>0:
            raise MemoryError("Failed to create InterpretationContainerQuantity")
        cdef InterpretationContainerQuantity obj = <InterpretationContainerQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.InterpretationContainerQuantityHandle h
        try:
            h = _c_api.InterpretationContainerQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.InterpretationContainerQuantityHandle>0:
            raise MemoryError("Failed to create InterpretationContainerQuantity")
        cdef InterpretationContainerQuantity obj = <InterpretationContainerQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def unit(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.InterpretationContainerQuantity_unit(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return symbol_unit._symbol_unit_from_capi(h_ret)

    def select_by_connection(self, Connection connection):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerQuantity_select_by_connection(self.handle, connection.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return list_interpretation_context._list_interpretation_context_from_capi(h_ret)

    def select_by_connections(self, Connections connections):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerQuantity_select_by_connections(self.handle, connections.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return list_interpretation_context._list_interpretation_context_from_capi(h_ret)

    def select_by_independent_connection(self, Connection connection):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerQuantity_select_by_independent_connection(self.handle, connection.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return list_interpretation_context._list_interpretation_context_from_capi(h_ret)

    def select_by_dependent_connection(self, Connection connection):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerQuantity_select_by_dependent_connection(self.handle, connection.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return list_interpretation_context._list_interpretation_context_from_capi(h_ret)

    def select_contexts(self, ListConnection independent_connections, ListConnection dependent_connections):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerQuantity_select_contexts(self.handle, independent_connections.handle, dependent_connections.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return list_interpretation_context._list_interpretation_context_from_capi(h_ret)

    def insert_or_assign(self, InterpretationContext key, Quantity value):
        _c_api.InterpretationContainerQuantity_insert_or_assign(self.handle, key.handle, value.handle)

    def insert(self, InterpretationContext key, Quantity value):
        _c_api.InterpretationContainerQuantity_insert(self.handle, key.handle, value.handle)

    def at(self, InterpretationContext key):
        cdef _c_api.QuantityHandle h_ret = _c_api.InterpretationContainerQuantity_at(self.handle, key.handle)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return quantity._quantity_from_capi(h_ret)

    def erase(self, InterpretationContext key):
        _c_api.InterpretationContainerQuantity_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.InterpretationContainerQuantity_size(self.handle)

    def empty(self, ):
        return _c_api.InterpretationContainerQuantity_empty(self.handle)

    def clear(self, ):
        _c_api.InterpretationContainerQuantity_clear(self.handle)

    def contains(self, InterpretationContext key):
        return _c_api.InterpretationContainerQuantity_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerQuantity_keys(self.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return list_interpretation_context._list_interpretation_context_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListQuantityHandle h_ret = _c_api.InterpretationContainerQuantity_values(self.handle)
        if h_ret == <_c_api.ListQuantityHandle>0:
            return None
        return list_quantity._list_quantity_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairInterpretationContextQuantityHandle h_ret = _c_api.InterpretationContainerQuantity_items(self.handle)
        if h_ret == <_c_api.ListPairInterpretationContextQuantityHandle>0:
            return None
        return list_pair_interpretation_context_quantity._list_pair_interpretation_context_quantity_from_capi(h_ret)

    def equal(self, InterpretationContainerQuantity other):
        return _c_api.InterpretationContainerQuantity_equal(self.handle, other.handle)

    def __eq__(self, InterpretationContainerQuantity other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, InterpretationContainerQuantity other):
        return _c_api.InterpretationContainerQuantity_not_equal(self.handle, other.handle)

    def __ne__(self, InterpretationContainerQuantity other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
