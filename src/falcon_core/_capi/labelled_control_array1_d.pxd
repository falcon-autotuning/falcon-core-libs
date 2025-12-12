cimport _c_api

cdef class LabelledControlArray1D:
    cdef _c_api.LabelledControlArray1DHandle handle
    cdef bint owned

cdef LabelledControlArray1D _labelled_control_array1_d_from_capi(_c_api.LabelledControlArray1DHandle h)