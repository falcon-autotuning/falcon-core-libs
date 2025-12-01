cimport _c_api

cdef class MeasurementResponse:
    cdef _c_api.MeasurementResponseHandle handle
    cdef bint owned

cdef MeasurementResponse _measurement_response_from_capi(_c_api.MeasurementResponseHandle h)