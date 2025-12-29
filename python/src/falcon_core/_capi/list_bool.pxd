cimport _c_api

cdef class ListBool:
    cdef _c_api.ListBoolHandle handle
    cdef bint owned

cdef ListBool _list_bool_from_capi(_c_api.ListBoolHandle h, bint owned=*)