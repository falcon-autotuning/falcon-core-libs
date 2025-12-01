cimport _c_api

cdef class ListDouble:
    cdef _c_api.ListDoubleHandle handle
    cdef bint owned

cdef ListDouble _list_double_from_capi(_c_api.ListDoubleHandle h)