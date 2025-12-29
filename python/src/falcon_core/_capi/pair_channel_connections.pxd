cimport _c_api

cdef class PairChannelConnections:
    cdef _c_api.PairChannelConnectionsHandle handle
    cdef bint owned

cdef PairChannelConnections _pair_channel_connections_from_capi(_c_api.PairChannelConnectionsHandle h, bint owned=*)