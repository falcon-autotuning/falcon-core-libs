cimport _c_api

cdef class PairConnectionQuantity:
    cdef _c_api.PairConnectionQuantityHandle handle
    cdef bint owned

cdef PairConnectionQuantity _pair_connection_quantity_from_capi(_c_api.PairConnectionQuantityHandle h)