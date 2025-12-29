cimport _c_api

cdef class ListPairConnectionPairQuantityQuantity:
    cdef _c_api.ListPairConnectionPairQuantityQuantityHandle handle
    cdef bint owned

cdef ListPairConnectionPairQuantityQuantity _list_pair_connection_pair_quantity_quantity_from_capi(_c_api.ListPairConnectionPairQuantityQuantityHandle h, bint owned=*)