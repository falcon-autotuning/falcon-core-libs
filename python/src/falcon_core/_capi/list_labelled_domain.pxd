cimport _c_api

cdef class ListLabelledDomain:
    cdef _c_api.ListLabelledDomainHandle handle
    cdef bint owned

cdef ListLabelledDomain _list_labelled_domain_from_capi(_c_api.ListLabelledDomainHandle h, bint owned=*)