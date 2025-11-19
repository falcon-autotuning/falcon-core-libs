from . cimport c_api

cdef MapIntInt _mapintint_from_capi(c_api.MapIntIntHandle h)

cdef class MapIntInt:
    cdef c_api.MapIntIntHandle handle
    cdef bint owned
    cdef MapIntInt from_capi(MapIntInt cls, c_api.MapIntIntHandle h)
