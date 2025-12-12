cimport _c_api

cdef class AxesInt:
    cdef _c_api.AxesIntHandle handle
    cdef bint owned

cdef AxesInt _axes_int_from_capi(_c_api.AxesIntHandle h)