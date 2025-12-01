cimport _c_api

cdef class AxesLabelledControlArray1D:
    cdef _c_api.AxesLabelledControlArray1DHandle handle
    cdef bint owned

cdef AxesLabelledControlArray1D _axes_labelled_control_array1_d_from_capi(_c_api.AxesLabelledControlArray1DHandle h)