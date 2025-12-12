cimport _c_api

cdef class ListCoupledLabelledDomain:
    cdef _c_api.ListCoupledLabelledDomainHandle handle
    cdef bint owned

cdef ListCoupledLabelledDomain _list_coupled_labelled_domain_from_capi(_c_api.ListCoupledLabelledDomainHandle h)