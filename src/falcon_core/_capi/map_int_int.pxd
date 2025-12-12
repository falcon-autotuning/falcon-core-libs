cimport _c_api

cdef class MapIntInt:
    cdef _c_api.MapIntIntHandle handle
    cdef bint owned

cdef MapIntInt _map_int_int_from_capi(_c_api.MapIntIntHandle h)