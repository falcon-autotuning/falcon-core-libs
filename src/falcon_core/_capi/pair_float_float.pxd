cimport _c_api

cdef class PairFloatFloat:
    cdef _c_api.PairFloatFloatHandle handle
    cdef bint owned

cdef PairFloatFloat _pair_float_float_from_capi(_c_api.PairFloatFloatHandle h)