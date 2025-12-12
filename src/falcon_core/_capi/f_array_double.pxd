cimport _c_api

cdef class FArrayDouble:
    cdef _c_api.FArrayDoubleHandle handle
    cdef bint owned

cdef FArrayDouble _f_array_double_from_capi(_c_api.FArrayDoubleHandle h)