# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .list_connection cimport ListConnection
from .list_pair_connection_quantity cimport ListPairConnectionQuantity
from .list_quantity cimport ListQuantity
from .pair_connection_quantity cimport PairConnectionQuantity
from .quantity cimport Quantity

cdef class MapConnectionQuantity:
    cdef c_api.MapConnectionQuantityHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapConnectionQuantityHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapConnectionQuantityHandle>0 and self.owned:
            c_api.MapConnectionQuantity_destroy(self.handle)
        self.handle = <c_api.MapConnectionQuantityHandle>0

    cdef MapConnectionQuantity from_capi(cls, c_api.MapConnectionQuantityHandle h):
        cdef MapConnectionQuantity obj = <MapConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapConnectionQuantityHandle h
        h = c_api.MapConnectionQuantity_create_empty()
        if h == <c_api.MapConnectionQuantityHandle>0:
            raise MemoryError("Failed to create MapConnectionQuantity")
        cdef MapConnectionQuantity obj = <MapConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapConnectionQuantityHandle h
        h = c_api.MapConnectionQuantity_create(<c_api.PairConnectionQuantityHandle>data.handle, count)
        if h == <c_api.MapConnectionQuantityHandle>0:
            raise MemoryError("Failed to create MapConnectionQuantity")
        cdef MapConnectionQuantity obj = <MapConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapConnectionQuantityHandle h
        try:
            h = c_api.MapConnectionQuantity_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapConnectionQuantityHandle>0:
            raise MemoryError("Failed to create MapConnectionQuantity")
        cdef MapConnectionQuantity obj = <MapConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapConnectionQuantity_insert_or_assign(self.handle, <c_api.ConnectionHandle>key.handle, <c_api.QuantityHandle>value.handle)

    def insert(self, key, value):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapConnectionQuantity_insert(self.handle, <c_api.ConnectionHandle>key.handle, <c_api.QuantityHandle>value.handle)

    def at(self, key):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.MapConnectionQuantity_at(self.handle, <c_api.ConnectionHandle>key.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def erase(self, key):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapConnectionQuantity_erase(self.handle, <c_api.ConnectionHandle>key.handle)

    def size(self):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionQuantity_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionQuantity_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapConnectionQuantity_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionQuantity_contains(self.handle, <c_api.ConnectionHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionHandle h_ret
        h_ret = c_api.MapConnectionQuantity_keys(self.handle)
        if h_ret == <c_api.ListConnectionHandle>0:
            return None
        return ListConnection.from_capi(ListConnection, h_ret)

    def values(self):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListQuantityHandle h_ret
        h_ret = c_api.MapConnectionQuantity_values(self.handle)
        if h_ret == <c_api.ListQuantityHandle>0:
            return None
        return ListQuantity.from_capi(ListQuantity, h_ret)

    def items(self):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairConnectionQuantityHandle h_ret
        h_ret = c_api.MapConnectionQuantity_items(self.handle)
        if h_ret == <c_api.ListPairConnectionQuantityHandle>0:
            return None
        return ListPairConnectionQuantity.from_capi(ListPairConnectionQuantity, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionQuantity_equal(self.handle, <c_api.MapConnectionQuantityHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapConnectionQuantity_not_equal(self.handle, <c_api.MapConnectionQuantityHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapConnectionQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapConnectionQuantity_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapConnectionQuantity _mapconnectionquantity_from_capi(c_api.MapConnectionQuantityHandle h):
    cdef MapConnectionQuantity obj = <MapConnectionQuantity>MapConnectionQuantity.__new__(MapConnectionQuantity)
    obj.handle = h