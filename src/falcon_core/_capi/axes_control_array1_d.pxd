cimport _c_api

cdef class AxesControlArray1D:
    cdef _c_api.AxesControlArray1DHandle handle
    cdef bint owned

cdef AxesControlArray1D _axes_control_array1_d_from_capi(_c_api.AxesControlArray1DHandle h)