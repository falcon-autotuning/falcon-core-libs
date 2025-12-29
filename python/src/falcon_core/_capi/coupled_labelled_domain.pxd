cimport _c_api

cdef class CoupledLabelledDomain:
    cdef _c_api.CoupledLabelledDomainHandle handle
    cdef bint owned

cdef CoupledLabelledDomain _coupled_labelled_domain_from_capi(_c_api.CoupledLabelledDomainHandle h, bint owned=*)