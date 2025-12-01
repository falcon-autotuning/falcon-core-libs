cimport _c_api

cdef class LabelledControlArray:
    cdef _c_api.LabelledControlArrayHandle handle
    cdef bint owned

cdef LabelledControlArray _labelled_control_array_from_capi(_c_api.LabelledControlArrayHandle h)