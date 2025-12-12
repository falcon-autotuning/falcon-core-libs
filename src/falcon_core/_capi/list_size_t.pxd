cimport _c_api

cdef class ListSizeT:
    cdef _c_api.ListSizeTHandle handle
    cdef bint owned

cdef ListSizeT _list_size_t_from_capi(_c_api.ListSizeTHandle h)