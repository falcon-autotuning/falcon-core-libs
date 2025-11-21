# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .symbol_unit cimport SymbolUnit

cdef class Quantity:
    cdef c_api.QuantityHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.QuantityHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.QuantityHandle>0 and self.owned:
            c_api.Quantity_destroy(self.handle)
        self.handle = <c_api.QuantityHandle>0

    cdef Quantity from_capi(cls, c_api.QuantityHandle h):
        cdef Quantity obj = <Quantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, value, unit):
        cdef c_api.QuantityHandle h
        h = c_api.Quantity_create(value, <c_api.SymbolUnitHandle>unit.handle)
        if h == <c_api.QuantityHandle>0:
            raise MemoryError("Failed to create Quantity")
        cdef Quantity obj = <Quantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.QuantityHandle h
        try:
            h = c_api.Quantity_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.QuantityHandle>0:
            raise MemoryError("Failed to create Quantity")
        cdef Quantity obj = <Quantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def value(self):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Quantity_value(self.handle)

    def unit(self):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.Quantity_unit(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def convert_to(self, target_unit):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Quantity_convert_to(self.handle, <c_api.SymbolUnitHandle>target_unit.handle)

    def multiply_int(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_multiply_int(self.handle, other)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def multiply_double(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_multiply_double(self.handle, other)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def multiply_quantity(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_multiply_quantity(self.handle, <c_api.QuantityHandle>other.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def multiply_equals_int(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_multiply_equals_int(self.handle, other)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def multiply_equals_double(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_multiply_equals_double(self.handle, other)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def multiply_equals_quantity(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_multiply_equals_quantity(self.handle, <c_api.QuantityHandle>other.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def divide_int(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_divide_int(self.handle, other)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def divide_double(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_divide_double(self.handle, other)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def divide_quantity(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_divide_quantity(self.handle, <c_api.QuantityHandle>other.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def divide_equals_int(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_divide_equals_int(self.handle, other)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def divide_equals_double(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_divide_equals_double(self.handle, other)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def divide_equals_quantity(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_divide_equals_quantity(self.handle, <c_api.QuantityHandle>other.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def power(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_power(self.handle, other)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def add_quantity(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_add_quantity(self.handle, <c_api.QuantityHandle>other.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def add_equals_quantity(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_add_equals_quantity(self.handle, <c_api.QuantityHandle>other.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def subtract_quantity(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_subtract_quantity(self.handle, <c_api.QuantityHandle>other.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def subtract_equals_quantity(self, other):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_subtract_equals_quantity(self.handle, <c_api.QuantityHandle>other.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def negate(self):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_negate(self.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def abs(self):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.QuantityHandle h_ret
        h_ret = c_api.Quantity_abs(self.handle)
        if h_ret == <c_api.QuantityHandle>0:
            return None
        return Quantity.from_capi(Quantity, h_ret)

    def equal(self, b):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Quantity_equal(self.handle, <c_api.QuantityHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Quantity_not_equal(self.handle, <c_api.QuantityHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.QuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Quantity_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Quantity _quantity_from_capi(c_api.QuantityHandle h):
    cdef Quantity obj = <Quantity>Quantity.__new__(Quantity)
    obj.handle = h