cimport _c_api

cdef class DeviceVoltageState:
    cdef _c_api.DeviceVoltageStateHandle handle
    cdef bint owned

cdef DeviceVoltageState _device_voltage_state_from_capi(_c_api.DeviceVoltageStateHandle h)