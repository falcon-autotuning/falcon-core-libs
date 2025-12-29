cimport _c_api

cdef class StandardRequest:
    cdef _c_api.StandardRequestHandle handle
    cdef bint owned

cdef StandardRequest _standard_request_from_capi(_c_api.StandardRequestHandle h, bint owned=*)