cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .device_voltage_state cimport DeviceVoltageState, _device_voltage_state_from_capi
from .list_device_voltage_state cimport ListDeviceVoltageState, _list_device_voltage_state_from_capi
from .point cimport Point, _point_from_capi

cdef class DeviceVoltageStates:
    def __cinit__(self):
        self.handle = <_c_api.DeviceVoltageStatesHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.DeviceVoltageStatesHandle>0 and self.owned:
            _c_api.DeviceVoltageStates_destroy(self.handle)
        self.handle = <_c_api.DeviceVoltageStatesHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.DeviceVoltageStatesHandle h
        h = _c_api.DeviceVoltageStates_create_empty()
        if h == <_c_api.DeviceVoltageStatesHandle>0:
            raise MemoryError("Failed to create DeviceVoltageStates")
        cdef DeviceVoltageStates obj = <DeviceVoltageStates>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListDeviceVoltageState items):
        cdef _c_api.DeviceVoltageStatesHandle h
        h = _c_api.DeviceVoltageStates_create(items.handle if items is not None else <_c_api.ListDeviceVoltageStateHandle>0)
        if h == <_c_api.DeviceVoltageStatesHandle>0:
            raise MemoryError("Failed to create DeviceVoltageStates")
        cdef DeviceVoltageStates obj = <DeviceVoltageStates>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.DeviceVoltageStatesHandle h
        try:
            h = _c_api.DeviceVoltageStates_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.DeviceVoltageStatesHandle>0:
            raise MemoryError("Failed to create DeviceVoltageStates")
        cdef DeviceVoltageStates obj = <DeviceVoltageStates>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def states(self, ):
        cdef _c_api.ListDeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageStates_states(self.handle)
        if h_ret == <_c_api.ListDeviceVoltageStateHandle>0:
            return None
        return _list_device_voltage_state_from_capi(h_ret)

    def add_state(self, DeviceVoltageState state):
        _c_api.DeviceVoltageStates_add_state(self.handle, state.handle if state is not None else <_c_api.DeviceVoltageStateHandle>0)

    def find_state(self, Connection connection):
        cdef _c_api.DeviceVoltageStatesHandle h_ret = _c_api.DeviceVoltageStates_find_state(self.handle, connection.handle if connection is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.DeviceVoltageStatesHandle>0:
            return None
        return _device_voltage_states_from_capi(h_ret, owned=(h_ret != <_c_api.DeviceVoltageStatesHandle>self.handle))

    def to_point(self, ):
        cdef _c_api.PointHandle h_ret = _c_api.DeviceVoltageStates_to_point(self.handle)
        if h_ret == <_c_api.PointHandle>0:
            return None
        return _point_from_capi(h_ret)

    def intersection(self, DeviceVoltageStates other):
        cdef _c_api.DeviceVoltageStatesHandle h_ret = _c_api.DeviceVoltageStates_intersection(self.handle, other.handle if other is not None else <_c_api.DeviceVoltageStatesHandle>0)
        if h_ret == <_c_api.DeviceVoltageStatesHandle>0:
            return None
        return _device_voltage_states_from_capi(h_ret, owned=(h_ret != <_c_api.DeviceVoltageStatesHandle>self.handle))

    def push_back(self, DeviceVoltageState value):
        _c_api.DeviceVoltageStates_push_back(self.handle, value.handle if value is not None else <_c_api.DeviceVoltageStateHandle>0)

    def size(self, ):
        return _c_api.DeviceVoltageStates_size(self.handle)

    def empty(self, ):
        return _c_api.DeviceVoltageStates_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.DeviceVoltageStates_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.DeviceVoltageStates_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.DeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageStates_at(self.handle, idx)
        if h_ret == <_c_api.DeviceVoltageStateHandle>0:
            return None
        return _device_voltage_state_from_capi(h_ret, owned=False)

    def items(self, ):
        cdef _c_api.ListDeviceVoltageStateHandle h_ret = _c_api.DeviceVoltageStates_items(self.handle)
        if h_ret == <_c_api.ListDeviceVoltageStateHandle>0:
            return None
        return _list_device_voltage_state_from_capi(h_ret)

    def contains(self, DeviceVoltageState value):
        return _c_api.DeviceVoltageStates_contains(self.handle, value.handle if value is not None else <_c_api.DeviceVoltageStateHandle>0)

    def index(self, DeviceVoltageState value):
        return _c_api.DeviceVoltageStates_index(self.handle, value.handle if value is not None else <_c_api.DeviceVoltageStateHandle>0)

    def equal(self, DeviceVoltageStates b):
        return _c_api.DeviceVoltageStates_equal(self.handle, b.handle if b is not None else <_c_api.DeviceVoltageStatesHandle>0)

    def __eq__(self, DeviceVoltageStates b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, DeviceVoltageStates b):
        return _c_api.DeviceVoltageStates_not_equal(self.handle, b.handle if b is not None else <_c_api.DeviceVoltageStatesHandle>0)

    def __ne__(self, DeviceVoltageStates b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.DeviceVoltageStates_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

    def append(self, value):
        self.push_back(value)

    @classmethod
    def from_list(cls, items):
        cdef DeviceVoltageStates obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef DeviceVoltageStates _device_voltage_states_from_capi(_c_api.DeviceVoltageStatesHandle h, bint owned=True):
    if h == <_c_api.DeviceVoltageStatesHandle>0:
        return None
    cdef DeviceVoltageStates obj = DeviceVoltageStates.__new__(DeviceVoltageStates)
    obj.handle = h
    obj.owned = owned
    return obj
