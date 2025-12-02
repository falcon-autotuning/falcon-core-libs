cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport labelled_domain
from . cimport list_waveform
from . cimport map_instrument_port_port_transform
from . cimport ports

cdef class MeasurementRequest:
    def __cinit__(self):
        self.handle = <_c_api.MeasurementRequestHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MeasurementRequestHandle>0 and self.owned:
            _c_api.MeasurementRequest_destroy(self.handle)
        self.handle = <_c_api.MeasurementRequestHandle>0


cdef MeasurementRequest _measurement_request_from_capi(_c_api.MeasurementRequestHandle h):
    if h == <_c_api.MeasurementRequestHandle>0:
        return None
    cdef MeasurementRequest obj = MeasurementRequest.__new__(MeasurementRequest)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, str message, str measurement_name, ListWaveform waveforms, Ports getters, MapInstrumentPortPortTransform meter_transforms, LabelledDomain time_domain):
        cdef bytes b_message = message.encode("utf-8")
        cdef StringHandle s_message = _c_api.String_create(b_message, len(b_message))
        cdef bytes b_measurement_name = measurement_name.encode("utf-8")
        cdef StringHandle s_measurement_name = _c_api.String_create(b_measurement_name, len(b_measurement_name))
        cdef _c_api.MeasurementRequestHandle h
        try:
            h = _c_api.MeasurementRequest_create(s_message, s_measurement_name, waveforms.handle, getters.handle, meter_transforms.handle, time_domain.handle)
        finally:
            _c_api.String_destroy(s_message)
            _c_api.String_destroy(s_measurement_name)
        if h == <_c_api.MeasurementRequestHandle>0:
            raise MemoryError("Failed to create MeasurementRequest")
        cdef MeasurementRequest obj = <MeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MeasurementRequestHandle h
        try:
            h = _c_api.MeasurementRequest_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MeasurementRequestHandle>0:
            raise MemoryError("Failed to create MeasurementRequest")
        cdef MeasurementRequest obj = <MeasurementRequest>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def measurement_name(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.MeasurementRequest_measurement_name(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def getters(self, ):
        cdef _c_api.PortsHandle h_ret = _c_api.MeasurementRequest_getters(self.handle)
        if h_ret == <_c_api.PortsHandle>0:
            return None
        return ports._ports_from_capi(h_ret)

    def waveforms(self, ):
        cdef _c_api.ListWaveformHandle h_ret = _c_api.MeasurementRequest_waveforms(self.handle)
        if h_ret == <_c_api.ListWaveformHandle>0:
            return None
        return list_waveform._list_waveform_from_capi(h_ret)

    def meter_transforms(self, ):
        cdef _c_api.MapInstrumentPortPortTransformHandle h_ret = _c_api.MeasurementRequest_meter_transforms(self.handle)
        if h_ret == <_c_api.MapInstrumentPortPortTransformHandle>0:
            return None
        return map_instrument_port_port_transform._map_instrument_port_port_transform_from_capi(h_ret)

    def time_domain(self, ):
        cdef _c_api.LabelledDomainHandle h_ret = _c_api.MeasurementRequest_time_domain(self.handle)
        if h_ret == <_c_api.LabelledDomainHandle>0:
            return None
        return labelled_domain._labelled_domain_from_capi(h_ret)

    def message(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.MeasurementRequest_message(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def equal(self, MeasurementRequest other):
        return _c_api.MeasurementRequest_equal(self.handle, other.handle)

    def __eq__(self, MeasurementRequest other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, MeasurementRequest other):
        return _c_api.MeasurementRequest_not_equal(self.handle, other.handle)

    def __ne__(self, MeasurementRequest other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
