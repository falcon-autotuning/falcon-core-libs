cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .list_connection cimport ListConnection, _list_connection_from_capi
from .list_pair_connection_quantity cimport ListPairConnectionQuantity, _list_pair_connection_quantity_from_capi
from .list_quantity cimport ListQuantity, _list_quantity_from_capi
from .map_connection_double cimport MapConnectionDouble, _map_connection_double_from_capi
from .map_connection_quantity cimport MapConnectionQuantity, _map_connection_quantity_from_capi
from .quantity cimport Quantity, _quantity_from_capi
from .symbol_unit cimport SymbolUnit, _symbol_unit_from_capi

cdef class Point:
    def __cinit__(self):
        self.handle = <_c_api.PointHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PointHandle>0 and self.owned:
            _c_api.Point_destroy(self.handle)
        self.handle = <_c_api.PointHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.PointHandle h
        h = _c_api.Point_create_empty()
        if h == <_c_api.PointHandle>0:
            raise MemoryError("Failed to create Point")
        cdef Point obj = <Point>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, MapConnectionDouble items, SymbolUnit unit):
        cdef _c_api.PointHandle h
        h = _c_api.Point_create(items.handle if items is not None else <_c_api.MapConnectionDoubleHandle>0, unit.handle if unit is not None else <_c_api.SymbolUnitHandle>0)
        if h == <_c_api.PointHandle>0:
            raise MemoryError("Failed to create Point")
        cdef Point obj = <Point>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_parent(cls, MapConnectionQuantity items):
        cdef _c_api.PointHandle h
        h = _c_api.Point_create_from_parent(items.handle if items is not None else <_c_api.MapConnectionQuantityHandle>0)
        if h == <_c_api.PointHandle>0:
            raise MemoryError("Failed to create Point")
        cdef Point obj = <Point>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PointHandle h
        try:
            h = _c_api.Point_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PointHandle>0:
            raise MemoryError("Failed to create Point")
        cdef Point obj = <Point>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def unit(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.Point_unit(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def insert_or_assign(self, Connection key, Quantity value):
        _c_api.Point_insert_or_assign(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0, value.handle if value is not None else <_c_api.QuantityHandle>0)

    def insert(self, Connection key, Quantity value):
        _c_api.Point_insert(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0, value.handle if value is not None else <_c_api.QuantityHandle>0)

    def at(self, Connection key):
        cdef _c_api.QuantityHandle h_ret = _c_api.Point_at(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret, owned=False)

    def erase(self, Connection key):
        _c_api.Point_erase(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)

    def size(self, ):
        return _c_api.Point_size(self.handle)

    def empty(self, ):
        return _c_api.Point_empty(self.handle)

    def clear(self, ):
        _c_api.Point_clear(self.handle)

    def contains(self, Connection key):
        return _c_api.Point_contains(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)

    def keys(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.Point_keys(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListQuantityHandle h_ret = _c_api.Point_values(self.handle)
        if h_ret == <_c_api.ListQuantityHandle>0:
            return None
        return _list_quantity_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairConnectionQuantityHandle h_ret = _c_api.Point_items(self.handle)
        if h_ret == <_c_api.ListPairConnectionQuantityHandle>0:
            return None
        return _list_pair_connection_quantity_from_capi(h_ret)

    def coordinates(self, ):
        cdef _c_api.MapConnectionQuantityHandle h_ret = _c_api.Point_coordinates(self.handle)
        if h_ret == <_c_api.MapConnectionQuantityHandle>0:
            return None
        return _map_connection_quantity_from_capi(h_ret)

    def connections(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.Point_connections(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret)

    def addition(self, Point other):
        cdef _c_api.PointHandle h_ret = _c_api.Point_addition(self.handle, other.handle if other is not None else <_c_api.PointHandle>0)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return _point_from_capi(h_ret)

    def __add__(self, Point other):
        return self.addition(other)

    def subtraction(self, Point other):
        cdef _c_api.PointHandle h_ret = _c_api.Point_subtraction(self.handle, other.handle if other is not None else <_c_api.PointHandle>0)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return _point_from_capi(h_ret)

    def __sub__(self, Point other):
        return self.subtraction(other)

    def multiplication(self, double scalar):
        cdef _c_api.PointHandle h_ret = _c_api.Point_multiplication(self.handle, scalar)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return _point_from_capi(h_ret)

    def __mul__(self, double scalar):
        return self.multiplication(scalar)

    def division(self, double scalar):
        cdef _c_api.PointHandle h_ret = _c_api.Point_division(self.handle, scalar)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return _point_from_capi(h_ret)

    def __truediv__(self, double scalar):
        return self.division(scalar)

    def negation(self, ):
        cdef _c_api.PointHandle h_ret = _c_api.Point_negation(self.handle)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return _point_from_capi(h_ret)

    def __neg__(self):
        return self.negation()

    def set_unit(self, SymbolUnit unit):
        _c_api.Point_set_unit(self.handle, unit.handle if unit is not None else <_c_api.SymbolUnitHandle>0)

    def equal(self, Point b):
        return _c_api.Point_equal(self.handle, b.handle if b is not None else <_c_api.PointHandle>0)

    def __eq__(self, Point b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Point b):
        return _c_api.Point_not_equal(self.handle, b.handle if b is not None else <_c_api.PointHandle>0)

    def __ne__(self, Point b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Point_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

cdef Point _point_from_capi(_c_api.PointHandle h, bint owned=True):
    if h == <_c_api.PointHandle>0:
        return None
    cdef Point obj = Point.__new__(Point)
    obj.handle = h
    obj.owned = owned
    return obj
