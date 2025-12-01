cimport _c_api

cdef class AxesMeasurementContext:
    cdef _c_api.AxesMeasurementContextHandle handle
    cdef bint owned

cdef AxesMeasurementContext _axes_measurement_context_from_capi(_c_api.AxesMeasurementContextHandle h)