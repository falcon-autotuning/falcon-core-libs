cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_float
from . cimport list_pair_float_float
from . cimport pair_float_float

cdef class MapFloatFloat:
    def __cinit__(self):
        self.handle = <_c_api.MapFloatFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapFloatFloatHandle>0 and self.owned:
            _c_api.MapFloatFloat_destroy(self.handle)
        self.handle = <_c_api.MapFloatFloatHandle>0


cdef MapFloatFloat _map_float_float_from_capi(_c_api.MapFloatFloatHandle h):
    if h == <_c_api.MapFloatFloatHandle>0:
        return None
    cdef MapFloatFloat obj = MapFloatFloat.__new__(MapFloatFloat)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.MapFloatFloatHandle h
        h = _c_api.MapFloatFloat_create_empty()
        if h == <_c_api.MapFloatFloatHandle>0:
            raise MemoryError("Failed to create MapFloatFloat")
        cdef MapFloatFloat obj = <MapFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairFloatFloat data, size_t count):
        cdef _c_api.MapFloatFloatHandle h
        h = _c_api.MapFloatFloat_create(data.handle, count)
        if h == <_c_api.MapFloatFloatHandle>0:
            raise MemoryError("Failed to create MapFloatFloat")
        cdef MapFloatFloat obj = <MapFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapFloatFloatHandle h
        try:
            h = _c_api.MapFloatFloat_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapFloatFloatHandle>0:
            raise MemoryError("Failed to create MapFloatFloat")
        cdef MapFloatFloat obj = <MapFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, float key, float value):
        _c_api.MapFloatFloat_insert_or_assign(self.handle, key, value)

    def insert(self, float key, float value):
        _c_api.MapFloatFloat_insert(self.handle, key, value)

    def at(self, float key):
        return _c_api.MapFloatFloat_at(self.handle, key)

    def erase(self, float key):
        _c_api.MapFloatFloat_erase(self.handle, key)

    def size(self, ):
        return _c_api.MapFloatFloat_size(self.handle)

    def empty(self, ):
        return _c_api.MapFloatFloat_empty(self.handle)

    def clear(self, ):
        _c_api.MapFloatFloat_clear(self.handle)

    def contains(self, float key):
        return _c_api.MapFloatFloat_contains(self.handle, key)

    def keys(self, ):
        cdef _c_api.ListFloatHandle h_ret = _c_api.MapFloatFloat_keys(self.handle)
        if h_ret == <_c_api.ListFloatHandle>0:
            return None
        return list_float._list_float_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListFloatHandle h_ret = _c_api.MapFloatFloat_values(self.handle)
        if h_ret == <_c_api.ListFloatHandle>0:
            return None
        return list_float._list_float_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairFloatFloatHandle h_ret = _c_api.MapFloatFloat_items(self.handle)
        if h_ret == <_c_api.ListPairFloatFloatHandle>0:
            return None
        return list_pair_float_float._list_pair_float_float_from_capi(h_ret)

    def equal(self, MapFloatFloat b):
        return _c_api.MapFloatFloat_equal(self.handle, b.handle)

    def __eq__(self, MapFloatFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapFloatFloat b):
        return _c_api.MapFloatFloat_not_equal(self.handle, b.handle)

    def __ne__(self, MapFloatFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
