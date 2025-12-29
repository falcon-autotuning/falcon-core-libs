cimport _c_api

cdef class ListPairConnectionFloat:
    cdef _c_api.ListPairConnectionFloatHandle handle
    cdef bint owned

cdef ListPairConnectionFloat _list_pair_connection_float_from_capi(_c_api.ListPairConnectionFloatHandle h, bint owned=*)