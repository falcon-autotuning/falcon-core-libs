cimport _c_api

cdef class PairConnectionPairQuantityQuantity:
    cdef _c_api.PairConnectionPairQuantityQuantityHandle handle
    cdef bint owned

cdef PairConnectionPairQuantityQuantity _pair_connection_pair_quantity_quantity_from_capi(_c_api.PairConnectionPairQuantityQuantityHandle h)