cimport _c_api

cdef class PairMeasurementResponseMeasurementRequest:
    cdef _c_api.PairMeasurementResponseMeasurementRequestHandle handle
    cdef bint owned

cdef PairMeasurementResponseMeasurementRequest _pair_measurement_response_measurement_request_from_capi(_c_api.PairMeasurementResponseMeasurementRequestHandle h, bint owned=*)