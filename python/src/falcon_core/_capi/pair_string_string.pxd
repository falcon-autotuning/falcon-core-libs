cimport _c_api

cdef class PairStringString:
    cdef _c_api.PairStringStringHandle handle
    cdef bint owned

cdef PairStringString _pair_string_string_from_capi(_c_api.PairStringStringHandle h, bint owned=*)