cimport _c_api

cdef class PairQuantityQuantity:
    cdef _c_api.PairQuantityQuantityHandle handle
    cdef bint owned

cdef PairQuantityQuantity _pair_quantity_quantity_from_capi(_c_api.PairQuantityQuantityHandle h)