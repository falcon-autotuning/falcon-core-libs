cimport _c_api

cdef class Discretizer:
    cdef _c_api.DiscretizerHandle handle
    cdef bint owned

cdef Discretizer _discretizer_from_capi(_c_api.DiscretizerHandle h, bint owned=*)