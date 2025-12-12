cimport _c_api

cdef class PairIntInt:
    cdef _c_api.PairIntIntHandle handle
    cdef bint owned

cdef PairIntInt _pair_int_int_from_capi(_c_api.PairIntIntHandle h)