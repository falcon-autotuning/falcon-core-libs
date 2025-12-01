cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport axes_control_array
from . cimport axes_coupled_labelled_domain
from . cimport axes_int
from . cimport device_voltage_states
from . cimport labelled_arrays_labelled_measured_array
from . cimport map_string_string
from . cimport measurement_request
from . cimport measurement_response
from . cimport pair_measurement_response_measurement_request

cdef class HDF5Data:
    def __cinit__(self):
        self.handle = <_c_api.HDF5DataHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.HDF5DataHandle>0 and self.owned:
            _c_api.HDF5Data_destroy(self.handle)
        self.handle = <_c_api.HDF5DataHandle>0


cdef HDF5Data _hdf5_data_from_capi(_c_api.HDF5DataHandle h):
    if h == <_c_api.HDF5DataHandle>0:
        return None
    cdef HDF5Data obj = HDF5Data.__new__(HDF5Data)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, AxesInt shape, AxesControlArray unit_domain, AxesCoupledLabelledDomain domain_labels, LabelledArraysLabelledMeasuredArray ranges, MapStringString metadata, str measurement_title, int unique_id, int timestamp):
        cdef bytes b_measurement_title = measurement_title.encode("utf-8")
        cdef StringHandle s_measurement_title = _c_api.String_create(b_measurement_title, len(b_measurement_title))
        cdef _c_api.HDF5DataHandle h
        try:
            h = _c_api.HDF5Data_create(shape.handle, unit_domain.handle, domain_labels.handle, ranges.handle, metadata.handle, s_measurement_title, unique_id, timestamp)
        finally:
            _c_api.String_destroy(s_measurement_title)
        if h == <_c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_file(cls, str path):
        cdef bytes b_path = path.encode("utf-8")
        cdef StringHandle s_path = _c_api.String_create(b_path, len(b_path))
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
    def from_communications(cls, MeasurementRequest request, MeasurementResponse response, DeviceVoltageStates device_voltage_states, int8_t session_id[16], str measurement_title, int unique_id, int timestamp):
        cdef bytes b_measurement_title = measurement_title.encode("utf-8")
        cdef StringHandle s_measurement_title = _c_api.String_create(b_measurement_title, len(b_measurement_title))
        cdef _c_api.HDF5DataHandle h
        try:
            h = _c_api.HDF5Data_create_from_communications(request.handle, response.handle, device_voltage_states.handle, session_id[16], s_measurement_title, unique_id, timestamp)
        finally:
            _c_api.String_destroy(s_measurement_title)
        if h == <_c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def to_file(self, str path):
        cdef bytes b_path = path.encode("utf-8")
        cdef StringHandle s_path = _c_api.String_create(b_path, len(b_path))
        _c_api.HDF5Data_to_file(self.handle, s_path)
        _c_api.String_destroy(s_path)

    def to_communications(self, ):
        cdef _c_api.PairMeasurementResponseMeasurementRequestHandle h_ret = _c_api.HDF5Data_to_communications(self.handle)
        if h_ret == <_c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            return None
        return pair_measurement_response_measurement_request._pair_measurement_response_measurement_request_from_capi(h_ret)

    def equal(self, HDF5Data other):
        return _c_api.HDF5Data_equal(self.handle, other.handle)

    def __eq__(self, HDF5Data other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, HDF5Data other):
        return _c_api.HDF5Data_not_equal(self.handle, other.handle)

    def __ne__(self, HDF5Data other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
