cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport list_connection
from . cimport list_double
from . cimport list_pair_connection_double
from . cimport pair_connection_double

cdef class MapConnectionDouble:
    def __cinit__(self):
        self.handle = <_c_api.MapConnectionDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapConnectionDoubleHandle>0 and self.owned:
            _c_api.MapConnectionDouble_destroy(self.handle)
        self.handle = <_c_api.MapConnectionDoubleHandle>0


cdef MapConnectionDouble _map_connection_double_from_capi(_c_api.MapConnectionDoubleHandle h):
    if h == <_c_api.MapConnectionDoubleHandle>0:
        return None
    cdef MapConnectionDouble obj = MapConnectionDouble.__new__(MapConnectionDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapConnectionDoubleHandle h
        h = _c_api.MapConnectionDouble_create_empty()
        if h == <_c_api.MapConnectionDoubleHandle>0:
            raise MemoryError("Failed to create MapConnectionDouble")
        cdef MapConnectionDouble obj = <MapConnectionDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairConnectionDouble data, size_t count):
        cdef _c_api.MapConnectionDoubleHandle h
        h = _c_api.MapConnectionDouble_create(data.handle, count)
        if h == <_c_api.MapConnectionDoubleHandle>0:
            raise MemoryError("Failed to create MapConnectionDouble")
        cdef MapConnectionDouble obj = <MapConnectionDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapConnectionDoubleHandle h
        try:
            h = _c_api.MapConnectionDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapConnectionDoubleHandle>0:
            raise MemoryError("Failed to create MapConnectionDouble")
        cdef MapConnectionDouble obj = <MapConnectionDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, Connection key, double value):
        _c_api.MapConnectionDouble_insert_or_assign(self.handle, key.handle, value)

    def insert(self, Connection key, double value):
        _c_api.MapConnectionDouble_insert(self.handle, key.handle, value)

    def at(self, Connection key):
        return _c_api.MapConnectionDouble_at(self.handle, key.handle)

    def erase(self, Connection key):
        _c_api.MapConnectionDouble_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.MapConnectionDouble_size(self.handle)

    def empty(self, ):
        return _c_api.MapConnectionDouble_empty(self.handle)

    def clear(self, ):
        _c_api.MapConnectionDouble_clear(self.handle)

    def contains(self, Connection key):
        return _c_api.MapConnectionDouble_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.MapConnectionDouble_keys(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return list_connection._list_connection_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListDoubleHandle h_ret = _c_api.MapConnectionDouble_values(self.handle)
        if h_ret == <_c_api.ListDoubleHandle>0:
            return None
        return list_double._list_double_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairConnectionDoubleHandle h_ret = _c_api.MapConnectionDouble_items(self.handle)
        if h_ret == <_c_api.ListPairConnectionDoubleHandle>0:
            return None
        return list_pair_connection_double._list_pair_connection_double_from_capi(h_ret)

    def equal(self, MapConnectionDouble b):
        return _c_api.MapConnectionDouble_equal(self.handle, b.handle)

    def __eq__(self, MapConnectionDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapConnectionDouble b):
        return _c_api.MapConnectionDouble_not_equal(self.handle, b.handle)

    def __ne__(self, MapConnectionDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
