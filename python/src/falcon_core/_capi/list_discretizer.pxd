cimport _c_api

cdef class ListDiscretizer:
    cdef _c_api.ListDiscretizerHandle handle
    cdef bint owned

cdef ListDiscretizer _list_discretizer_from_capi(_c_api.ListDiscretizerHandle h)