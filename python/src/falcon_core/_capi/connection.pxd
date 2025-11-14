# cython: language_level=3
# This file declares the C-level API of the connection.pyx module.

from . cimport c_api

# By declaring the class here, we make it available for cimport
# in other Cython modules.
cdef class Connection:
    # Only cdef attributes need to be declared here.
    cdef c_api.ConnectionHandle handle
