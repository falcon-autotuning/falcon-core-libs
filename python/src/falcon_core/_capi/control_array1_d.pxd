cimport _c_api

cdef class ControlArray1D:
    cdef _c_api.ControlArray1DHandle handle
    cdef bint owned

cdef ControlArray1D _control_array1_d_from_capi(_c_api.ControlArray1DHandle h, bint owned=*)