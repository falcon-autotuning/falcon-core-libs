cimport _c_api

cdef class LabelledArraysLabelledMeasuredArray:
    cdef _c_api.LabelledArraysLabelledMeasuredArrayHandle handle
    cdef bint owned

cdef LabelledArraysLabelledMeasuredArray _labelled_arrays_labelled_measured_array_from_capi(_c_api.LabelledArraysLabelledMeasuredArrayHandle h, bint owned=*)