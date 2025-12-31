cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .device_voltage_states cimport DeviceVoltageStates, _device_voltage_states_from_capi
from .list_connection cimport ListConnection, _list_connection_from_capi
from .list_pair_connection_pair_quantity_quantity cimport ListPairConnectionPairQuantityQuantity, _list_pair_connection_pair_quantity_quantity_from_capi
from .list_pair_quantity_quantity cimport ListPairQuantityQuantity, _list_pair_quantity_quantity_from_capi
from .map_connection_double cimport MapConnectionDouble, _map_connection_double_from_capi
from .map_connection_quantity cimport MapConnectionQuantity, _map_connection_quantity_from_capi
from .pair_quantity_quantity cimport PairQuantityQuantity, _pair_quantity_quantity_from_capi
from .point cimport Point, _point_from_capi
from .symbol_unit cimport SymbolUnit, _symbol_unit_from_capi

cdef class Vector:
    def __cinit__(self):
        self.handle = <_c_api.VectorHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.VectorHandle>0 and self.owned:
            _c_api.Vector_destroy(self.handle)
        self.handle = <_c_api.VectorHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    @classmethod
    def new(cls, Point start, Point end):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create(start.handle if start is not None else <_c_api.PointHandle>0, end.handle if end is not None else <_c_api.PointHandle>0)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_end(cls, Point end):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_end(end.handle if end is not None else <_c_api.PointHandle>0)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_quantities(cls, MapConnectionQuantity start, MapConnectionQuantity end):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_quantities(start.handle if start is not None else <_c_api.MapConnectionQuantityHandle>0, end.handle if end is not None else <_c_api.MapConnectionQuantityHandle>0)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_end_quantities(cls, MapConnectionQuantity end):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_end_quantities(end.handle if end is not None else <_c_api.MapConnectionQuantityHandle>0)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_doubles(cls, MapConnectionDouble start, MapConnectionDouble end, SymbolUnit unit):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_doubles(start.handle if start is not None else <_c_api.MapConnectionDoubleHandle>0, end.handle if end is not None else <_c_api.MapConnectionDoubleHandle>0, unit.handle if unit is not None else <_c_api.SymbolUnitHandle>0)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_end_doubles(cls, MapConnectionDouble end, SymbolUnit unit):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_end_doubles(end.handle if end is not None else <_c_api.MapConnectionDoubleHandle>0, unit.handle if unit is not None else <_c_api.SymbolUnitHandle>0)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_parent(cls, MapConnectionQuantity items):
        cdef _c_api.VectorHandle h
        h = _c_api.Vector_create_from_parent(items.handle if items is not None else <_c_api.MapConnectionQuantityHandle>0)
        if h == <_c_api.VectorHandle>0:
            raise MemoryError("Failed to create Vector")
        cdef Vector obj = <Vector>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_copy(self.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def equal(self, Vector other):
        return _c_api.Vector_equal(self.handle, other.handle if other is not None else <_c_api.VectorHandle>0)

    def __eq__(self, Vector other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Vector other):
        return _c_api.Vector_not_equal(self.handle, other.handle if other is not None else <_c_api.VectorHandle>0)

    def __ne__(self, Vector other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Vector_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def end_point(self, ):
        cdef _c_api.PointHandle h_ret = _c_api.Vector_end_point(self.handle)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return _point_from_capi(h_ret, owned=True)

    def start_point(self, ):
        cdef _c_api.PointHandle h_ret = _c_api.Vector_start_point(self.handle)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return _point_from_capi(h_ret, owned=True)

    def end_quantities(self, ):
        cdef _c_api.MapConnectionQuantityHandle h_ret = _c_api.Vector_end_quantities(self.handle)
        if h_ret == <_c_api.MapConnectionQuantityHandle>0:
            return None
        return _map_connection_quantity_from_capi(h_ret, owned=True)

    def start_quantities(self, ):
        cdef _c_api.MapConnectionQuantityHandle h_ret = _c_api.Vector_start_quantities(self.handle)
        if h_ret == <_c_api.MapConnectionQuantityHandle>0:
            return None
        return _map_connection_quantity_from_capi(h_ret, owned=True)

    def end_map(self, ):
        cdef _c_api.MapConnectionDoubleHandle h_ret = _c_api.Vector_end_map(self.handle)
        if h_ret == <_c_api.MapConnectionDoubleHandle>0:
            return None
        return _map_connection_double_from_capi(h_ret, owned=True)

    def start_map(self, ):
        cdef _c_api.MapConnectionDoubleHandle h_ret = _c_api.Vector_start_map(self.handle)
        if h_ret == <_c_api.MapConnectionDoubleHandle>0:
            return None
        return _map_connection_double_from_capi(h_ret, owned=True)

    def connections(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.Vector_connections(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret, owned=False)

    def unit(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.Vector_unit(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret, owned=False)

    def principle_connection(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Vector_principle_connection(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=True)

    def magnitude(self, ):
        return _c_api.Vector_magnitude(self.handle)

    def insert_or_assign(self, Connection key, PairQuantityQuantity value):
        _c_api.Vector_insert_or_assign(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0, value.handle if value is not None else <_c_api.PairQuantityQuantityHandle>0)

    def insert(self, Connection key, PairQuantityQuantity value):
        _c_api.Vector_insert(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0, value.handle if value is not None else <_c_api.PairQuantityQuantityHandle>0)

    def at(self, Connection key):
        cdef _c_api.PairQuantityQuantityHandle h_ret = _c_api.Vector_at(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.PairQuantityQuantityHandle>0:
            return None
        return _pair_quantity_quantity_from_capi(h_ret, owned=False)

    def erase(self, Connection key):
        _c_api.Vector_erase(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)

    def size(self, ):
        return _c_api.Vector_size(self.handle)

    def empty(self, ):
        return _c_api.Vector_empty(self.handle)

    def clear(self, ):
        _c_api.Vector_clear(self.handle)

    def contains(self, Connection key):
        return _c_api.Vector_contains(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)

    def keys(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.Vector_keys(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret, owned=False)

    def values(self, ):
        cdef _c_api.ListPairQuantityQuantityHandle h_ret = _c_api.Vector_values(self.handle)
        if h_ret == <_c_api.ListPairQuantityQuantityHandle>0:
            return None
        return _list_pair_quantity_quantity_from_capi(h_ret, owned=False)

    def items(self, ):
        cdef _c_api.ListPairConnectionPairQuantityQuantityHandle h_ret = _c_api.Vector_items(self.handle)
        if h_ret == <_c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            return None
        return _list_pair_connection_pair_quantity_quantity_from_capi(h_ret, owned=False)

    def addition(self, Vector other):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_addition(self.handle, other.handle if other is not None else <_c_api.VectorHandle>0)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def __add__(self, Vector other):
        return self.addition(other)

    def subtraction(self, Vector other):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_subtraction(self.handle, other.handle if other is not None else <_c_api.VectorHandle>0)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def __sub__(self, Vector other):
        return self.subtraction(other)

    def double_multiplication(self, double scalar):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_double_multiplication(self.handle, scalar)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def int_multiplication(self, int scalar):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_int_multiplication(self.handle, scalar)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def double_division(self, double scalar):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_double_division(self.handle, scalar)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def int_division(self, int scalar):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_int_division(self.handle, scalar)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def negation(self, ):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_negation(self.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def __neg__(self):
        return self.negation()

    def update_start_from_states(self, DeviceVoltageStates state):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_update_start_from_states(self.handle, state.handle if state is not None else <_c_api.DeviceVoltageStatesHandle>0)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def translate_doubles(self, MapConnectionDouble point, SymbolUnit unit):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_translate_doubles(self.handle, point.handle if point is not None else <_c_api.MapConnectionDoubleHandle>0, unit.handle if unit is not None else <_c_api.SymbolUnitHandle>0)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def translate_quantities(self, MapConnectionQuantity point):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_translate_quantities(self.handle, point.handle if point is not None else <_c_api.MapConnectionQuantityHandle>0)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def translate(self, Point point):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_translate(self.handle, point.handle if point is not None else <_c_api.PointHandle>0)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def translate_to_origin(self, ):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_translate_to_origin(self.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def double_extend(self, double extension):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_double_extend(self.handle, extension)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def int_extend(self, int extension):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_int_extend(self.handle, extension)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def double_shrink(self, double extension):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_double_shrink(self.handle, extension)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def int_shrink(self, int extension):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_int_shrink(self.handle, extension)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def unit_vector(self, ):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_unit_vector(self.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def normalize(self, ):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_normalize(self.handle)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def project(self, Vector other):
        cdef _c_api.VectorHandle h_ret = _c_api.Vector_project(self.handle, other.handle if other is not None else <_c_api.VectorHandle>0)
        if h_ret == <_c_api.VectorHandle>0:
            return None
        return _vector_from_capi(h_ret, owned=(h_ret != <_c_api.VectorHandle>self.handle))

    def update_unit(self, SymbolUnit unit):
        _c_api.Vector_update_unit(self.handle, unit.handle if unit is not None else <_c_api.SymbolUnitHandle>0)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

cdef Vector _vector_from_capi(_c_api.VectorHandle h, bint owned=True):
    if h == <_c_api.VectorHandle>0:
        return None
    cdef Vector obj = Vector.__new__(Vector)
    obj.handle = h
    obj.owned = owned
    return obj
