# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .device_voltage_states cimport DeviceVoltageStates
from .list_connection cimport ListConnection
from .list_pair_connection_pair_quantity_quantity cimport ListPairConnectionPairQuantityQuantity
from .list_pair_quantity_quantity cimport ListPairQuantityQuantity
from .map_connection_double cimport MapConnectionDouble
from .map_connection_quantity cimport MapConnectionQuantity
from .pair_quantity_quantity cimport PairQuantityQuantity
from .point cimport Point
from .symbol_unit cimport SymbolUnit

cdef class Vector:
    cdef c_api.VectorHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.VectorHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.VectorHandle>0 and self.owned:
            c_api.Vector_destroy(self.handle)
        self.handle = <c_api.VectorHandle>0

    cdef Vector from_capi(cls, c_api.VectorHandle h):
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, start, end):
        cdef c_api.VectorHandle h
        h = c_api.Vector_create(<c_api.PointHandle>start.handle, <c_api.PointHandle>end.handle)
        if h == <c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_end(cls, end):
        cdef c_api.VectorHandle h
        h = c_api.Vector_create_from_end(<c_api.PointHandle>end.handle)
        if h == <c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_quantities(cls, start, end):
        cdef c_api.VectorHandle h
        h = c_api.Vector_create_from_quantities(<c_api.MapConnectionQuantityHandle>start.handle, <c_api.MapConnectionQuantityHandle>end.handle)
        if h == <c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_end_quantities(cls, end):
        cdef c_api.VectorHandle h
        h = c_api.Vector_create_from_end_quantities(<c_api.MapConnectionQuantityHandle>end.handle)
        if h == <c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_doubles(cls, start, end, unit):
        cdef c_api.VectorHandle h
        h = c_api.Vector_create_from_doubles(<c_api.MapConnectionDoubleHandle>start.handle, <c_api.MapConnectionDoubleHandle>end.handle, <c_api.SymbolUnitHandle>unit.handle)
        if h == <c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_end_doubles(cls, end, unit):
        cdef c_api.VectorHandle h
        h = c_api.Vector_create_from_end_doubles(<c_api.MapConnectionDoubleHandle>end.handle, <c_api.SymbolUnitHandle>unit.handle)
        if h == <c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_parent(cls, items):
        cdef c_api.VectorHandle h
        h = c_api.Vector_create_from_parent(<c_api.MapConnectionQuantityHandle>items.handle)
        if h == <c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.VectorHandle h
        try:
            h = c_api.Vector_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def endPoint(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PointHandle h_ret
        h_ret = c_api.Vector_endPoint(self.handle)
        if h_ret == <c_api.PointHandle>0:
            return None
        return Point.from_capi(Point, h_ret)

    def startPoint(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PointHandle h_ret
        h_ret = c_api.Vector_startPoint(self.handle)
        if h_ret == <c_api.PointHandle>0:
            return None
        return Point.from_capi(Point, h_ret)

    def end_quantities(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapConnectionQuantityHandle h_ret
        h_ret = c_api.Vector_end_quantities(self.handle)
        if h_ret == <c_api.MapConnectionQuantityHandle>0:
            return None
        return MapConnectionQuantity.from_capi(MapConnectionQuantity, h_ret)

    def start_quantities(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapConnectionQuantityHandle h_ret
        h_ret = c_api.Vector_start_quantities(self.handle)
        if h_ret == <c_api.MapConnectionQuantityHandle>0:
            return None
        return MapConnectionQuantity.from_capi(MapConnectionQuantity, h_ret)

    def end_map(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapConnectionDoubleHandle h_ret
        h_ret = c_api.Vector_end_map(self.handle)
        if h_ret == <c_api.MapConnectionDoubleHandle>0:
            return None
        return MapConnectionDouble.from_capi(MapConnectionDouble, h_ret)

    def start_map(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapConnectionDoubleHandle h_ret
        h_ret = c_api.Vector_start_map(self.handle)
        if h_ret == <c_api.MapConnectionDoubleHandle>0:
            return None
        return MapConnectionDouble.from_capi(MapConnectionDouble, h_ret)

    def connections(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionHandle h_ret
        h_ret = c_api.Vector_connections(self.handle)
        if h_ret == <c_api.ListConnectionHandle>0:
            return None
        return ListConnection.from_capi(ListConnection, h_ret)

    def unit(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.Vector_unit(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def principle_connection(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.Vector_principle_connection(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def magnitude(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Vector_magnitude(self.handle)

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Vector_insert_or_assign(self.handle, <c_api.ConnectionHandle>key.handle, <c_api.PairQuantityQuantityHandle>value.handle)

    def insert(self, key, value):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Vector_insert(self.handle, <c_api.ConnectionHandle>key.handle, <c_api.PairQuantityQuantityHandle>value.handle)

    def at(self, key):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PairQuantityQuantityHandle h_ret
        h_ret = c_api.Vector_at(self.handle, <c_api.ConnectionHandle>key.handle)
        if h_ret == <c_api.PairQuantityQuantityHandle>0:
            return None
        return PairQuantityQuantity.from_capi(PairQuantityQuantity, h_ret)

    def erase(self, key):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Vector_erase(self.handle, <c_api.ConnectionHandle>key.handle)

    def size(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Vector_size(self.handle)

    def empty(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Vector_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Vector_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Vector_contains(self.handle, <c_api.ConnectionHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionHandle h_ret
        h_ret = c_api.Vector_keys(self.handle)
        if h_ret == <c_api.ListConnectionHandle>0:
            return None
        return ListConnection.from_capi(ListConnection, h_ret)

    def values(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairQuantityQuantityHandle h_ret
        h_ret = c_api.Vector_values(self.handle)
        if h_ret == <c_api.ListPairQuantityQuantityHandle>0:
            return None
        return ListPairQuantityQuantity.from_capi(ListPairQuantityQuantity, h_ret)

    def items(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairConnectionPairQuantityQuantityHandle h_ret
        h_ret = c_api.Vector_items(self.handle)
        if h_ret == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            return None
        return ListPairConnectionPairQuantityQuantity.from_capi(ListPairConnectionPairQuantityQuantity, h_ret)

    def addition(self, other):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_addition(self.handle, <c_api.VectorHandle>other.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def __add__(self, other):
        return self.addition(other)

    def subtraction(self, other):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_subtraction(self.handle, <c_api.VectorHandle>other.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def __sub__(self, other):
        return self.subtraction(other)

    def double_multiplication(self, scalar):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_double_multiplication(self.handle, scalar)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def int_multiplication(self, scalar):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_int_multiplication(self.handle, scalar)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def double_division(self, scalar):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_double_division(self.handle, scalar)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def int_division(self, scalar):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_int_division(self.handle, scalar)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def negation(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_negation(self.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def __neg__(self):
        return self.negation()

    def update_start_from_states(self, state):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_update_start_from_states(self.handle, <c_api.DeviceVoltageStatesHandle>state.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def translate_doubles(self, point, unit):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_translate_doubles(self.handle, <c_api.MapConnectionDoubleHandle>point.handle, <c_api.SymbolUnitHandle>unit.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def translate_quantities(self, point):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_translate_quantities(self.handle, <c_api.MapConnectionQuantityHandle>point.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def translate(self, point):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_translate(self.handle, <c_api.PointHandle>point.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def translate_to_origin(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_translate_to_origin(self.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def double_extend(self, extension):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_double_extend(self.handle, extension)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def int_extend(self, extension):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_int_extend(self.handle, extension)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def double_shrink(self, extension):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_double_shrink(self.handle, extension)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def int_shrink(self, extension):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_int_shrink(self.handle, extension)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def unit_vector(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_unit_vector(self.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def normalize(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_normalize(self.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def project(self, other):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.VectorHandle h_ret
        h_ret = c_api.Vector_project(self.handle, <c_api.VectorHandle>other.handle)
        if h_ret == <c_api.VectorHandle>0:
            return None
        return Vector.from_capi(Vector, h_ret)

    def update_unit(self, unit):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Vector_update_unit(self.handle, <c_api.SymbolUnitHandle>unit.handle)

    def equal(self, b):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Vector_equal(self.handle, <c_api.VectorHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Vector_not_equal(self.handle, <c_api.VectorHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.VectorHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Vector_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Vector _vector_from_capi(c_api.VectorHandle h):
    cdef Vector obj = <Vector>Vector.__new__(Vector)
    obj.handle = h