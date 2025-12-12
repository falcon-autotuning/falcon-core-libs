cimport _c_api

cdef class AxesCoupledLabelledDomain:
    cdef _c_api.AxesCoupledLabelledDomainHandle handle
    cdef bint owned

cdef AxesCoupledLabelledDomain _axes_coupled_labelled_domain_from_capi(_c_api.AxesCoupledLabelledDomainHandle h)