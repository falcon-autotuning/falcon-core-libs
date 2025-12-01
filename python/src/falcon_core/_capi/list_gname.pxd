cimport _c_api

cdef class ListGname:
    cdef _c_api.ListGnameHandle handle
    cdef bint owned

cdef ListGname _list_gname_from_capi(_c_api.ListGnameHandle h)