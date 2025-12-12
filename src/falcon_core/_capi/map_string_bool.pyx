cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_bool
from . cimport list_pair_string_bool
from . cimport list_string
from . cimport pair_string_bool

cdef class MapStringBool:
    def __cinit__(self):
        self.handle = <_c_api.MapStringBoolHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapStringBoolHandle>0 and self.owned:
            _c_api.MapStringBool_destroy(self.handle)
        self.handle = <_c_api.MapStringBoolHandle>0


cdef MapStringBool _map_string_bool_from_capi(_c_api.MapStringBoolHandle h):
    if h == <_c_api.MapStringBoolHandle>0:
        return None
    cdef MapStringBool obj = MapStringBool.__new__(MapStringBool)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapStringBoolHandle h
        h = _c_api.MapStringBool_create_empty()
        if h == <_c_api.MapStringBoolHandle>0:
            raise MemoryError("Failed to create MapStringBool")
        cdef MapStringBool obj = <MapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairStringBool data, size_t count):
        cdef _c_api.MapStringBoolHandle h
        h = _c_api.MapStringBool_create(data.handle, count)
        if h == <_c_api.MapStringBoolHandle>0:
            raise MemoryError("Failed to create MapStringBool")
        cdef MapStringBool obj = <MapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapStringBoolHandle h
        try:
            h = _c_api.MapStringBool_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapStringBoolHandle>0:
            raise MemoryError("Failed to create MapStringBool")
        cdef MapStringBool obj = <MapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, str key, bool value):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        _c_api.MapStringBool_insert_or_assign(self.handle, s_key, value)
        _c_api.String_destroy(s_key)

    def insert(self, str key, bool value):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        _c_api.MapStringBool_insert(self.handle, s_key, value)
        _c_api.String_destroy(s_key)

    def at(self, str key):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        cdef bool ret_val
        try:
            ret_val = _c_api.MapStringBool_at(self.handle, s_key)
        finally:
            _c_api.String_destroy(s_key)
        return ret_val

    def erase(self, str key):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        _c_api.MapStringBool_erase(self.handle, s_key)
        _c_api.String_destroy(s_key)

    def size(self, ):
        return _c_api.MapStringBool_size(self.handle)

    def empty(self, ):
        return _c_api.MapStringBool_empty(self.handle)

    def clear(self, ):
        _c_api.MapStringBool_clear(self.handle)

    def contains(self, str key):
        cdef bytes b_key = key.encode("utf-8")
        cdef StringHandle s_key = _c_api.String_create(b_key, len(b_key))
        cdef bool ret_val
        try:
            ret_val = _c_api.MapStringBool_contains(self.handle, s_key)
        finally:
            _c_api.String_destroy(s_key)
        return ret_val

    def keys(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.MapStringBool_keys(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return list_string._list_string_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListBoolHandle h_ret = _c_api.MapStringBool_values(self.handle)
        if h_ret == <_c_api.ListBoolHandle>0:
            return None
        return list_bool._list_bool_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairStringBoolHandle h_ret = _c_api.MapStringBool_items(self.handle)
        if h_ret == <_c_api.ListPairStringBoolHandle>0:
            return None
        return list_pair_string_bool._list_pair_string_bool_from_capi(h_ret)

    def equal(self, MapStringBool b):
        return _c_api.MapStringBool_equal(self.handle, b.handle)

    def __eq__(self, MapStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapStringBool b):
        return _c_api.MapStringBool_not_equal(self.handle, b.handle)

    def __ne__(self, MapStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
