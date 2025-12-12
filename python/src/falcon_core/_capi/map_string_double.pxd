cimport _c_api

cdef class MapStringDouble:
    cdef _c_api.MapStringDoubleHandle handle
    cdef bint owned

cdef MapStringDouble _map_string_double_from_capi(_c_api.MapStringDoubleHandle h)