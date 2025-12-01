cimport _c_api

cdef class ListPairFloatFloat:
    cdef _c_api.ListPairFloatFloatHandle handle
    cdef bint owned

cdef ListPairFloatFloat _list_pair_float_float_from_capi(_c_api.ListPairFloatFloatHandle h)