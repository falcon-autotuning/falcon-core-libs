cimport _c_api

cdef class ListPairConnectionQuantity:
    cdef _c_api.ListPairConnectionQuantityHandle handle
    cdef bint owned

cdef ListPairConnectionQuantity _list_pair_connection_quantity_from_capi(_c_api.ListPairConnectionQuantityHandle h)