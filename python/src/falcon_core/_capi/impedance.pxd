# cython: language_level=3
from . cimport c_api

cdef class Impedance:
    cdef c_api.ImpedanceHandle handle
    cdef bint owned
