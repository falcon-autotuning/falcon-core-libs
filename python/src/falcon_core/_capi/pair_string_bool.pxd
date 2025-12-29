cimport _c_api

cdef class PairStringBool:
    cdef _c_api.PairStringBoolHandle handle
    cdef bint owned

cdef PairStringBool _pair_string_bool_from_capi(_c_api.PairStringBoolHandle h, bint owned=*)