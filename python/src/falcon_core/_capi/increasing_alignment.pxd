cimport _c_api

cdef class IncreasingAlignment:
    cdef _c_api.IncreasingAlignmentHandle handle
    cdef bint owned

cdef IncreasingAlignment _increasing_alignment_from_capi(_c_api.IncreasingAlignmentHandle h, bint owned=*)