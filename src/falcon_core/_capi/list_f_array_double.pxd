cimport _c_api

cdef class ListFArrayDouble:
    cdef _c_api.ListFArrayDoubleHandle handle
    cdef bint owned

cdef ListFArrayDouble _list_f_array_double_from_capi(_c_api.ListFArrayDoubleHandle h)