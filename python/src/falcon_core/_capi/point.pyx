# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .list_connection cimport ListConnection
from .list_pair_connection_quantity cimport ListPairConnectionQuantity
from .list_quantity cimport ListQuantity
from .map_connection_double cimport MapConnectionDouble
from .map_connection_quantity cimport MapConnectionQuantity
from .quantity cimport Quantity
from .symbol_unit cimport SymbolUnit

cdef class Point:
    cdef c_api.PointHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PointHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PointHandle>0 and self.owned:
            c_api.Point_destroy(self.handle)
        self.handle = <c_api.PointHandle>0

    cdef Point from_capi(cls, c_api.PointHandle h):
        cdef Point obj = <Point>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.PointHandle h
        h = c_api.Point_create_empty()
        if h == <c_api.PointHandle>0:
            raise MemoryError("Failed to create Point")
        cdef Point obj = <Point>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, items, unit):
        cdef c_api.PointHandle h
        h = c_api.Point_create(<c_api.MapConnectionDoubleHandle>items.handle, <c_api.SymbolUnitHandle>unit.handle)
        if h == <c_api.PointHandle>0:
            raise MemoryError("Failed to create Point")
        cdef Point obj = <Point>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_parent(cls, items):
        cdef c_api.PointHandle h
        h = c_api.Point_create_from_parent(<c_api.MapConnectionQuantityHandle>items.handle)
        if h == <c_api.PointHandle>0:
            raise MemoryError("Failed to create Point")
        cdef Point obj = <Point>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PointHandle h
        try:
            h = c_api.Point_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PointHandle>0:
            raise MemoryError("Failed to create Point")
        cdef Point obj = <Point>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def unit(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.Point_unit(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Point_insert_or_assign(self.handle, <c_api.ConnectionHandle>key.handle, <c_api.QuantityHandle>value.handle)

    def insert(self, key, value):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Point_insert(self.handle, <c_api.ConnectionHandle>key.handle, <c_api.QuantityHandle>value.handle)

    def at(self, key):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Point_at(self.handle, <c_api.ConnectionHandle>key.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def erase(self, key):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Point_erase(self.handle, <c_api.ConnectionHandle>key.handle)

    def size(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Point_size(self.handle)

    def empty(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Point_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Point_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Point_contains(self.handle, <c_api.ConnectionHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionHandle h_ret
        h_ret = c_api.Point_keys(self.handle)
        if h_ret == <c_api.ListConnectionHandle>0:
            return None
        return ListConnection.from_capi(ListConnection, h_ret)

    def values(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListQuantityHandle h_ret
        h_ret = c_api.Point_values(self.handle)
        if h_ret == <c_api.ListQuantityHandle>0:
            return None
        return ListQuantity.from_capi(ListQuantity, h_ret)

    def items(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairConnectionQuantityHandle h_ret
        h_ret = c_api.Point_items(self.handle)
        if h_ret == <c_api.ListPairConnectionQuantityHandle>0:
            return None
        return ListPairConnectionQuantity.from_capi(ListPairConnectionQuantity, h_ret)

    def coordinates(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapConnectionQuantityHandle h_ret
        h_ret = c_api.Point_coordinates(self.handle)
        if h_ret == <c_api.MapConnectionQuantityHandle>0:
            return None
        return MapConnectionQuantity.from_capi(MapConnectionQuantity, h_ret)

    def connections(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionHandle h_ret
        h_ret = c_api.Point_connections(self.handle)
        if h_ret == <c_api.ListConnectionHandle>0:
            return None
        return ListConnection.from_capi(ListConnection, h_ret)

    def addition(self, other):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PointHandle h_ret
        h_ret = c_api.Point_addition(self.handle, <c_api.PointHandle>other.handle)
        if h_ret == <c_api.PointHandle>0:
            return None
        return Point.from_capi(Point, h_ret)

    def __add__(self, other):
        return self.addition(other)

    def subtraction(self, other):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PointHandle h_ret
        h_ret = c_api.Point_subtraction(self.handle, <c_api.PointHandle>other.handle)
        if h_ret == <c_api.PointHandle>0:
            return None
        return Point.from_capi(Point, h_ret)

    def __sub__(self, other):
        return self.subtraction(other)

    def multiplication(self, scalar):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PointHandle h_ret
        h_ret = c_api.Point_multiplication(self.handle, scalar)
        if h_ret == <c_api.PointHandle>0:
            return None
        return Point.from_capi(Point, h_ret)

    def __mul__(self, scalar):
        return self.multiplication(scalar)

    def division(self, scalar):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PointHandle h_ret
        h_ret = c_api.Point_division(self.handle, scalar)
        if h_ret == <c_api.PointHandle>0:
            return None
        return Point.from_capi(Point, h_ret)

    def __truediv__(self, scalar):
        return self.division(scalar)

    def negation(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PointHandle h_ret
        h_ret = c_api.Point_negation(self.handle)
        if h_ret == <c_api.PointHandle>0:
            return None
        return Point.from_capi(Point, h_ret)

    def __neg__(self):
        return self.negation()

    def set_unit(self, unit):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Point_set_unit(self.handle, <c_api.SymbolUnitHandle>unit.handle)

    def equal(self, b):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Point_equal(self.handle, <c_api.PointHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Point_not_equal(self.handle, <c_api.PointHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PointHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Point_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Point _point_from_capi(c_api.PointHandle h):
    cdef Point obj = <Point>Point.__new__(Point)
    obj.handle = h