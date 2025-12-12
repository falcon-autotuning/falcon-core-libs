cimport _c_api

cdef class MeasuredArray1D:
    cdef _c_api.MeasuredArray1DHandle handle
    cdef bint owned

cdef MeasuredArray1D _measured_array1_d_from_capi(_c_api.MeasuredArray1DHandle h)