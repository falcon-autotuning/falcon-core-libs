# cython: language_level=3
from . cimport c_api

cdef ListConnection _listconnection_from_capi(c_api.ListConnectionHandle h)

cdef class ListConnection:
    cdef c_api.ListConnectionHandle handle
    cdef bint owned
    cdef ListConnection from_capi(ListConnection cls, c_api.ListConnectionHandle h)
