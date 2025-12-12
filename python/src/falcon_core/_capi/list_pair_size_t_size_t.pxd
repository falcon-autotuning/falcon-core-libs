cimport _c_api

cdef class ListPairSizeTSizeT:
    cdef _c_api.ListPairSizeTSizeTHandle handle
    cdef bint owned

cdef ListPairSizeTSizeT _list_pair_size_t_size_t_from_capi(_c_api.ListPairSizeTSizeTHandle h)