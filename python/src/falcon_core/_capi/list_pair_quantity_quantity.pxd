cimport _c_api

cdef class ListPairQuantityQuantity:
    cdef _c_api.ListPairQuantityQuantityHandle handle
    cdef bint owned

cdef ListPairQuantityQuantity _list_pair_quantity_quantity_from_capi(_c_api.ListPairQuantityQuantityHandle h, bint owned=*)