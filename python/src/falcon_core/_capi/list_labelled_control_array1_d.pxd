cimport _c_api

cdef class ListLabelledControlArray1D:
    cdef _c_api.ListLabelledControlArray1DHandle handle
    cdef bint owned

cdef ListLabelledControlArray1D _list_labelled_control_array1_d_from_capi(_c_api.ListLabelledControlArray1DHandle h)