cimport _c_api

cdef class ListPairConnectionDouble:
    cdef _c_api.ListPairConnectionDoubleHandle handle
    cdef bint owned

cdef ListPairConnectionDouble _list_pair_connection_double_from_capi(_c_api.ListPairConnectionDoubleHandle h)