cimport _c_api

cdef class Connection:
    cdef _c_api.ConnectionHandle handle
    cdef bint owned

cdef Connection _connection_from_capi(_c_api.ConnectionHandle h)