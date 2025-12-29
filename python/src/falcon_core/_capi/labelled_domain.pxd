cimport _c_api

cdef class LabelledDomain:
    cdef _c_api.LabelledDomainHandle handle
    cdef bint owned

cdef LabelledDomain _labelled_domain_from_capi(_c_api.LabelledDomainHandle h, bint owned=*)