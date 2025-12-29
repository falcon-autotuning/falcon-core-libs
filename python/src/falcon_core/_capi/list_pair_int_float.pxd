cimport _c_api

cdef class ListPairIntFloat:
    cdef _c_api.ListPairIntFloatHandle handle
    cdef bint owned

cdef ListPairIntFloat _list_pair_int_float_from_capi(_c_api.ListPairIntFloatHandle h, bint owned=*)