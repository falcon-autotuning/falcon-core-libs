cimport _c_api

cdef class Impedance:
    cdef _c_api.ImpedanceHandle handle
    cdef bint owned

cdef Impedance _impedance_from_capi(_c_api.ImpedanceHandle h, bint owned=*)