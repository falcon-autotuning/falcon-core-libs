# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .axes_control_array cimport AxesControlArray
from .axes_coupled_labelled_domain cimport AxesCoupledLabelledDomain
from .axes_int cimport AxesInt
from .device_voltage_states cimport DeviceVoltageStates
from .labelled_arrays_labelled_measured_array cimport LabelledArraysLabelledMeasuredArray
from .map_string_string cimport MapStringString
from .measurement_request cimport MeasurementRequest
from .measurement_response cimport MeasurementResponse
from .pair_measurement_response_measurement_request cimport PairMeasurementResponseMeasurementRequest

cdef class HDF5Data:
    cdef c_api.HDF5DataHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.HDF5DataHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.HDF5DataHandle>0 and self.owned:
            c_api.HDF5Data_destroy(self.handle)
        self.handle = <c_api.HDF5DataHandle>0

    cdef HDF5Data from_capi(cls, c_api.HDF5DataHandle h):
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, shape, unit_domain, domain_labels, ranges, metadata, measurement_title, unique_id, timestamp):
        measurement_title_bytes = measurement_title.encode("utf-8")
        cdef const char* raw_measurement_title = measurement_title_bytes
        cdef size_t len_measurement_title = len(measurement_title_bytes)
        cdef c_api.StringHandle s_measurement_title = c_api.String_create(raw_measurement_title, len_measurement_title)
        cdef c_api.HDF5DataHandle h
        try:
            h = c_api.HDF5Data_create(<c_api.AxesIntHandle>shape.handle, <c_api.AxesControlArrayHandle>unit_domain.handle, <c_api.AxesCoupledLabelledDomainHandle>domain_labels.handle, <c_api.LabelledArraysLabelledMeasuredArrayHandle>ranges.handle, <c_api.MapStringStringHandle>metadata.handle, s_measurement_title, unique_id, timestamp)
        finally:
            c_api.String_destroy(s_measurement_title)
        if h == <c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_file(cls, path):
        path_bytes = path.encode("utf-8")
        cdef const char* raw_path = path_bytes
        cdef size_t len_path = len(path_bytes)
        cdef c_api.StringHandle s_path = c_api.String_create(raw_path, len_path)
        cdef c_api.HDF5DataHandle h
        try:
            h = c_api.HDF5Data_create_from_file(s_path)
        finally:
            c_api.String_destroy(s_path)
        if h == <c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_communications(cls, request, response, device_voltage_states, session_id[16], measurement_title, unique_id, timestamp):
        measurement_title_bytes = measurement_title.encode("utf-8")
        cdef const char* raw_measurement_title = measurement_title_bytes
        cdef size_t len_measurement_title = len(measurement_title_bytes)
        cdef c_api.StringHandle s_measurement_title = c_api.String_create(raw_measurement_title, len_measurement_title)
        cdef c_api.HDF5DataHandle h
        try:
            h = c_api.HDF5Data_create_from_communications(<c_api.MeasurementRequestHandle>request.handle, <c_api.MeasurementResponseHandle>response.handle, <c_api.DeviceVoltageStatesHandle>device_voltage_states.handle, session_id[16], s_measurement_title, unique_id, timestamp)
        finally:
            c_api.String_destroy(s_measurement_title)
        if h == <c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.HDF5DataHandle h
        try:
            h = c_api.HDF5Data_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.HDF5DataHandle>0:
            raise MemoryError("Failed to create HDF5Data")
        cdef HDF5Data obj = <HDF5Data>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def to_file(self, path):
        if self.handle == <c_api.HDF5DataHandle>0:
            raise RuntimeError("Handle is null")
        path_bytes = path.encode("utf-8")
        cdef const char* raw_path = path_bytes
        cdef size_t len_path = len(path_bytes)
        cdef c_api.StringHandle s_path = c_api.String_create(raw_path, len_path)
        try:
            c_api.HDF5Data_to_file(self.handle, s_path)
        finally:
            c_api.String_destroy(s_path)

    def to_communications(self):
        if self.handle == <c_api.HDF5DataHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PairMeasurementResponseMeasurementRequestHandle h_ret
        h_ret = c_api.HDF5Data_to_communications(self.handle)
        if h_ret == <c_api.PairMeasurementResponseMeasurementRequestHandle>0:
            return None
        return PairMeasurementResponseMeasurementRequest.from_capi(PairMeasurementResponseMeasurementRequest, h_ret)

    def equal(self, other):
        if self.handle == <c_api.HDF5DataHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.HDF5Data_equal(self.handle, <c_api.HDF5DataHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.HDF5DataHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.HDF5Data_not_equal(self.handle, <c_api.HDF5DataHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.HDF5DataHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.HDF5Data_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef HDF5Data _hdf5data_from_capi(c_api.HDF5DataHandle h):
    cdef HDF5Data obj = <HDF5Data>HDF5Data.__new__(HDF5Data)
    obj.handle = h