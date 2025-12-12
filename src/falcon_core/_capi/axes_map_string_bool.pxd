cimport _c_api

cdef class AxesMapStringBool:
    cdef _c_api.AxesMapStringBoolHandle handle
    cdef bint owned

cdef AxesMapStringBool _axes_map_string_bool_from_capi(_c_api.AxesMapStringBoolHandle h)