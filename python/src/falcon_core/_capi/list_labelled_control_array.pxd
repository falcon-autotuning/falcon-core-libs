cimport _c_api

cdef class ListLabelledControlArray:
    cdef _c_api.ListLabelledControlArrayHandle handle
    cdef bint owned

cdef ListLabelledControlArray _list_labelled_control_array_from_capi(_c_api.ListLabelledControlArrayHandle h, bint owned=*)