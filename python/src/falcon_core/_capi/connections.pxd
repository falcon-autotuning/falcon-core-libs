# cython: language_level=3
from . cimport c_api

cdef class Connections:
    cdef c_api.ConnectionsHandle handle
    cdef bint owned
