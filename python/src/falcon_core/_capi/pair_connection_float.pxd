cimport _c_api

cdef class PairConnectionFloat:
    cdef _c_api.PairConnectionFloatHandle handle
    cdef bint owned

cdef PairConnectionFloat _pair_connection_float_from_capi(_c_api.PairConnectionFloatHandle h)