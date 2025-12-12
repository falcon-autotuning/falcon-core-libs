cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport list_connection
from . cimport list_pair_connection_quantity
from . cimport list_quantity
from . cimport pair_connection_quantity
from . cimport quantity

cdef class MapConnectionQuantity:
    def __cinit__(self):
        self.handle = <_c_api.MapConnectionQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapConnectionQuantityHandle>0 and self.owned:
            _c_api.MapConnectionQuantity_destroy(self.handle)
        self.handle = <_c_api.MapConnectionQuantityHandle>0


cdef MapConnectionQuantity _map_connection_quantity_from_capi(_c_api.MapConnectionQuantityHandle h):
    if h == <_c_api.MapConnectionQuantityHandle>0:
        return None
    cdef MapConnectionQuantity obj = MapConnectionQuantity.__new__(MapConnectionQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapConnectionQuantityHandle h
        h = _c_api.MapConnectionQuantity_create_empty()
        if h == <_c_api.MapConnectionQuantityHandle>0:
            raise MemoryError("Failed to create MapConnectionQuantity")
        cdef MapConnectionQuantity obj = <MapConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairConnectionQuantity data, size_t count):
        cdef _c_api.MapConnectionQuantityHandle h
        h = _c_api.MapConnectionQuantity_create(data.handle, count)
        if h == <_c_api.MapConnectionQuantityHandle>0:
            raise MemoryError("Failed to create MapConnectionQuantity")
        cdef MapConnectionQuantity obj = <MapConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapConnectionQuantityHandle h
        try:
            h = _c_api.MapConnectionQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapConnectionQuantityHandle>0:
            raise MemoryError("Failed to create MapConnectionQuantity")
        cdef MapConnectionQuantity obj = <MapConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, Connection key, Quantity value):
        _c_api.MapConnectionQuantity_insert_or_assign(self.handle, key.handle, value.handle)

    def insert(self, Connection key, Quantity value):
        _c_api.MapConnectionQuantity_insert(self.handle, key.handle, value.handle)

    def at(self, Connection key):
        cdef _c_api.QuantityHandle h_ret = _c_api.MapConnectionQuantity_at(self.handle, key.handle)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return quantity._quantity_from_capi(h_ret)

    def erase(self, Connection key):
        _c_api.MapConnectionQuantity_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.MapConnectionQuantity_size(self.handle)

    def empty(self, ):
        return _c_api.MapConnectionQuantity_empty(self.handle)

    def clear(self, ):
        _c_api.MapConnectionQuantity_clear(self.handle)

    def contains(self, Connection key):
        return _c_api.MapConnectionQuantity_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.MapConnectionQuantity_keys(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return list_connection._list_connection_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListQuantityHandle h_ret = _c_api.MapConnectionQuantity_values(self.handle)
        if h_ret == <_c_api.ListQuantityHandle>0:
            return None
        return list_quantity._list_quantity_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairConnectionQuantityHandle h_ret = _c_api.MapConnectionQuantity_items(self.handle)
        if h_ret == <_c_api.ListPairConnectionQuantityHandle>0:
            return None
        return list_pair_connection_quantity._list_pair_connection_quantity_from_capi(h_ret)

    def equal(self, MapConnectionQuantity b):
        return _c_api.MapConnectionQuantity_equal(self.handle, b.handle)

    def __eq__(self, MapConnectionQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapConnectionQuantity b):
        return _c_api.MapConnectionQuantity_not_equal(self.handle, b.handle)

    def __ne__(self, MapConnectionQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
