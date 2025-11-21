# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .device_voltage_state cimport DeviceVoltageState
from .list_device_voltage_state cimport ListDeviceVoltageState
from .point cimport Point
from .const _device_voltage_state cimport const DeviceVoltageState

cdef class DeviceVoltageStates:
    cdef c_api.DeviceVoltageStatesHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.DeviceVoltageStatesHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.DeviceVoltageStatesHandle>0 and self.owned:
            c_api.DeviceVoltageStates_destroy(self.handle)
        self.handle = <c_api.DeviceVoltageStatesHandle>0

    cdef DeviceVoltageStates from_capi(cls, c_api.DeviceVoltageStatesHandle h):
        cdef DeviceVoltageStates obj = <DeviceVoltageStates>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.DeviceVoltageStatesHandle h
        h = c_api.DeviceVoltageStates_create_empty()
        if h == <c_api.DeviceVoltageStatesHandle>0:
            raise MemoryError("Failed to create DeviceVoltageStates")
        cdef DeviceVoltageStates obj = <DeviceVoltageStates>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, items):
        cdef c_api.DeviceVoltageStatesHandle h
        h = c_api.DeviceVoltageStates_create(<c_api.ListDeviceVoltageStateHandle>items.handle)
        if h == <c_api.DeviceVoltageStatesHandle>0:
            raise MemoryError("Failed to create DeviceVoltageStates")
        cdef DeviceVoltageStates obj = <DeviceVoltageStates>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.DeviceVoltageStatesHandle h
        try:
            h = c_api.DeviceVoltageStates_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.DeviceVoltageStatesHandle>0:
            raise MemoryError("Failed to create DeviceVoltageStates")
        cdef DeviceVoltageStates obj = <DeviceVoltageStates>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def states(self):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListDeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageStates_states(self.handle)
        if h_ret == <c_api.ListDeviceVoltageStateHandle>0:
            return None
        return ListDeviceVoltageState.from_capi(ListDeviceVoltageState, h_ret)

    def add_state(self, state):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DeviceVoltageStates_add_state(self.handle, <c_api.DeviceVoltageStateHandle>state.handle)

    def find_state(self, connection):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStatesHandle h_ret
        h_ret = c_api.DeviceVoltageStates_find_state(self.handle, <c_api.ConnectionHandle>connection.handle)
        if h_ret == <c_api.DeviceVoltageStatesHandle>0:
            return None
        return DeviceVoltageStates.from_capi(DeviceVoltageStates, h_ret)

    def to_point(self):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PointHandle h_ret
        h_ret = c_api.DeviceVoltageStates_to_point(self.handle)
        if h_ret == <c_api.PointHandle>0:
            return None
        return Point.from_capi(Point, h_ret)

    def intersection(self, other):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStatesHandle h_ret
        h_ret = c_api.DeviceVoltageStates_intersection(self.handle, <c_api.DeviceVoltageStatesHandle>other.handle)
        if h_ret == <c_api.DeviceVoltageStatesHandle>0:
            return None
        return DeviceVoltageStates.from_capi(DeviceVoltageStates, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DeviceVoltageStates_push_back(self.handle, <c_api.DeviceVoltageStateHandle>value.handle)

    def size(self):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageStates_size(self.handle)

    def empty(self):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageStates_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DeviceVoltageStates_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        c_api.DeviceVoltageStates_clear(self.handle)

    def const_at(self, idx):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.const DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageStates_const_at(self.handle, idx)
        if h_ret == <c_api.const DeviceVoltageStateHandle>0:
            return None
        return const DeviceVoltageState.from_capi(const DeviceVoltageState, h_ret)

    def at(self, idx):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageStates_at(self.handle, idx)
        if h_ret == <c_api.DeviceVoltageStateHandle>0:
            return None
        return DeviceVoltageState.from_capi(DeviceVoltageState, h_ret)

    def items(self):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListDeviceVoltageStateHandle h_ret
        h_ret = c_api.DeviceVoltageStates_items(self.handle)
        if h_ret == <c_api.ListDeviceVoltageStateHandle>0:
            return None
        return ListDeviceVoltageState.from_capi(ListDeviceVoltageState, h_ret)

    def contains(self, value):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageStates_contains(self.handle, <c_api.DeviceVoltageStateHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageStates_index(self.handle, <c_api.DeviceVoltageStateHandle>value.handle)

    def equal(self, b):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageStates_equal(self.handle, <c_api.DeviceVoltageStatesHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DeviceVoltageStates_not_equal(self.handle, <c_api.DeviceVoltageStatesHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.DeviceVoltageStatesHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.DeviceVoltageStates_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef DeviceVoltageStates _devicevoltagestates_from_capi(c_api.DeviceVoltageStatesHandle h):
    cdef DeviceVoltageStates obj = <DeviceVoltageStates>DeviceVoltageStates.__new__(DeviceVoltageStates)
    obj.handle = h