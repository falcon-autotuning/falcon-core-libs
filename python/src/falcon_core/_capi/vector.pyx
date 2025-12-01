cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport device_voltage_states
from . cimport list_connection
from . cimport list_pair_connection_pair_quantity_quantity
from . cimport list_pair_quantity_quantity
from . cimport map_connection_double
from . cimport map_connection_quantity
from . cimport pair_quantity_quantity
from . cimport point
from . cimport symbol_unit

cdef class Vector:
    def __cinit__(self):
        self.handle = <_c_api.VectorHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.VectorHandle>0 and self.owned:
            _c_api.Vector_destroy(self.handle)
        self.handle = <_c_api.VectorHandle>0


cdef Vector _vector_from_capi(_c_api.VectorHandle h):
    if h == <_c_api.VectorHandle>0:
        return None
    cdef Vector obj = Vector.__new__(Vector)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, Point start, Point end):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create(start.handle, end.handle)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_end(cls, Point end):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_end(end.handle)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_quantities(cls, MapConnectionQuantity start, MapConnectionQuantity end):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_quantities(start.handle, end.handle)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_end_quantities(cls, MapConnectionQuantity end):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_end_quantities(end.handle)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_doubles(cls, MapConnectionDouble start, MapConnectionDouble end, SymbolUnit unit):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_doubles(start.handle, end.handle, unit.handle)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_end_doubles(cls, MapConnectionDouble end, SymbolUnit unit):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_end_doubles(end.handle, unit.handle)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_parent(cls, MapConnectionQuantity items):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_parent(items.handle)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.VectorHandle h
        try:
            h = _c_api.Vector_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def endPoint(self, ):
        cdef _c_api.PointHandle h_ret = _c_api.Vector_endPoint(self.handle)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return point._point_from_capi(h_ret)

    def startPoint(self, ):
        cdef _c_api.PointHandle h_ret = _c_api.Vector_startPoint(self.handle)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return point._point_from_capi(h_ret)

    def end_quantities(self, ):
        cdef _c_api.MapConnectionQuantityHandle h_ret = _c_api.Vector_end_quantities(self.handle)
        if h_ret == <_c_api.MapConnectionQuantityHandle>0:
            return None
        return map_connection_quantity._map_connection_quantity_from_capi(h_ret)

    def start_quantities(self, ):
        cdef _c_api.MapConnectionQuantityHandle h_ret = _c_api.Vector_start_quantities(self.handle)
        if h_ret == <_c_api.MapConnectionQuantityHandle>0:
            return None
        return map_connection_quantity._map_connection_quantity_from_capi(h_ret)

    def end_map(self, ):
        cdef _c_api.MapConnectionDoubleHandle h_ret = _c_api.Vector_end_map(self.handle)
        if h_ret == <_c_api.MapConnectionDoubleHandle>0:
            return None
        return map_connection_double._map_connection_double_from_capi(h_ret)

    def start_map(self, ):
        cdef _c_api.MapConnectionDoubleHandle h_ret = _c_api.Vector_start_map(self.handle)
        if h_ret == <_c_api.MapConnectionDoubleHandle>0:
            return None
        return map_connection_double._map_connection_double_from_capi(h_ret)

    def connections(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.Vector_connections(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return list_connection._list_connection_from_capi(h_ret)

    def unit(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.Vector_unit(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return symbol_unit._symbol_unit_from_capi(h_ret)

    def principle_connection(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Vector_principle_connection(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def magnitude(self, ):
        return _c_api.Vector_magnitude(self.handle)

    def insert_or_assign(self, Connection key, PairQuantityQuantity value):
        _c_api.Vector_insert_or_assign(self.handle, key.handle, value.handle)

    def insert(self, Connection key, PairQuantityQuantity value):
        _c_api.Vector_insert(self.handle, key.handle, value.handle)

    def at(self, Connection key):
        cdef _c_api.PairQuantityQuantityHandle h_ret = _c_api.Vector_at(self.handle, key.handle)
        if h_ret == <_c_api.PairQuantityQuantityHandle>0:
            return None
        return pair_quantity_quantity._pair_quantity_quantity_from_capi(h_ret)

    def erase(self, Connection key):
        _c_api.Vector_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.Vector_size(self.handle)

    def empty(self, ):
        return _c_api.Vector_empty(self.handle)

    def clear(self, ):
        _c_api.Vector_clear(self.handle)

    def contains(self, Connection key):
        return _c_api.Vector_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.Vector_keys(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return list_connection._list_connection_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListPairQuantityQuantityHandle h_ret = _c_api.Vector_values(self.handle)
        if h_ret == <_c_api.ListPairQuantityQuantityHandle>0:
            return None
        return list_pair_quantity_quantity._list_pair_quantity_quantity_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairConnectionPairQuantityQuantityHandle h_ret = _c_api.Vector_items(self.handle)
        if h_ret == <_c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            return None
        return list_pair_connection_pair_quantity_quantity._list_pair_connection_pair_quantity_quantity_from_capi(h_ret)

    def addition(self, Vector other):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_addition(self.handle, other.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def __add__(self, Vector other):
        return self.addition(other)

    def subtraction(self, Vector other):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_subtraction(self.handle, other.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def __sub__(self, Vector other):
        return self.subtraction(other)

    def double_multiplication(self, double scalar):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_double_multiplication(self.handle, scalar)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def int_multiplication(self, int scalar):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_int_multiplication(self.handle, scalar)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def double_division(self, double scalar):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_double_division(self.handle, scalar)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def int_division(self, int scalar):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_int_division(self.handle, scalar)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def negation(self, ):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_negation(self.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def __neg__(self):
        return self.negation()

    def update_start_from_states(self, DeviceVoltageStates state):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_update_start_from_states(self.handle, state.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def translate_doubles(self, MapConnectionDouble point, SymbolUnit unit):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_translate_doubles(self.handle, point.handle, unit.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def translate_quantities(self, MapConnectionQuantity point):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_translate_quantities(self.handle, point.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def translate(self, Point point):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_translate(self.handle, point.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def translate_to_origin(self, ):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_translate_to_origin(self.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def double_extend(self, double extension):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_double_extend(self.handle, extension)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def int_extend(self, int extension):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_int_extend(self.handle, extension)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def double_shrink(self, double extension):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_double_shrink(self.handle, extension)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def int_shrink(self, int extension):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_int_shrink(self.handle, extension)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def unit_vector(self, ):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_unit_vector(self.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def normalize(self, ):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_normalize(self.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def project(self, Vector other):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_project(self.handle, other.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret)

    def update_unit(self, SymbolUnit unit):
        _c_api.Vector_update_unit(self.handle, unit.handle)

    def equal(self, Vector b):
        return _c_api.Vector_equal(self.handle, b.handle)

    def __eq__(self, Vector b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Vector b):
        return _c_api.Vector_not_equal(self.handle, b.handle)

    def __ne__(self, Vector b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
