cimport _c_api

cdef class MapStringString:
    cdef _c_api.MapStringStringHandle handle
    cdef bint owned

cdef MapStringString _map_string_string_from_capi(_c_api.MapStringStringHandle h)