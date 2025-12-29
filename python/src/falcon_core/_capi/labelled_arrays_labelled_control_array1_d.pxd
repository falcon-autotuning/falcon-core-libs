cimport _c_api

cdef class LabelledArraysLabelledControlArray1D:
    cdef _c_api.LabelledArraysLabelledControlArray1DHandle handle
    cdef bint owned

cdef LabelledArraysLabelledControlArray1D _labelled_arrays_labelled_control_array1_d_from_capi(_c_api.LabelledArraysLabelledControlArray1DHandle h, bint owned=*)