cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool

cdef class Connection:
    def __cinit__(self):
        self.handle = <_c_api.ConnectionHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ConnectionHandle>0 and self.owned:
            _c_api.Connection_destroy(self.handle)
        self.handle = <_c_api.ConnectionHandle>0


    @classmethod
    def new_barrier(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.ConnectionHandle h
        try:
            h = _c_api.Connection_create_barrier_gate(s_name)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_plunger(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.ConnectionHandle h
        try:
            h = _c_api.Connection_create_plunger_gate(s_name)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_reservoir(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.ConnectionHandle h
        try:
            h = _c_api.Connection_create_reservoir_gate(s_name)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_screening(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.ConnectionHandle h
        try:
            h = _c_api.Connection_create_screening_gate(s_name)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_ohmic(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.ConnectionHandle h
        try:
            h = _c_api.Connection_create_ohmic(s_name)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ConnectionHandle h
        try:
            h = _c_api.Connection_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def name(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Connection_name(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def type(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Connection_type(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def is_dot_gate(self, ):
        return _c_api.Connection_is_dot_gate(self.handle)

    def is_barrier_gate(self, ):
        return _c_api.Connection_is_barrier_gate(self.handle)

    def is_plunger_gate(self, ):
        return _c_api.Connection_is_plunger_gate(self.handle)

    def is_reservoir_gate(self, ):
        return _c_api.Connection_is_reservoir_gate(self.handle)

    def is_screening_gate(self, ):
        return _c_api.Connection_is_screening_gate(self.handle)

    def is_ohmic(self, ):
        return _c_api.Connection_is_ohmic(self.handle)

    def is_gate(self, ):
        return _c_api.Connection_is_gate(self.handle)

    def equal(self, Connection other):
        return _c_api.Connection_equal(self.handle, other.handle if other is not None else <_c_api.ConnectionHandle>0)

    def __eq__(self, Connection other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Connection other):
        return _c_api.Connection_not_equal(self.handle, other.handle if other is not None else <_c_api.ConnectionHandle>0)

    def __ne__(self, Connection other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Connection_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef Connection _connection_from_capi(_c_api.ConnectionHandle h, bint owned=True):
    if h == <_c_api.ConnectionHandle>0:
        return None
    cdef Connection obj = Connection.__new__(Connection)
    obj.handle = h
    obj.owned = owned
    return obj
