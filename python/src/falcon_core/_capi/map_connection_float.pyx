cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport list_connection
from . cimport list_float
from . cimport list_pair_connection_float
from . cimport pair_connection_float

cdef class MapConnectionFloat:
    def __cinit__(self):
        self.handle = <_c_api.MapConnectionFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapConnectionFloatHandle>0 and self.owned:
            _c_api.MapConnectionFloat_destroy(self.handle)
        self.handle = <_c_api.MapConnectionFloatHandle>0


cdef MapConnectionFloat _map_connection_float_from_capi(_c_api.MapConnectionFloatHandle h):
    if h == <_c_api.MapConnectionFloatHandle>0:
        return None
    cdef MapConnectionFloat obj = MapConnectionFloat.__new__(MapConnectionFloat)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.MapConnectionFloatHandle h
        h = _c_api.MapConnectionFloat_create_empty()
        if h == <_c_api.MapConnectionFloatHandle>0:
            raise MemoryError("Failed to create MapConnectionFloat")
        cdef MapConnectionFloat obj = <MapConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairConnectionFloat data, size_t count):
        cdef _c_api.MapConnectionFloatHandle h
        h = _c_api.MapConnectionFloat_create(data.handle, count)
        if h == <_c_api.MapConnectionFloatHandle>0:
            raise MemoryError("Failed to create MapConnectionFloat")
        cdef MapConnectionFloat obj = <MapConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapConnectionFloatHandle h
        try:
            h = _c_api.MapConnectionFloat_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapConnectionFloatHandle>0:
            raise MemoryError("Failed to create MapConnectionFloat")
        cdef MapConnectionFloat obj = <MapConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, Connection key, float value):
        _c_api.MapConnectionFloat_insert_or_assign(self.handle, key.handle, value)

    def insert(self, Connection key, float value):
        _c_api.MapConnectionFloat_insert(self.handle, key.handle, value)

    def at(self, Connection key):
        return _c_api.MapConnectionFloat_at(self.handle, key.handle)

    def erase(self, Connection key):
        _c_api.MapConnectionFloat_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.MapConnectionFloat_size(self.handle)

    def empty(self, ):
        return _c_api.MapConnectionFloat_empty(self.handle)

    def clear(self, ):
        _c_api.MapConnectionFloat_clear(self.handle)

    def contains(self, Connection key):
        return _c_api.MapConnectionFloat_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.MapConnectionFloat_keys(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return list_connection._list_connection_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListFloatHandle h_ret = _c_api.MapConnectionFloat_values(self.handle)
        if h_ret == <_c_api.ListFloatHandle>0:
            return None
        return list_float._list_float_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairConnectionFloatHandle h_ret = _c_api.MapConnectionFloat_items(self.handle)
        if h_ret == <_c_api.ListPairConnectionFloatHandle>0:
            return None
        return list_pair_connection_float._list_pair_connection_float_from_capi(h_ret)

    def equal(self, MapConnectionFloat b):
        return _c_api.MapConnectionFloat_equal(self.handle, b.handle)

    def __eq__(self, MapConnectionFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapConnectionFloat b):
        return _c_api.MapConnectionFloat_not_equal(self.handle, b.handle)

    def __ne__(self, MapConnectionFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
