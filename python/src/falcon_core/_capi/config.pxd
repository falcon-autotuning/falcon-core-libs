cimport _c_api

cdef class Config:
    cdef _c_api.ConfigHandle handle
    cdef bint owned

cdef Config _config_from_capi(_c_api.ConfigHandle h)