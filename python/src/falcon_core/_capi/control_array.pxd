cimport _c_api

cdef class ControlArray:
    cdef _c_api.ControlArrayHandle handle
    cdef bint owned

cdef ControlArray _control_array_from_capi(_c_api.ControlArrayHandle h)