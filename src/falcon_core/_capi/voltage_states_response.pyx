cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport device_voltage_states

cdef class VoltageStatesResponse:
    def __cinit__(self):
        self.handle = <_c_api.VoltageStatesResponseHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.VoltageStatesResponseHandle>0 and self.owned:
            _c_api.VoltageStatesResponse_destroy(self.handle)
        self.handle = <_c_api.VoltageStatesResponseHandle>0


cdef VoltageStatesResponse _voltage_states_response_from_capi(_c_api.VoltageStatesResponseHandle h):
    if h == <_c_api.VoltageStatesResponseHandle>0:
        return None
    cdef VoltageStatesResponse obj = VoltageStatesResponse.__new__(VoltageStatesResponse)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, str message, DeviceVoltageStates states):
        cdef bytes b_message = message.encode("utf-8")
        cdef StringHandle s_message = _c_api.String_create(b_message, len(b_message))
        cdef _c_api.VoltageStatesResponseHandle h
        try:
            h = _c_api.VoltageStatesResponse_create(s_message, states.handle)
        finally:
            _c_api.String_destroy(s_message)
        if h == <_c_api.VoltageStatesResponseHandle>0:
            raise MemoryError("Failed to create VoltageStatesResponse")
        cdef VoltageStatesResponse obj = <VoltageStatesResponse>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def message(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.VoltageStatesResponse_message(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def states(self, ):
        cdef _c_api.DeviceVoltageStatesHandle h_ret = _c_api.VoltageStatesResponse_states(self.handle)
        if h_ret == <_c_api.DeviceVoltageStatesHandle>0:
            return None
        return device_voltage_states._device_voltage_states_from_capi(h_ret)

    def equal(self, VoltageStatesResponse other):
        return _c_api.VoltageStatesResponse_equal(self.handle, other.handle)

    def __eq__(self, VoltageStatesResponse other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, VoltageStatesResponse other):
        return _c_api.VoltageStatesResponse_not_equal(self.handle, other.handle)

    def __ne__(self, VoltageStatesResponse other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
