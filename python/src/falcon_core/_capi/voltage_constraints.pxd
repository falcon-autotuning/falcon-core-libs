cimport _c_api

cdef class VoltageConstraints:
    cdef _c_api.VoltageConstraintsHandle handle
    cdef bint owned

cdef VoltageConstraints _voltage_constraints_from_capi(_c_api.VoltageConstraintsHandle h)