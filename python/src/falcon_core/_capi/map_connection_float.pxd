cimport _c_api

cdef class MapConnectionFloat:
    cdef _c_api.MapConnectionFloatHandle handle
    cdef bint owned

cdef MapConnectionFloat _map_connection_float_from_capi(_c_api.MapConnectionFloatHandle h)