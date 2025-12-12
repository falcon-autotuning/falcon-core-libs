cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport symbol_unit

cdef class DeviceVoltageState:
    def __cinit__(self):
        self.handle = <_c_api.DeviceVoltageStateHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.DeviceVoltageStateHandle>0 and self.owned:
            _c_api.DeviceVoltageState_destroy(self.handle)
        self.handle = <_c_api.DeviceVoltageStateHandle>0


cdef DeviceVoltageState _device_voltage_state_from_capi(_c_api.DeviceVoltageStateHandle h):
    if h == <_c_api.DeviceVoltageStateHandle>0:
        return None
    cdef DeviceVoltageState obj = DeviceVoltageState.__new__(DeviceVoltageState)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, Connection connection, double voltage, SymbolUnit unit):
        cdef _c_api.DeviceVoltageStateHandle h
        h = _c_api.DeviceVoltageState_create(connection.handle, voltage, unit.handle)
        if h == <_c_api.DeviceVoltageStateHandle>0:
            raise MemoryError("Failed to create DeviceVoltageState")
        cdef DeviceVoltageState obj = <DeviceVoltageState>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.DeviceVoltageStateHandle h
        try:
            h = _c_api.DeviceVoltageState_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.DeviceVoltageStateHandle>0:
            raise MemoryError("Failed to create DeviceVoltageState")
        cdef DeviceVoltageState obj = <DeviceVoltageState>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def connection(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.DeviceVoltageState_connection(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def voltage(self, ):
        return _c_api.DeviceVoltageState_voltage(self.handle)

    def value(self, ):
        return _c_api.DeviceVoltageState_value(self.handle)

    def unit(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.DeviceVoltageState_unit(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return symbol_unit._symbol_unit_from_capi(h_ret)

    def convert_to(self, SymbolUnit target_unit):
        _c_api.DeviceVoltageState_convert_to(self.handle, target_unit.handle)

    def multiply_int(self, int other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_multiply_int(self.handle, other)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def multiply_double(self, double other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_multiply_double(self.handle, other)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def multiply_quantity(self, DeviceVoltageState other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_multiply_quantity(self.handle, other.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def multiply_equals_int(self, int other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_multiply_equals_int(self.handle, other)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def multiply_equals_double(self, double other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_multiply_equals_double(self.handle, other)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def multiply_equals_quantity(self, DeviceVoltageState other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_multiply_equals_quantity(self.handle, other.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def divide_int(self, int other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_divide_int(self.handle, other)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def divide_double(self, double other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_divide_double(self.handle, other)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def divide_quantity(self, DeviceVoltageState other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_divide_quantity(self.handle, other.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def divide_equals_int(self, int other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_divide_equals_int(self.handle, other)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def divide_equals_double(self, double other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_divide_equals_double(self.handle, other)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def divide_equals_quantity(self, DeviceVoltageState other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_divide_equals_quantity(self.handle, other.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def power(self, int other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_power(self.handle, other)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def add_quantity(self, DeviceVoltageState other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_add_quantity(self.handle, other.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def add_equals_quantity(self, DeviceVoltageState other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_add_equals_quantity(self.handle, other.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def subtract_quantity(self, DeviceVoltageState other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_subtract_quantity(self.handle, other.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def subtract_equals_quantity(self, DeviceVoltageState other):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_subtract_equals_quantity(self.handle, other.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def negate(self, ):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_negate(self.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def abs(self, ):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageState_abs(self.handle)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret)

    def equal(self, DeviceVoltageState b):
        return _c_api.DeviceVoltageState_equal(self.handle, b.handle)

    def __eq__(self, DeviceVoltageState b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, DeviceVoltageState b):
        return _c_api.DeviceVoltageState_not_equal(self.handle, b.handle)

    def __ne__(self, DeviceVoltageState b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
