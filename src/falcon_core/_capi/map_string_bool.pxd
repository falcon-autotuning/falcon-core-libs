cimport _c_api

cdef class MapStringBool:
    cdef _c_api.MapStringBoolHandle handle
    cdef bint owned

cdef MapStringBool _map_string_bool_from_capi(_c_api.MapStringBoolHandle h)