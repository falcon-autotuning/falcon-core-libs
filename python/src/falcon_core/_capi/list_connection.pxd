# cython: language_level=3
from . cimport c_api

cdef class ListConnection:
    cdef c_api.ListConnectionHandle handle
