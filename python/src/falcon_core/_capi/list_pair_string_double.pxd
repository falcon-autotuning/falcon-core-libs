cimport _c_api

cdef class ListPairStringDouble:
    cdef _c_api.ListPairStringDoubleHandle handle
    cdef bint owned

cdef ListPairStringDouble _list_pair_string_double_from_capi(_c_api.ListPairStringDoubleHandle h, bint owned=*)