cimport _c_api

cdef class ListControlArray:
    cdef _c_api.ListControlArrayHandle handle
    cdef bint owned

cdef ListControlArray _list_control_array_from_capi(_c_api.ListControlArrayHandle h)