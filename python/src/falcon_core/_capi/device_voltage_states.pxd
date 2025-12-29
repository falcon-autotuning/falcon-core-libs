cimport _c_api

cdef class DeviceVoltageStates:
    cdef _c_api.DeviceVoltageStatesHandle handle
    cdef bint owned

cdef DeviceVoltageStates _device_voltage_states_from_capi(_c_api.DeviceVoltageStatesHandle h, bint owned=*)