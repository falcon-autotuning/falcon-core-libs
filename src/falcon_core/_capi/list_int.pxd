cimport _c_api

cdef class ListInt:
    cdef _c_api.ListIntHandle handle
    cdef bint owned

cdef ListInt _list_int_from_capi(_c_api.ListIntHandle h)