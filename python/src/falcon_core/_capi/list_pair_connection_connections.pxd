cimport _c_api

cdef class ListPairConnectionConnections:
    cdef _c_api.ListPairConnectionConnectionsHandle handle
    cdef bint owned

cdef ListPairConnectionConnections _list_pair_connection_connections_from_capi(_c_api.ListPairConnectionConnectionsHandle h, bint owned=*)