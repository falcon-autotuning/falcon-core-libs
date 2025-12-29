cimport _c_api

cdef class FArrayInt:
    cdef _c_api.FArrayIntHandle handle
    cdef bint owned

cdef FArrayInt _f_array_int_from_capi(_c_api.FArrayIntHandle h, bint owned=*)