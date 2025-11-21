# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .labelled_domain cimport LabelledDomain
from .list_waveform cimport ListWaveform
from .map_instrument_port_port_transform cimport MapInstrumentPortPortTransform
from .ports cimport Ports

cdef class MeasurementRequest:
    cdef c_api.MeasurementRequestHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MeasurementRequestHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MeasurementRequestHandle>0 and self.owned:
            c_api.MeasurementRequest_destroy(self.handle)
        self.handle = <c_api.MeasurementRequestHandle>0

    cdef MeasurementRequest from_capi(cls, c_api.MeasurementRequestHandle h):
        cdef MeasurementRequest obj = <MeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, message, measurement_name, waveforms, getters, meter_transforms, time_domain):
        message_bytes = message.encode("utf-8")
        cdef const char* raw_message = message_bytes
        cdef size_t len_message = len(message_bytes)
        cdef c_api.StringHandle s_message = c_api.String_create(raw_message, len_message)
        measurement_name_bytes = measurement_name.encode("utf-8")
        cdef const char* raw_measurement_name = measurement_name_bytes
        cdef size_t len_measurement_name = len(measurement_name_bytes)
        cdef c_api.StringHandle s_measurement_name = c_api.String_create(raw_measurement_name, len_measurement_name)
        cdef c_api.MeasurementRequestHandle h
        try:
            h = c_api.MeasurementRequest_create(s_message, s_measurement_name, <c_api.ListWaveformHandle>waveforms.handle, <c_api.PortsHandle>getters.handle, <c_api.MapInstrumentPortPortTransformHandle>meter_transforms.handle, <c_api.LabelledDomainHandle>time_domain.handle)
        finally:
            c_api.String_destroy(s_message)
            c_api.String_destroy(s_measurement_name)
        if h == <c_api.MeasurementRequestHandle>0:
            raise MemoryError("Failed to create MeasurementRequest")
        cdef MeasurementRequest obj = <MeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MeasurementRequestHandle h
        try:
            h = c_api.MeasurementRequest_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MeasurementRequestHandle>0:
            raise MemoryError("Failed to create MeasurementRequest")
        cdef MeasurementRequest obj = <MeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def measurement_name(self):
        if self.handle == <c_api.MeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MeasurementRequest_measurement_name(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def getters(self):
        if self.handle == <c_api.MeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PortsHandle h_ret
        h_ret = c_api.MeasurementRequest_getters(self.handle)
        if h_ret == <c_api.PortsHandle>0:
            return None
        return Ports.from_capi(Ports, h_ret)

    def waveforms(self):
        if self.handle == <c_api.MeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListWaveformHandle h_ret
        h_ret = c_api.MeasurementRequest_waveforms(self.handle)
        if h_ret == <c_api.ListWaveformHandle>0:
            return None
        return ListWaveform.from_capi(ListWaveform, h_ret)

    def meter_transforms(self):
        if self.handle == <c_api.MeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MapInstrumentPortPortTransformHandle h_ret
        h_ret = c_api.MeasurementRequest_meter_transforms(self.handle)
        if h_ret == <c_api.MapInstrumentPortPortTransformHandle>0:
            return None
        return MapInstrumentPortPortTransform.from_capi(MapInstrumentPortPortTransform, h_ret)

    def time_domain(self):
        if self.handle == <c_api.MeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledDomainHandle h_ret
        h_ret = c_api.MeasurementRequest_time_domain(self.handle)
        if h_ret == <c_api.LabelledDomainHandle>0:
            return None
        return LabelledDomain.from_capi(LabelledDomain, h_ret)

    def message(self):
        if self.handle == <c_api.MeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MeasurementRequest_message(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def equal(self, other):
        if self.handle == <c_api.MeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasurementRequest_equal(self.handle, <c_api.MeasurementRequestHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.MeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasurementRequest_not_equal(self.handle, <c_api.MeasurementRequestHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.MeasurementRequestHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MeasurementRequest_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MeasurementRequest _measurementrequest_from_capi(c_api.MeasurementRequestHandle h):
    cdef MeasurementRequest obj = <MeasurementRequest>MeasurementRequest.__new__(MeasurementRequest)
    obj.handle = h