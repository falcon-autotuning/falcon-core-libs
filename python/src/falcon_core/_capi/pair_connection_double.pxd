cimport _c_api

cdef class PairConnectionDouble:
    cdef _c_api.PairConnectionDoubleHandle handle
    cdef bint owned

cdef PairConnectionDouble _pair_connection_double_from_capi(_c_api.PairConnectionDoubleHandle h, bint owned=*)