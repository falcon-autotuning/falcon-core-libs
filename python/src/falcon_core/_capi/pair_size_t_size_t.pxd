cimport _c_api

cdef class PairSizeTSizeT:
    cdef _c_api.PairSizeTSizeTHandle handle
    cdef bint owned

cdef PairSizeTSizeT _pair_size_t_size_t_from_capi(_c_api.PairSizeTSizeTHandle h)