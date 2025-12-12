cimport _c_api

cdef class ListAcquisitionContext:
    cdef _c_api.ListAcquisitionContextHandle handle
    cdef bint owned

cdef ListAcquisitionContext _list_acquisition_context_from_capi(_c_api.ListAcquisitionContextHandle h)