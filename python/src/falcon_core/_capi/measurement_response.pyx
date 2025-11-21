# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .labelled_arrays_labelled_measured_array cimport LabelledArraysLabelledMeasuredArray

cdef class MeasurementResponse:
    cdef c_api.MeasurementResponseHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MeasurementResponseHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MeasurementResponseHandle>0 and self.owned:
            c_api.MeasurementResponse_destroy(self.handle)
        self.handle = <c_api.MeasurementResponseHandle>0

    cdef MeasurementResponse from_capi(cls, c_api.MeasurementResponseHandle h):
        cdef MeasurementResponse obj = <MeasurementResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, arrays):
        cdef c_api.MeasurementResponseHandle h
        h = c_api.MeasurementResponse_create(<c_api.LabelledArraysLabelledMeasuredArrayHandle>arrays.handle)
        if h == <c_api.MeasurementResponseHandle>0:
            raise MemoryError("Failed to create MeasurementResponse")
        cdef MeasurementResponse obj = <MeasurementResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MeasurementResponseHandle h
        try:
            h = c_api.MeasurementResponse_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MeasurementResponseHandle>0:
            raise MemoryError("Failed to create MeasurementResponse")
        cdef MeasurementResponse obj = <MeasurementResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def arrays(self):
        if self.handle == <c_api.MeasurementResponseHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledArraysLabelledMeasuredArrayHandle h_ret
        h_ret = c_api.MeasurementResponse_arrays(self.handle)
        if h_ret == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            return None
        return LabelledArraysLabelledMeasuredArray.from_capi(LabelledArraysLabelledMeasuredArray, h_ret)

    def message(self):
        if self.handle == <c_api.MeasurementResponseHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MeasurementResponse_message(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def equal(self, other):
        if self.handle == <c_api.MeasurementResponseHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasurementResponse_equal(self.handle, <c_api.MeasurementResponseHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.MeasurementResponseHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasurementResponse_not_equal(self.handle, <c_api.MeasurementResponseHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.MeasurementResponseHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MeasurementResponse_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MeasurementResponse _measurementresponse_from_capi(c_api.MeasurementResponseHandle h):
    cdef MeasurementResponse obj = <MeasurementResponse>MeasurementResponse.__new__(MeasurementResponse)
    obj.handle = h