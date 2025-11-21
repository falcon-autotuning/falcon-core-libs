# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .symbol_unit cimport SymbolUnit

cdef class DeviceVoltageState:
    cdef c_api.DeviceVoltageStateHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.DeviceVoltageStateHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.DeviceVoltageStateHandle>0 and self.owned:
            c_api.DeviceVoltageState_destroy(self.handle)
        self.handle = <c_api.DeviceVoltageStateHandle>0

    cdef DeviceVoltageState from_capi(cls, c_api.DeviceVoltageStateHandle h):
        cdef DeviceVoltageState obj = <DeviceVoltageState>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, connection, voltage, unit):
        cdef c_api.DeviceVoltageStateHandle h
        h = c_api.DeviceVoltageState_create(<c_api.ConnectionHandle>connection.handle, voltage, <c_api.SymbolUnitHandle>unit.handle)
        if h == <c_api.DeviceVoltageStateHandle>0:
            raise MemoryError("Failed to create DeviceVoltageState")
        cdef DeviceVoltageState obj = <DeviceVoltageState>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.DeviceVoltageStateHandle h
        try:
            h = c_api.DeviceVoltageState_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.DeviceVoltageStateHandle>0:
            raise MemoryError("Failed to create DeviceVoltageState")
        cdef DeviceVoltageState obj = <DeviceVoltageState>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def connection(self):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.DeviceVoltageState_connection(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def voltage(self):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageState_voltage(self.handle)

    def value(self):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageState_value(self.handle)

    def unit(self):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.DeviceVoltageState_unit(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def convert_to(self, target_unit):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DeviceVoltageState_convert_to(self.handle, <c_api.SymbolUnitHandle>target_unit.handle)

    def multiply_int(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_multiply_int(self.handle, other)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def multiply_double(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_multiply_double(self.handle, other)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def multiply_quantity(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_multiply_quantity(self.handle, <c_api.DeviceVoltageStateHandle>other.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def multiply_equals_int(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_multiply_equals_int(self.handle, other)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def multiply_equals_double(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_multiply_equals_double(self.handle, other)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def multiply_equals_quantity(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_multiply_equals_quantity(self.handle, <c_api.DeviceVoltageStateHandle>other.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def divide_int(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_divide_int(self.handle, other)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def divide_double(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_divide_double(self.handle, other)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def divide_quantity(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_divide_quantity(self.handle, <c_api.DeviceVoltageStateHandle>other.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def divide_equals_int(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_divide_equals_int(self.handle, other)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def divide_equals_double(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_divide_equals_double(self.handle, other)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def divide_equals_quantity(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_divide_equals_quantity(self.handle, <c_api.DeviceVoltageStateHandle>other.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def power(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_power(self.handle, other)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def add_quantity(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_add_quantity(self.handle, <c_api.DeviceVoltageStateHandle>other.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def add_equals_quantity(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_add_equals_quantity(self.handle, <c_api.DeviceVoltageStateHandle>other.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def subtract_quantity(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_subtract_quantity(self.handle, <c_api.DeviceVoltageStateHandle>other.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def subtract_equals_quantity(self, other):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_subtract_equals_quantity(self.handle, <c_api.DeviceVoltageStateHandle>other.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def negate(self):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_negate(self.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def abs(self):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageState_abs(self.handle)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def equal(self, b):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageState_equal(self.handle, <c_api.DeviceVoltageStateHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageState_not_equal(self.handle, <c_api.DeviceVoltageStateHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.DeviceVoltageStateHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.DeviceVoltageState_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef DeviceVoltageState _devicevoltagestate_from_capi(c_api.DeviceVoltageStateHandle h):
    cdef DeviceVoltageState obj = <DeviceVoltageState>DeviceVoltageState.__new__(DeviceVoltageState)
    obj.handle = h