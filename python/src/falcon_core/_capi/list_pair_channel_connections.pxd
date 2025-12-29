cimport _c_api

cdef class ListPairChannelConnections:
    cdef _c_api.ListPairChannelConnectionsHandle handle
    cdef bint owned

cdef ListPairChannelConnections _list_pair_channel_connections_from_capi(_c_api.ListPairChannelConnectionsHandle h, bint owned=*)