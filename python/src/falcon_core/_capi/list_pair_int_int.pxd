cimport _c_api

cdef class ListPairIntInt:
    cdef _c_api.ListPairIntIntHandle handle
    cdef bint owned

cdef ListPairIntInt _list_pair_int_int_from_capi(_c_api.ListPairIntIntHandle h, bint owned=*)