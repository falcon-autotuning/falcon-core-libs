cimport _c_api

cdef class PairConnectionConnections:
    cdef _c_api.PairConnectionConnectionsHandle handle
    cdef bint owned

cdef PairConnectionConnections _pair_connection_connections_from_capi(_c_api.PairConnectionConnectionsHandle h)