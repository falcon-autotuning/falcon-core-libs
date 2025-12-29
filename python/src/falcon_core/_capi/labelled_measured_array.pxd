cimport _c_api

cdef class LabelledMeasuredArray:
    cdef _c_api.LabelledMeasuredArrayHandle handle
    cdef bint owned

cdef LabelledMeasuredArray _labelled_measured_array_from_capi(_c_api.LabelledMeasuredArrayHandle h, bint owned=*)