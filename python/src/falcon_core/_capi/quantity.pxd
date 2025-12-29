cimport _c_api

cdef class Quantity:
    cdef _c_api.QuantityHandle handle
    cdef bint owned

cdef Quantity _quantity_from_capi(_c_api.QuantityHandle h, bint owned=*)