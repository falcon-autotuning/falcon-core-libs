cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .device_voltage_states cimport DeviceVoltageStates, _device_voltage_states_from_capi

cdef class VoltageStatesResponse:
    def __cinit__(self):
        self.handle = <_c_api.VoltageStatesResponseHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.VoltageStatesResponseHandle>0 and self.owned:
            _c_api.VoltageStatesResponse_destroy(self.handle)
        self.handle = <_c_api.VoltageStatesResponseHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.VoltageStatesResponseHandle h
        try:
            h = _c_api.VoltageStatesResponse_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.VoltageStatesResponseHandle>0:
            raise MemoryError("Failed to create VoltageStatesResponse")
        cdef VoltageStatesResponse obj = <VoltageStatesResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, str message, DeviceVoltageStates states):
        cdef bytes b_message = message.encode("utf-8")
        cdef _c_api.StringHandle s_message = _c_api.String_create(b_message, len(b_message))
        cdef _c_api.VoltageStatesResponseHandle h
        try:
            h = _c_api.VoltageStatesResponse_create(s_message, states.handle if states is not None else <_c_api.DeviceVoltageStatesHandle>0)
        finally:
            _c_api.String_destroy(s_message)
        if h == <_c_api.VoltageStatesResponseHandle>0:
            raise MemoryError("Failed to create VoltageStatesResponse")
        cdef VoltageStatesResponse obj = <VoltageStatesResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.VoltageStatesResponseHandle h_ret = _c_api.VoltageStatesResponse_copy(self.handle)
        if h_ret == <_c_api.VoltageStatesResponseHandle>0:
            return None
        return _voltage_states_response_from_capi(h_ret, owned=(h_ret != <_c_api.VoltageStatesResponseHandle>self.handle))

    def equal(self, VoltageStatesResponse other):
        return _c_api.VoltageStatesResponse_equal(self.handle, other.handle if other is not None else <_c_api.VoltageStatesResponseHandle>0)

    def __eq__(self, VoltageStatesResponse other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, VoltageStatesResponse other):
        return _c_api.VoltageStatesResponse_not_equal(self.handle, other.handle if other is not None else <_c_api.VoltageStatesResponseHandle>0)

    def __ne__(self, VoltageStatesResponse other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.VoltageStatesResponse_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def message(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.VoltageStatesResponse_message(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def states(self, ):
        cdef _c_api.DeviceVoltageStatesHandle h_ret = _c_api.VoltageStatesResponse_states(self.handle)
        if h_ret == <_c_api.DeviceVoltageStatesHandle>0:
            return None
        return _device_voltage_states_from_capi(h_ret)

cdef VoltageStatesResponse _voltage_states_response_from_capi(_c_api.VoltageStatesResponseHandle h, bint owned=True):
    if h == <_c_api.VoltageStatesResponseHandle>0:
        return None
    cdef VoltageStatesResponse obj = VoltageStatesResponse.__new__(VoltageStatesResponse)
    obj.handle = h
    obj.owned = owned
    return obj
