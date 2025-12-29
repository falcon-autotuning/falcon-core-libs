cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .list_connection cimport ListConnection, _list_connection_from_capi

cdef class Connections:
    def __cinit__(self):
        self.handle = <_c_api.ConnectionsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ConnectionsHandle>0 and self.owned:
            _c_api.Connections_destroy(self.handle)
        self.handle = <_c_api.ConnectionsHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ConnectionsHandle h
        h = _c_api.Connections_create_empty()
        if h == <_c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListConnection items):
        cdef _c_api.ConnectionsHandle h
        h = _c_api.Connections_create(items.handle if items is not None else <_c_api.ListConnectionHandle>0)
        if h == <_c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ConnectionsHandle h
        try:
            h = _c_api.Connections_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def is_gates(self, ):
        return _c_api.Connections_is_gates(self.handle)

    def is_ohmics(self, ):
        return _c_api.Connections_is_ohmics(self.handle)

    def is_dot_gates(self, ):
        return _c_api.Connections_is_dot_gates(self.handle)

    def is_plunger_gates(self, ):
        return _c_api.Connections_is_plunger_gates(self.handle)

    def is_barrier_gates(self, ):
        return _c_api.Connections_is_barrier_gates(self.handle)

    def is_reservoir_gates(self, ):
        return _c_api.Connections_is_reservoir_gates(self.handle)

    def is_screening_gates(self, ):
        return _c_api.Connections_is_screening_gates(self.handle)

    def intersection(self, Connections other):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Connections_intersection(self.handle, other.handle if other is not None else <_c_api.ConnectionsHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def push_back(self, Connection value):
        _c_api.Connections_push_back(self.handle, value.handle if value is not None else <_c_api.ConnectionHandle>0)

    def size(self, ):
        return _c_api.Connections_size(self.handle)

    def empty(self, ):
        return _c_api.Connections_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.Connections_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.Connections_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Connections_at(self.handle, idx)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def items(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.Connections_items(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret)

    def contains(self, Connection value):
        return _c_api.Connections_contains(self.handle, value.handle if value is not None else <_c_api.ConnectionHandle>0)

    def index(self, Connection value):
        return _c_api.Connections_index(self.handle, value.handle if value is not None else <_c_api.ConnectionHandle>0)

    def equal(self, Connections other):
        return _c_api.Connections_equal(self.handle, other.handle if other is not None else <_c_api.ConnectionsHandle>0)

    def __eq__(self, Connections other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Connections other):
        return _c_api.Connections_not_equal(self.handle, other.handle if other is not None else <_c_api.ConnectionsHandle>0)

    def __ne__(self, Connections other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Connections_to_json_string(self.handle)
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
        cdef Connections obj = cls.new_empty()
        for item in items:
            if hasattr(item, "_c"):
                item = item._c
            obj.push_back(item)
        return obj

cdef Connections _connections_from_capi(_c_api.ConnectionsHandle h, bint owned=True):
    if h == <_c_api.ConnectionsHandle>0:
        return None
    cdef Connections obj = Connections.__new__(Connections)
    obj.handle = h
    obj.owned = owned
    return obj
