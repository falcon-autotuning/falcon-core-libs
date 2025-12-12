cimport _c_api

cdef class Loader:
    cdef _c_api.LoaderHandle handle
    cdef bint owned

cdef Loader _loader_from_capi(_c_api.LoaderHandle h)