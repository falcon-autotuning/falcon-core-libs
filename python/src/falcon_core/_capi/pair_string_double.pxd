cimport _c_api

cdef class PairStringDouble:
    cdef _c_api.PairStringDoubleHandle handle
    cdef bint owned

cdef PairStringDouble _pair_string_double_from_capi(_c_api.PairStringDoubleHandle h, bint owned=*)