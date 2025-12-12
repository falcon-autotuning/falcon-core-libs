cimport _c_api

cdef class MapConnectionQuantity:
    cdef _c_api.MapConnectionQuantityHandle handle
    cdef bint owned

cdef MapConnectionQuantity _map_connection_quantity_from_capi(_c_api.MapConnectionQuantityHandle h)