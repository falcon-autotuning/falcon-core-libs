cimport _c_api

cdef class Connections:
    cdef _c_api.ConnectionsHandle handle
    cdef bint owned

cdef Connections _connections_from_capi(_c_api.ConnectionsHandle h, bint owned=*)