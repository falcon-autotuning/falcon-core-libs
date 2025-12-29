cimport _c_api

cdef class AxesDouble:
    cdef _c_api.AxesDoubleHandle handle
    cdef bint owned

cdef AxesDouble _axes_double_from_capi(_c_api.AxesDoubleHandle h, bint owned=*)