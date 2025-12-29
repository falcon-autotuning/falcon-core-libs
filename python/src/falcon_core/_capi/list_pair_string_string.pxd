cimport _c_api

cdef class ListPairStringString:
    cdef _c_api.ListPairStringStringHandle handle
    cdef bint owned

cdef ListPairStringString _list_pair_string_string_from_capi(_c_api.ListPairStringStringHandle h, bint owned=*)