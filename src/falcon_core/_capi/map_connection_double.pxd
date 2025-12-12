cimport _c_api

cdef class MapConnectionDouble:
    cdef _c_api.MapConnectionDoubleHandle handle
    cdef bint owned

cdef MapConnectionDouble _map_connection_double_from_capi(_c_api.MapConnectionDoubleHandle h)