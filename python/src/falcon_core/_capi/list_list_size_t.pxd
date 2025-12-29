cimport _c_api

cdef class ListListSizeT:
    cdef _c_api.ListListSizeTHandle handle
    cdef bint owned

cdef ListListSizeT _list_list_size_t_from_capi(_c_api.ListListSizeTHandle h, bint owned=*)