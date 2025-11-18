# cython: language_level=3
# This file declares the C-level API of the connection.pyx module.

from . cimport c_api

# Module-level factory to construct a cdef Connection from a raw C handle.
cdef Connection _connection_from_capi(c_api.ConnectionHandle h)

# By declaring the class here, we make it available for cimport
# in other Cython modules.
cdef class Connection:
    # Only cdef attributes need to be declared here.
    cdef c_api.ConnectionHandle handle
    cdef Connection from_capi(Connection cls, c_api.ConnectionHandle h)
