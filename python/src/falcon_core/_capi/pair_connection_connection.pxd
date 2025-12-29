cimport _c_api

cdef class PairConnectionConnection:
    cdef _c_api.PairConnectionConnectionHandle handle
    cdef bint owned

cdef PairConnectionConnection _pair_connection_connection_from_capi(_c_api.PairConnectionConnectionHandle h, bint owned=*)