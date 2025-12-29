cimport _c_api

cdef class ListLabelledMeasuredArray:
    cdef _c_api.ListLabelledMeasuredArrayHandle handle
    cdef bint owned

cdef ListLabelledMeasuredArray _list_labelled_measured_array_from_capi(_c_api.ListLabelledMeasuredArrayHandle h, bint owned=*)