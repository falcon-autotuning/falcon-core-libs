cimport _c_api

cdef class LabelledArraysLabelledControlArray:
    cdef _c_api.LabelledArraysLabelledControlArrayHandle handle
    cdef bint owned

cdef LabelledArraysLabelledControlArray _labelled_arrays_labelled_control_array_from_capi(_c_api.LabelledArraysLabelledControlArrayHandle h, bint owned=*)