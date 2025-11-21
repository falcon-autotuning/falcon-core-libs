# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .device_voltage_states cimport DeviceVoltageStates

cdef class VoltageStatesResponse:
    cdef c_api.VoltageStatesResponseHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.VoltageStatesResponseHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.VoltageStatesResponseHandle>0 and self.owned:
            c_api.VoltageStatesResponse_destroy(self.handle)
        self.handle = <c_api.VoltageStatesResponseHandle>0

    cdef VoltageStatesResponse from_capi(cls, c_api.VoltageStatesResponseHandle h):
        cdef VoltageStatesResponse obj = <VoltageStatesResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, message, states):
        message_bytes = message.encode("utf-8")
        cdef const char* raw_message = message_bytes
        cdef size_t len_message = len(message_bytes)
        cdef c_api.StringHandle s_message = c_api.String_create(raw_message, len_message)
        cdef c_api.VoltageStatesResponseHandle h
        try:
            h = c_api.VoltageStatesResponse_create(s_message, <c_api.DeviceVoltageStatesHandle>states.handle)
        finally:
            c_api.String_destroy(s_message)
        if h == <c_api.VoltageStatesResponseHandle>0:
            raise MemoryError("Failed to create VoltageStatesResponse")
        cdef VoltageStatesResponse obj = <VoltageStatesResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.VoltageStatesResponseHandle h
        try:
            h = c_api.VoltageStatesResponse_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.VoltageStatesResponseHandle>0:
            raise MemoryError("Failed to create VoltageStatesResponse")
        cdef VoltageStatesResponse obj = <VoltageStatesResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def message(self):
        if self.handle == <c_api.VoltageStatesResponseHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.VoltageStatesResponse_message(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def states(self):
        if self.handle == <c_api.VoltageStatesResponseHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStatesHandle h_ret
        h_ret = c_api.VoltageStatesResponse_states(self.handle)
        if h_ret == <c_api.DeviceVoltageStatesHandle>0:
            return None
        return DeviceVoltageStates.from_capi(DeviceVoltageStates, h_ret)

    def equal(self, other):
        if self.handle == <c_api.VoltageStatesResponseHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.VoltageStatesResponse_equal(self.handle, <c_api.VoltageStatesResponseHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.VoltageStatesResponseHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.VoltageStatesResponse_not_equal(self.handle, <c_api.VoltageStatesResponseHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.VoltageStatesResponseHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.VoltageStatesResponse_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef VoltageStatesResponse _voltagestatesresponse_from_capi(c_api.VoltageStatesResponseHandle h):
    cdef VoltageStatesResponse obj = <VoltageStatesResponse>VoltageStatesResponse.__new__(VoltageStatesResponse)
    obj.handle = h