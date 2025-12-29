cimport _c_api

cdef class ListQuantity:
    cdef _c_api.ListQuantityHandle handle
    cdef bint owned

cdef ListQuantity _list_quantity_from_capi(_c_api.ListQuantityHandle h, bint owned=*)