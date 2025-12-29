cimport _c_api

cdef class AxesDiscretizer:
    cdef _c_api.AxesDiscretizerHandle handle
    cdef bint owned

cdef AxesDiscretizer _axes_discretizer_from_capi(_c_api.AxesDiscretizerHandle h, bint owned=*)