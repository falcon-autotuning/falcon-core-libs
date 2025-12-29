cimport _c_api

cdef class AcquisitionContext:
    cdef _c_api.AcquisitionContextHandle handle
    cdef bint owned

cdef AcquisitionContext _acquisition_context_from_capi(_c_api.AcquisitionContextHandle h, bint owned=*)