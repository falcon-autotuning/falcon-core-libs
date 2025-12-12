cimport _c_api

cdef class ListConnections:
    cdef _c_api.ListConnectionsHandle handle
    cdef bint owned

cdef ListConnections _list_connections_from_capi(_c_api.ListConnectionsHandle h)