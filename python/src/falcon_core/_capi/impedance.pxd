# cython: language_level=3
from . cimport c_api

cdef Impedance _impedance_from_capi(c_api.ImpedanceHandle h)

cdef class Impedance:
    cdef c_api.ImpedanceHandle handle
    cdef bint owned
    cdef Impedance from_capi(Impedance cls, c_api.ImpedanceHandle h)
