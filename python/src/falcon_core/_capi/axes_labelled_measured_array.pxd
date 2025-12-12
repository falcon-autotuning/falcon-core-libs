cimport _c_api

cdef class AxesLabelledMeasuredArray:
    cdef _c_api.AxesLabelledMeasuredArrayHandle handle
    cdef bint owned

cdef AxesLabelledMeasuredArray _axes_labelled_measured_array_from_capi(_c_api.AxesLabelledMeasuredArrayHandle h)