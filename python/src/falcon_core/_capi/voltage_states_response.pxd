cimport _c_api

cdef class VoltageStatesResponse:
    cdef _c_api.VoltageStatesResponseHandle handle
    cdef bint owned

cdef VoltageStatesResponse _voltage_states_response_from_capi(_c_api.VoltageStatesResponseHandle h)