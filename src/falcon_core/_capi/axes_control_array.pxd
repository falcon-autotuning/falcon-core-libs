cimport _c_api

cdef class AxesControlArray:
    cdef _c_api.AxesControlArrayHandle handle
    cdef bint owned

cdef AxesControlArray _axes_control_array_from_capi(_c_api.AxesControlArrayHandle h)