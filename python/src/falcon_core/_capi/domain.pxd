cimport _c_api

cdef class Domain:
    cdef _c_api.DomainHandle handle
    cdef bint owned

cdef Domain _domain_from_capi(_c_api.DomainHandle h)