cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .symbol_unit cimport SymbolUnit, _symbol_unit_from_capi

cdef class Quantity:
    def __cinit__(self):
        self.handle = <_c_api.QuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.QuantityHandle>0 and self.owned:
            _c_api.Quantity_destroy(self.handle)
        self.handle = <_c_api.QuantityHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.QuantityHandle h
        try:
            h = _c_api.Quantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.QuantityHandle>0:
            raise MemoryError("Failed to create Quantity")
        cdef Quantity obj = <Quantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, double value, SymbolUnit unit):
        cdef _c_api.QuantityHandle h
        h = _c_api.Quantity_create(value, unit.handle if unit is not None else <_c_api.SymbolUnitHandle>0)
        if h == <_c_api.QuantityHandle>0:
            raise MemoryError("Failed to create Quantity")
        cdef Quantity obj = <Quantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_copy(self.handle)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def equal(self, Quantity other):
        return _c_api.Quantity_equal(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)

    def __eq__(self, Quantity other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Quantity other):
        return _c_api.Quantity_not_equal(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)

    def __ne__(self, Quantity other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Quantity_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def value(self, ):
        return _c_api.Quantity_value(self.handle)

    def unit(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.Quantity_unit(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def convert_to(self, SymbolUnit target_unit):
        _c_api.Quantity_convert_to(self.handle, target_unit.handle if target_unit is not None else <_c_api.SymbolUnitHandle>0)

    def multiply_int(self, int other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_multiply_int(self.handle, other)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def multiply_double(self, double other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_multiply_double(self.handle, other)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def multiply_quantity(self, Quantity other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_multiply_quantity(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def multiply_equals_int(self, int other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_multiply_equals_int(self.handle, other)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def multiply_equals_double(self, double other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_multiply_equals_double(self.handle, other)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def multiply_equals_quantity(self, Quantity other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_multiply_equals_quantity(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def divide_int(self, int other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_divide_int(self.handle, other)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def divide_double(self, double other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_divide_double(self.handle, other)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def divide_quantity(self, Quantity other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_divide_quantity(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def divide_equals_int(self, int other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_divide_equals_int(self.handle, other)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def divide_equals_double(self, double other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_divide_equals_double(self.handle, other)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def divide_equals_quantity(self, Quantity other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_divide_equals_quantity(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def power(self, int other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_power(self.handle, other)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def add_quantity(self, Quantity other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_add_quantity(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def add_equals_quantity(self, Quantity other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_add_equals_quantity(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def subtract_quantity(self, Quantity other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_subtract_quantity(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def subtract_equals_quantity(self, Quantity other):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_subtract_equals_quantity(self.handle, other.handle if other is not None else <_c_api.QuantityHandle>0)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def negate(self, ):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_negate(self.handle)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

    def abs(self, ):
        cdef _c_api.QuantityHandle h_ret = _c_api.Quantity_abs(self.handle)
        if h_ret == <_c_api.QuantityHandle>0:
            return None
        return _quantity_from_capi(h_ret)

cdef Quantity _quantity_from_capi(_c_api.QuantityHandle h, bint owned=True):
    if h == <_c_api.QuantityHandle>0:
        return None
    cdef Quantity obj = Quantity.__new__(Quantity)
    obj.handle = h
    obj.owned = owned
    return obj
