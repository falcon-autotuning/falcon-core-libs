cimport _c_api

cdef class AxesLabelledControlArray:
    cdef _c_api.AxesLabelledControlArrayHandle handle
    cdef bint owned

cdef AxesLabelledControlArray _axes_labelled_control_array_from_capi(_c_api.AxesLabelledControlArrayHandle h)