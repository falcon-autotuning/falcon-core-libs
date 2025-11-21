# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .measurement_request cimport MeasurementRequest
from .measurement_response cimport MeasurementResponse

cdef class PairMeasurementResponseMeasurementRequest:
    cdef c_api.PairMeasurementResponseMeasurementRequestHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.PairMeasurementResponseMeasurementRequestHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.PairMeasurementResponseMeasurementRequestHandle>0 and self.owned:
            c_api.PairMeasurementResponseMeasurementRequest_destroy(self.handle)
        self.handle = <c_api.PairMeasurementResponseMeasurementRequestHandle>0

    cdef PairMeasurementResponseMeasurementRequest from_capi(cls, c_api.PairMeasurementResponseMeasurementRequestHandle h):
        cdef PairMeasurementResponseMeasurementRequest obj = <PairMeasurementResponseMeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, first, second):
        cdef c_api.PairMeasurementResponseMeasurementRequestHandle h
        h = c_api.PairMeasurementResponseMeasurementRequest_create(<c_api.MeasurementResponseHandle>first.handle, <c_api.MeasurementRequestHandle>second.handle)
        if h == <c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            raise MemoryError("Failed to create PairMeasurementResponseMeasurementRequest")
        cdef PairMeasurementResponseMeasurementRequest obj = <PairMeasurementResponseMeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.PairMeasurementResponseMeasurementRequestHandle h
        try:
            h = c_api.PairMeasurementResponseMeasurementRequest_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            raise MemoryError("Failed to create PairMeasurementResponseMeasurementRequest")
        cdef PairMeasurementResponseMeasurementRequest obj = <PairMeasurementResponseMeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def first(self):
        if self.handle == <c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasurementResponseHandle h_ret
        h_ret = c_api.PairMeasurementResponseMeasurementRequest_first(self.handle)
        if h_ret == <c_api.MeasurementResponseHandle>0:
            return None
        return MeasurementResponse.from_capi(MeasurementResponse, h_ret)

    def second(self):
        if self.handle == <c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasurementRequestHandle h_ret
        h_ret = c_api.PairMeasurementResponseMeasurementRequest_second(self.handle)
        if h_ret == <c_api.MeasurementRequestHandle>0:
            return None
        return MeasurementRequest.from_capi(MeasurementRequest, h_ret)

    def equal(self, b):
        if self.handle == <c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairMeasurementResponseMeasurementRequest_equal(self.handle, <c_api.PairMeasurementResponseMeasurementRequestHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.PairMeasurementResponseMeasurementRequest_not_equal(self.handle, <c_api.PairMeasurementResponseMeasurementRequestHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.PairMeasurementResponseMeasurementRequest_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef PairMeasurementResponseMeasurementRequest _pairmeasurementresponsemeasurementrequest_from_capi(c_api.PairMeasurementResponseMeasurementRequestHandle h):
    cdef PairMeasurementResponseMeasurementRequest obj = <PairMeasurementResponseMeasurementRequest>PairMeasurementResponseMeasurementRequest.__new__(PairMeasurementResponseMeasurementRequest)
    obj.handle = h