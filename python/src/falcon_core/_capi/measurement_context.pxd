cimport _c_api

cdef class MeasurementContext:
    cdef _c_api.MeasurementContextHandle handle
    cdef bint owned

cdef MeasurementContext _measurement_context_from_capi(_c_api.MeasurementContextHandle h)