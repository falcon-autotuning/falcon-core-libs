cimport _c_api

cdef class Time:
    cdef _c_api.TimeHandle handle
    cdef bint owned

cdef Time _time_from_capi(_c_api.TimeHandle h)