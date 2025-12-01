cimport _c_api

cdef class ListDeviceVoltageState:
    cdef _c_api.ListDeviceVoltageStateHandle handle
    cdef bint owned

cdef ListDeviceVoltageState _list_device_voltage_state_from_capi(_c_api.ListDeviceVoltageStateHandle h)