cimport _c_api

cdef class Impedances:
    cdef _c_api.ImpedancesHandle handle
    cdef bint owned

cdef Impedances _impedances_from_capi(_c_api.ImpedancesHandle h)