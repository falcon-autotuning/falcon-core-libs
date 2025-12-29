cimport _c_api

cdef class MapChannelConnections:
    cdef _c_api.MapChannelConnectionsHandle handle
    cdef bint owned

cdef MapChannelConnections _map_channel_connections_from_capi(_c_api.MapChannelConnectionsHandle h, bint owned=*)