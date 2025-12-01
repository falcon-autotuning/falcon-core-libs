cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport interpretation_context
from . cimport list_double
from . cimport list_interpretation_context
from . cimport list_pair_interpretation_context_double
from . cimport pair_interpretation_context_double

cdef class MapInterpretationContextDouble:
    def __cinit__(self):
        self.handle = <_c_api.MapInterpretationContextDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapInterpretationContextDoubleHandle>0 and self.owned:
            _c_api.MapInterpretationContextDouble_destroy(self.handle)
        self.handle = <_c_api.MapInterpretationContextDoubleHandle>0


cdef MapInterpretationContextDouble _map_interpretation_context_double_from_capi(_c_api.MapInterpretationContextDoubleHandle h):
    if h == <_c_api.MapInterpretationContextDoubleHandle>0:
        return None
    cdef MapInterpretationContextDouble obj = MapInterpretationContextDouble.__new__(MapInterpretationContextDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.MapInterpretationContextDoubleHandle h
        h = _c_api.MapInterpretationContextDouble_create_empty()
        if h == <_c_api.MapInterpretationContextDoubleHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextDouble")
        cdef MapInterpretationContextDouble obj = <MapInterpretationContextDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairInterpretationContextDouble data, size_t count):
        cdef _c_api.MapInterpretationContextDoubleHandle h
        h = _c_api.MapInterpretationContextDouble_create(data.handle, count)
        if h == <_c_api.MapInterpretationContextDoubleHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextDouble")
        cdef MapInterpretationContextDouble obj = <MapInterpretationContextDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapInterpretationContextDoubleHandle h
        try:
            h = _c_api.MapInterpretationContextDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapInterpretationContextDoubleHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextDouble")
        cdef MapInterpretationContextDouble obj = <MapInterpretationContextDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, InterpretationContext key, double value):
        _c_api.MapInterpretationContextDouble_insert_or_assign(self.handle, key.handle, value)

    def insert(self, InterpretationContext key, double value):
        _c_api.MapInterpretationContextDouble_insert(self.handle, key.handle, value)

    def at(self, InterpretationContext key):
        return _c_api.MapInterpretationContextDouble_at(self.handle, key.handle)

    def erase(self, InterpretationContext key):
        _c_api.MapInterpretationContextDouble_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.MapInterpretationContextDouble_size(self.handle)

    def empty(self, ):
        return _c_api.MapInterpretationContextDouble_empty(self.handle)

    def clear(self, ):
        _c_api.MapInterpretationContextDouble_clear(self.handle)

    def contains(self, InterpretationContext key):
        return _c_api.MapInterpretationContextDouble_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.MapInterpretationContextDouble_keys(self.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return list_interpretation_context._list_interpretation_context_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListDoubleHandle h_ret = _c_api.MapInterpretationContextDouble_values(self.handle)
        if h_ret == <_c_api.ListDoubleHandle>0:
            return None
        return list_double._list_double_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairInterpretationContextDoubleHandle h_ret = _c_api.MapInterpretationContextDouble_items(self.handle)
        if h_ret == <_c_api.ListPairInterpretationContextDoubleHandle>0:
            return None
        return list_pair_interpretation_context_double._list_pair_interpretation_context_double_from_capi(h_ret)

    def equal(self, MapInterpretationContextDouble b):
        return _c_api.MapInterpretationContextDouble_equal(self.handle, b.handle)

    def __eq__(self, MapInterpretationContextDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapInterpretationContextDouble b):
        return _c_api.MapInterpretationContextDouble_not_equal(self.handle, b.handle)

    def __ne__(self, MapInterpretationContextDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
