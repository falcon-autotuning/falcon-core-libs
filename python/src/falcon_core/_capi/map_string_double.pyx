cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_double
from . cimport list_pair_string_double
from . cimport list_string
from . cimport pair_string_double

cdef class MapStringDouble:
    def __cinit__(self):
        self.handle = <_c_api.MapStringDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapStringDoubleHandle>0 and self.owned:
            _c_api.MapStringDouble_destroy(self.handle)
        self.handle = <_c_api.MapStringDoubleHandle>0


cdef MapStringDouble _map_string_double_from_capi(_c_api.MapStringDoubleHandle h):
    if h == <_c_api.MapStringDoubleHandle>0:
        return None
    cdef MapStringDouble obj = MapStringDouble.__new__(MapStringDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.MapStringDoubleHandle h
        h = _c_api.MapStringDouble_create_empty()
        if h == <_c_api.MapStringDoubleHandle>0:
            raise MemoryError("Failed to create MapStringDouble")
        cdef MapStringDouble obj = <MapStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairStringDouble data, size_t count):
        cdef _c_api.MapStringDoubleHandle h
        h = _c_api.MapStringDouble_create(data.handle, count)
        if h == <_c_api.MapStringDoubleHandle>0:
            raise MemoryError("Failed to create MapStringDouble")
        cdef MapStringDouble obj = <MapStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapStringDoubleHandle h
        try:
            h = _c_api.MapStringDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapStringDoubleHandle>0:
            raise MemoryError("Failed to create MapStringDouble")
        cdef MapStringDouble obj = <MapStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, str key, double value):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        _c_api.MapStringDouble_insert_or_assign(self.handle, s_key, value)
        _c_api.String_destroy(s_key)

    def insert(self, str key, double value):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        _c_api.MapStringDouble_insert(self.handle, s_key, value)
        _c_api.String_destroy(s_key)

    def at(self, str key):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        cdef double ret_val
        try:
            ret_val = _c_api.MapStringDouble_at(self.handle, s_key)
        finally:
            _c_api.String_destroy(s_key)
        return ret_val

    def erase(self, str key):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        _c_api.MapStringDouble_erase(self.handle, s_key)
        _c_api.String_destroy(s_key)

    def size(self, ):
        return _c_api.MapStringDouble_size(self.handle)

    def empty(self, ):
        return _c_api.MapStringDouble_empty(self.handle)

    def clear(self, ):
        _c_api.MapStringDouble_clear(self.handle)

    def contains(self, str key):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        cdef bool ret_val
        try:
            ret_val = _c_api.MapStringDouble_contains(self.handle, s_key)
        finally:
            _c_api.String_destroy(s_key)
        return ret_val

    def keys(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.MapStringDouble_keys(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return list_string._list_string_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListDoubleHandle h_ret = _c_api.MapStringDouble_values(self.handle)
        if h_ret == <_c_api.ListDoubleHandle>0:
            return None
        return list_double._list_double_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairStringDoubleHandle h_ret = _c_api.MapStringDouble_items(self.handle)
        if h_ret == <_c_api.ListPairStringDoubleHandle>0:
            return None
        return list_pair_string_double._list_pair_string_double_from_capi(h_ret)

    def equal(self, MapStringDouble b):
        return _c_api.MapStringDouble_equal(self.handle, b.handle)

    def __eq__(self, MapStringDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapStringDouble b):
        return _c_api.MapStringDouble_not_equal(self.handle, b.handle)

    def __ne__(self, MapStringDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
