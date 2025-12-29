cimport _c_api

cdef class ListControlArray1D:
    cdef _c_api.ListControlArray1DHandle handle
    cdef bint owned

cdef ListControlArray1D _list_control_array1_d_from_capi(_c_api.ListControlArray1DHandle h, bint owned=*)