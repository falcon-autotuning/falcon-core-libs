cimport _c_api

cdef class PairIntFloat:
    cdef _c_api.PairIntFloatHandle handle
    cdef bint owned

cdef PairIntFloat _pair_int_float_from_capi(_c_api.PairIntFloatHandle h)