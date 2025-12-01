cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport labelled_arrays_labelled_measured_array

cdef class MeasurementResponse:
    def __cinit__(self):
        self.handle = <_c_api.MeasurementResponseHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MeasurementResponseHandle>0 and self.owned:
            _c_api.MeasurementResponse_destroy(self.handle)
        self.handle = <_c_api.MeasurementResponseHandle>0


cdef MeasurementResponse _measurement_response_from_capi(_c_api.MeasurementResponseHandle h):
    if h == <_c_api.MeasurementResponseHandle>0:
        return None
    cdef MeasurementResponse obj = MeasurementResponse.__new__(MeasurementResponse)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, LabelledArraysLabelledMeasuredArray arrays):
        cdef _c_api.MeasurementResponseHandle h
        h = _c_api.MeasurementResponse_create(arrays.handle)
        if h == <_c_api.MeasurementResponseHandle>0:
            raise MemoryError("Failed to create MeasurementResponse")
        cdef MeasurementResponse obj = <MeasurementResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MeasurementResponseHandle h
        try:
            h = _c_api.MeasurementResponse_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MeasurementResponseHandle>0:
            raise MemoryError("Failed to create MeasurementResponse")
        cdef MeasurementResponse obj = <MeasurementResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def arrays(self, ):
        cdef _c_api.LabelledArraysLabelledMeasuredArrayHandle h_ret = _c_api.MeasurementResponse_arrays(self.handle)
        if h_ret == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            return None
        return labelled_arrays_labelled_measured_array._labelled_arrays_labelled_measured_array_from_capi(h_ret)

    def message(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.MeasurementResponse_message(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def equal(self, MeasurementResponse other):
        return _c_api.MeasurementResponse_equal(self.handle, other.handle)

    def __eq__(self, MeasurementResponse other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, MeasurementResponse other):
        return _c_api.MeasurementResponse_not_equal(self.handle, other.handle)

    def __ne__(self, MeasurementResponse other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
