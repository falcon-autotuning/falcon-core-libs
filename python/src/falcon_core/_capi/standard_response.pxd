cimport _c_api

cdef class StandardResponse:
    cdef _c_api.StandardResponseHandle handle
    cdef bint owned

cdef StandardResponse _standard_response_from_capi(_c_api.StandardResponseHandle h)