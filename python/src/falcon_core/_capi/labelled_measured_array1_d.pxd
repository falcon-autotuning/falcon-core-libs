cimport _c_api

cdef class LabelledMeasuredArray1D:
    cdef _c_api.LabelledMeasuredArray1DHandle handle
    cdef bint owned

cdef LabelledMeasuredArray1D _labelled_measured_array1_d_from_capi(_c_api.LabelledMeasuredArray1DHandle h, bint owned=*)