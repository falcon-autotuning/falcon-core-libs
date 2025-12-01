cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport device_voltage_state

cdef class ListDeviceVoltageState:
    def __cinit__(self):
        self.handle = <_c_api.ListDeviceVoltageStateHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListDeviceVoltageStateHandle>0 and self.owned:
            _c_api.ListDeviceVoltageState_destroy(self.handle)
        self.handle = <_c_api.ListDeviceVoltageStateHandle>0


cdef ListDeviceVoltageState _list_device_voltage_state_from_capi(_c_api.ListDeviceVoltageStateHandle h):
    if h == <_c_api.ListDeviceVoltageStateHandle>0:
        return None
    cdef ListDeviceVoltageState obj = ListDeviceVoltageState.__new__(ListDeviceVoltageState)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListDeviceVoltageStateHandle h
        h = _c_api.ListDeviceVoltageState_create_empty()
        if h == <_c_api.ListDeviceVoltageStateHandle>0:
            raise MemoryError("Failed to create ListDeviceVoltageState")
        cdef ListDeviceVoltageState obj = <ListDeviceVoltageState>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, DeviceVoltageState data, size_t count):
        cdef _c_api.ListDeviceVoltageStateHandle h
        h = _c_api.ListDeviceVoltageState_create(data.handle, count)
        if h == <_c_api.ListDeviceVoltageStateHandle>0:
            raise MemoryError("Failed to create ListDeviceVoltageState")
        cdef ListDeviceVoltageState obj = <ListDeviceVoltageState>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListDeviceVoltageStateHandle h
        try:
            h = _c_api.ListDeviceVoltageState_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListDeviceVoltageStateHandle>0:
            raise MemoryError("Failed to create ListDeviceVoltageState")
        cdef ListDeviceVoltageState obj = <ListDeviceVoltageState>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, DeviceVoltageState value):
        cdef _c_api.ListDeviceVoltageStateHandle h_ret = _c_api.ListDeviceVoltageState_fill_value(count, value.handle)
        if h_ret == <_c_api.ListDeviceVoltageStateHandle>0:
            return None
        return _list_device_voltage_state_from_capi(h_ret)

    def push_back(self, DeviceVoltageState value):
        _c_api.ListDeviceVoltageState_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListDeviceVoltageState_size(self.handle)

    def empty(self, ):
        return _c_api.ListDeviceVoltageState_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListDeviceVoltageState_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListDeviceVoltageState_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.ListDeviceVoltageState_at(self.handle, idx)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return device_voltage_state._device_voltage_state_from_capi(h_ret)

    def items(self, DeviceVoltageState out_buffer, size_t buffer_size):
        return _c_api.ListDeviceVoltageState_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, DeviceVoltageState value):
        return _c_api.ListDeviceVoltageState_contains(self.handle, value.handle)

    def index(self, DeviceVoltageState value):
        return _c_api.ListDeviceVoltageState_index(self.handle, value.handle)

    def intersection(self, ListDeviceVoltageState other):
        cdef _c_api.ListDeviceVoltageStateHandle h_ret = _c_api.ListDeviceVoltageState_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListDeviceVoltageStateHandle>0:
            return None
        return _list_device_voltage_state_from_capi(h_ret)

    def equal(self, ListDeviceVoltageState b):
        return _c_api.ListDeviceVoltageState_equal(self.handle, b.handle)

    def __eq__(self, ListDeviceVoltageState b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListDeviceVoltageState b):
        return _c_api.ListDeviceVoltageState_not_equal(self.handle, b.handle)

    def __ne__(self, ListDeviceVoltageState b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
