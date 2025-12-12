cimport _c_api

cdef class ListLabelledMeasuredArray1D:
    cdef _c_api.ListLabelledMeasuredArray1DHandle handle
    cdef bint owned

cdef ListLabelledMeasuredArray1D _list_labelled_measured_array1_d_from_capi(_c_api.ListLabelledMeasuredArray1DHandle h)