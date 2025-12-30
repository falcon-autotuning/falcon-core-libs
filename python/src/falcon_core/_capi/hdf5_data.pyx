cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .axes_control_array cimport AxesControlArray, _axes_control_array_from_capi
from .axes_coupled_labelled_domain cimport AxesCoupledLabelledDomain, _axes_coupled_labelled_domain_from_capi
from .axes_int cimport AxesInt, _axes_int_from_capi
from .device_voltage_states cimport DeviceVoltageStates, _device_voltage_states_from_capi
from .labelled_arrays_labelled_measured_array cimport LabelledArraysLabelledMeasuredArray, _labelled_arrays_labelled_measured_array_from_capi
from .map_string_string cimport MapStringString, _map_string_string_from_capi
from .measurement_request cimport MeasurementRequest, _measurement_request_from_capi
from .measurement_response cimport MeasurementResponse, _measurement_response_from_capi
from .pair_measurement_response_measurement_request cimport PairMeasurementResponseMeasurementRequest, _pair_measurement_response_measurement_request_from_capi

cdef class HDF5Data:
    def __cinit__(self):
        self.handle = <_c_api.HDF5DataHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.HDF5DataHandle>0 and self.owned:
            _c_api.HDF5Data_destroy(self.handle)
        self.handle = <_c_api.HDF5DataHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.HDF5DataHandle h
        try:
            h = _c_api.HDF5Data_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, AxesInt shape, AxesControlArray unit_domain, AxesCoupledLabelledDomain domain_labels, LabelledArraysLabelledMeasuredArray ranges, MapStringString metadata, str measurement_title, int unique_id, int timestamp):
        cdef bytes b_measurement_title = measurement_title.encode("utf-8")
        cdef _c_api.StringHandle s_measurement_title = _c_api.String_create(b_measurement_title, len(b_measurement_title))
        cdef _c_api.HDF5DataHandle h
        try:
            h = _c_api.HDF5Data_create(shape.handle if shape is not None else <_c_api.AxesIntHandle>0, unit_domain.handle if unit_domain is not None else <_c_api.AxesControlArrayHandle>0, domain_labels.handle if domain_labels is not None else <_c_api.AxesCoupledLabelledDomainHandle>0, ranges.handle if ranges is not None else <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0, metadata.handle if metadata is not None else <_c_api.MapStringStringHandle>0, s_measurement_title, unique_id, timestamp)
        finally:
            _c_api.String_destroy(s_measurement_title)
        if h == <_c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_file(cls, str path):
        cdef bytes b_path = path.encode("utf-8")
        cdef _c_api.StringHandle s_path = _c_api.String_create(b_path, len(b_path))
        cdef _c_api.HDF5DataHandle h
        try:
            h = _c_api.HDF5Data_create_from_file(s_path)
        finally:
            _c_api.String_destroy(s_path)
        if h == <_c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_communications(cls, MeasurementRequest request, MeasurementResponse response, DeviceVoltageStates device_voltage_states, int8_t[:] session_id, str measurement_title, int unique_id, int timestamp):
        cdef bytes b_measurement_title = measurement_title.encode("utf-8")
        cdef _c_api.StringHandle s_measurement_title = _c_api.String_create(b_measurement_title, len(b_measurement_title))
        cdef _c_api.HDF5DataHandle h
        try:
            h = _c_api.HDF5Data_create_from_communications(request.handle if request is not None else <_c_api.MeasurementRequestHandle>0, response.handle if response is not None else <_c_api.MeasurementResponseHandle>0, device_voltage_states.handle if device_voltage_states is not None else <_c_api.DeviceVoltageStatesHandle>0, &session_id[0], s_measurement_title, unique_id, timestamp)
        finally:
            _c_api.String_destroy(s_measurement_title)
        if h == <_c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.HDF5DataHandle h_ret = _c_api.HDF5Data_copy(self.handle)
        if h_ret == <_c_api.HDF5DataHandle>0:
            return None
        return _hdf5_data_from_capi(h_ret)

    def equal(self, HDF5Data other):
        return _c_api.HDF5Data_equal(self.handle, other.handle if other is not None else <_c_api.HDF5DataHandle>0)

    def __eq__(self, HDF5Data other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, HDF5Data other):
        return _c_api.HDF5Data_not_equal(self.handle, other.handle if other is not None else <_c_api.HDF5DataHandle>0)

    def __ne__(self, HDF5Data other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.HDF5Data_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def to_file(self, str path):
        cdef bytes b_path = path.encode("utf-8")
        cdef _c_api.StringHandle s_path = _c_api.String_create(b_path, len(b_path))
        _c_api.HDF5Data_to_file(self.handle, s_path)
        _c_api.String_destroy(s_path)

    def to_communications(self, ):
        cdef _c_api.PairMeasurementResponseMeasurementRequestHandle h_ret = _c_api.HDF5Data_to_communications(self.handle)
        if h_ret == <_c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            return None
        return _pair_measurement_response_measurement_request_from_capi(h_ret)

    def shape(self, ):
        cdef _c_api.AxesIntHandle h_ret = _c_api.HDF5Data_shape(self.handle)
        if h_ret == <_c_api.AxesIntHandle>0:
            return None
        return _axes_int_from_capi(h_ret)

    def unit_domain(self, ):
        cdef _c_api.AxesControlArrayHandle h_ret = _c_api.HDF5Data_unit_domain(self.handle)
        if h_ret == <_c_api.AxesControlArrayHandle>0:
            return None
        return _axes_control_array_from_capi(h_ret)

    def domain_labels(self, ):
        cdef _c_api.AxesCoupledLabelledDomainHandle h_ret = _c_api.HDF5Data_domain_labels(self.handle)
        if h_ret == <_c_api.AxesCoupledLabelledDomainHandle>0:
            return None
        return _axes_coupled_labelled_domain_from_capi(h_ret)

    def ranges(self, ):
        cdef _c_api.LabelledArraysLabelledMeasuredArrayHandle h_ret = _c_api.HDF5Data_ranges(self.handle)
        if h_ret == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            return None
        return _labelled_arrays_labelled_measured_array_from_capi(h_ret)

    def metadata(self, ):
        cdef _c_api.MapStringStringHandle h_ret = _c_api.HDF5Data_metadata(self.handle)
        if h_ret == <_c_api.MapStringStringHandle>0:
            return None
        return _map_string_string_from_capi(h_ret)

    def measurement_title(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.HDF5Data_measurement_title(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def unique_id(self, ):
        return _c_api.HDF5Data_unique_id(self.handle)

    def timestamp(self, ):
        return _c_api.HDF5Data_timestamp(self.handle)

cdef HDF5Data _hdf5_data_from_capi(_c_api.HDF5DataHandle h, bint owned=True):
    if h == <_c_api.HDF5DataHandle>0:
        return None
    cdef HDF5Data obj = HDF5Data.__new__(HDF5Data)
    obj.handle = h
    obj.owned = owned
    return obj
