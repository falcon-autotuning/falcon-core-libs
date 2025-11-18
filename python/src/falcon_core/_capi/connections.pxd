# cython: language_level=3
from . cimport c_api

cdef Connections _connections_from_capi(c_api.ConnectionsHandle h)

cdef class Connections:
    cdef c_api.ConnectionsHandle handle
    cdef bint owned
    cdef Connections from_capi(Connections cls, c_api.ConnectionsHandle h)
