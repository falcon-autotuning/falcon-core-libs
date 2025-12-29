cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .measurement_request cimport MeasurementRequest, _measurement_request_from_capi
from .measurement_response cimport MeasurementResponse, _measurement_response_from_capi

cdef class PairMeasurementResponseMeasurementRequest:
    def __cinit__(self):
        self.handle = <_c_api.PairMeasurementResponseMeasurementRequestHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.PairMeasurementResponseMeasurementRequestHandle>0 and self.owned:
            _c_api.PairMeasurementResponseMeasurementRequest_destroy(self.handle)
        self.handle = <_c_api.PairMeasurementResponseMeasurementRequestHandle>0


    @classmethod
    def new(cls, MeasurementResponse first, MeasurementRequest second):
        cdef _c_api.PairMeasurementResponseMeasurementRequestHandle h
        h = _c_api.PairMeasurementResponseMeasurementRequest_create(first.handle if first is not None else <_c_api.MeasurementResponseHandle>0, second.handle if second is not None else <_c_api.MeasurementRequestHandle>0)
        if h == <_c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            raise MemoryError("Failed to create PairMeasurementResponseMeasurementRequest")
        cdef PairMeasurementResponseMeasurementRequest obj = <PairMeasurementResponseMeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.PairMeasurementResponseMeasurementRequestHandle h
        try:
            h = _c_api.PairMeasurementResponseMeasurementRequest_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            raise MemoryError("Failed to create PairMeasurementResponseMeasurementRequest")
        cdef PairMeasurementResponseMeasurementRequest obj = <PairMeasurementResponseMeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self, ):
        cdef _c_api.MeasurementResponseHandle h_ret = _c_api.PairMeasurementResponseMeasurementRequest_first(self.handle)
        if h_ret == <_c_api.MeasurementResponseHandle>0:
            return None
        return _measurement_response_from_capi(h_ret)

    def second(self, ):
        cdef _c_api.MeasurementRequestHandle h_ret = _c_api.PairMeasurementResponseMeasurementRequest_second(self.handle)
        if h_ret == <_c_api.MeasurementRequestHandle>0:
            return None
        return _measurement_request_from_capi(h_ret)

    def equal(self, PairMeasurementResponseMeasurementRequest b):
        return _c_api.PairMeasurementResponseMeasurementRequest_equal(self.handle, b.handle if b is not None else <_c_api.PairMeasurementResponseMeasurementRequestHandle>0)

    def __eq__(self, PairMeasurementResponseMeasurementRequest b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, PairMeasurementResponseMeasurementRequest b):
        return _c_api.PairMeasurementResponseMeasurementRequest_not_equal(self.handle, b.handle if b is not None else <_c_api.PairMeasurementResponseMeasurementRequestHandle>0)

    def __ne__(self, PairMeasurementResponseMeasurementRequest b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.PairMeasurementResponseMeasurementRequest_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef PairMeasurementResponseMeasurementRequest _pair_measurement_response_measurement_request_from_capi(_c_api.PairMeasurementResponseMeasurementRequestHandle h, bint owned=True):
    if h == <_c_api.PairMeasurementResponseMeasurementRequestHandle>0:
        return None
    cdef PairMeasurementResponseMeasurementRequest obj = PairMeasurementResponseMeasurementRequest.__new__(PairMeasurementResponseMeasurementRequest)
    obj.handle = h
    obj.owned = owned
    return obj
