cimport _c_api

cdef class AxesLabelledMeasuredArray1D:
    cdef _c_api.AxesLabelledMeasuredArray1DHandle handle
    cdef bint owned

cdef AxesLabelledMeasuredArray1D _axes_labelled_measured_array1_d_from_capi(_c_api.AxesLabelledMeasuredArray1DHandle h)