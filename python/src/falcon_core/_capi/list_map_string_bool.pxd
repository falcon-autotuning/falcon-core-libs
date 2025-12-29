cimport _c_api

cdef class ListMapStringBool:
    cdef _c_api.ListMapStringBoolHandle handle
    cdef bint owned

cdef ListMapStringBool _list_map_string_bool_from_capi(_c_api.ListMapStringBoolHandle h, bint owned=*)