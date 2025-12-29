cimport _c_api

cdef class MeasurementRequest:
    cdef _c_api.MeasurementRequestHandle handle
    cdef bint owned

cdef MeasurementRequest _measurement_request_from_capi(_c_api.MeasurementRequestHandle h, bint owned=*)