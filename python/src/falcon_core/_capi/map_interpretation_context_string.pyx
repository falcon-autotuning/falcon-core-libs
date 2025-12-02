cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport interpretation_context
from . cimport list_interpretation_context
from . cimport list_pair_interpretation_context_string
from . cimport list_string
from . cimport pair_interpretation_context_string

cdef class MapInterpretationContextString:
    def __cinit__(self):
        self.handle = <_c_api.MapInterpretationContextStringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapInterpretationContextStringHandle>0 and self.owned:
            _c_api.MapInterpretationContextString_destroy(self.handle)
        self.handle = <_c_api.MapInterpretationContextStringHandle>0


cdef MapInterpretationContextString _map_interpretation_context_string_from_capi(_c_api.MapInterpretationContextStringHandle h):
    if h == <_c_api.MapInterpretationContextStringHandle>0:
        return None
    cdef MapInterpretationContextString obj = MapInterpretationContextString.__new__(MapInterpretationContextString)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapInterpretationContextStringHandle h
        h = _c_api.MapInterpretationContextString_create_empty()
        if h == <_c_api.MapInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextString")
        cdef MapInterpretationContextString obj = <MapInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairInterpretationContextString data, size_t count):
        cdef _c_api.MapInterpretationContextStringHandle h
        h = _c_api.MapInterpretationContextString_create(data.handle, count)
        if h == <_c_api.MapInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextString")
        cdef MapInterpretationContextString obj = <MapInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapInterpretationContextStringHandle h
        try:
            h = _c_api.MapInterpretationContextString_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create MapInterpretationContextString")
        cdef MapInterpretationContextString obj = <MapInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, InterpretationContext key, str value):
        cdef bytes b_value = value.encode("utf-8")
        cdef StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        _c_api.MapInterpretationContextString_insert_or_assign(self.handle, key.handle, s_value)
        _c_api.String_destroy(s_value)

    def insert(self, InterpretationContext key, str value):
        cdef bytes b_value = value.encode("utf-8")
        cdef StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        _c_api.MapInterpretationContextString_insert(self.handle, key.handle, s_value)
        _c_api.String_destroy(s_value)

    def at(self, InterpretationContext key):
        cdef StringHandle s_ret
        s_ret = _c_api.MapInterpretationContextString_at(self.handle, key.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def erase(self, InterpretationContext key):
        _c_api.MapInterpretationContextString_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.MapInterpretationContextString_size(self.handle)

    def empty(self, ):
        return _c_api.MapInterpretationContextString_empty(self.handle)

    def clear(self, ):
        _c_api.MapInterpretationContextString_clear(self.handle)

    def contains(self, InterpretationContext key):
        return _c_api.MapInterpretationContextString_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.MapInterpretationContextString_keys(self.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return list_interpretation_context._list_interpretation_context_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.MapInterpretationContextString_values(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return list_string._list_string_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairInterpretationContextStringHandle h_ret = _c_api.MapInterpretationContextString_items(self.handle)
        if h_ret == <_c_api.ListPairInterpretationContextStringHandle>0:
            return None
        return list_pair_interpretation_context_string._list_pair_interpretation_context_string_from_capi(h_ret)

    def equal(self, MapInterpretationContextString b):
        return _c_api.MapInterpretationContextString_equal(self.handle, b.handle)

    def __eq__(self, MapInterpretationContextString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapInterpretationContextString b):
        return _c_api.MapInterpretationContextString_not_equal(self.handle, b.handle)

    def __ne__(self, MapInterpretationContextString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
