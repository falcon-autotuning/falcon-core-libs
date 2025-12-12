cimport _c_api

cdef class ListPairStringBool:
    cdef _c_api.ListPairStringBoolHandle handle
    cdef bint owned

cdef ListPairStringBool _list_pair_string_bool_from_capi(_c_api.ListPairStringBoolHandle h)