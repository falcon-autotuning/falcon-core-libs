cimport _c_api

cdef class MeasuredArray:
    cdef _c_api.MeasuredArrayHandle handle
    cdef bint owned

cdef MeasuredArray _measured_array_from_capi(_c_api.MeasuredArrayHandle h)