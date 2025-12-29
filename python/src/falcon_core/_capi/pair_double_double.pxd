cimport _c_api

cdef class PairDoubleDouble:
    cdef _c_api.PairDoubleDoubleHandle handle
    cdef bint owned

cdef PairDoubleDouble _pair_double_double_from_capi(_c_api.PairDoubleDoubleHandle h, bint owned=*)