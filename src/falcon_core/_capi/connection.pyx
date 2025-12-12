cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class Connection:
    def __cinit__(self):
        self.handle = <_c_api.ConnectionHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ConnectionHandle>0 and self.owned:
            _c_api.Connection_destroy(self.handle)
        self.handle = <_c_api.ConnectionHandle>0


cdef Connection _connection_from_capi(_c_api.ConnectionHandle h):
    if h == <_c_api.ConnectionHandle>0:
        return None
    cdef Connection obj = Connection.__new__(Connection)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_barrier(cls, str name):
        cdef bytes b_name = name.encode("utf-8")
        cdef StringHandle s_name = _c_api.String_create(b_name, len(b_name))
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
        cdef StringHandle s_name = _c_api.String_create(b_name, len(b_name))
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
        cdef StringHandle s_name = _c_api.String_create(b_name, len(b_name))
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
        cdef StringHandle s_name = _c_api.String_create(b_name, len(b_name))
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
        cdef StringHandle s_name = _c_api.String_create(b_name, len(b_name))
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
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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
        cdef StringHandle s_ret
        s_ret = _c_api.Connection_name(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def type(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.Connection_type(self.handle)
        if s_ret == <StringHandle>0:
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

    def equal(self, Connection b):
        return _c_api.Connection_equal(self.handle, b.handle)

    def __eq__(self, Connection b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Connection b):
        return _c_api.Connection_not_equal(self.handle, b.handle)

    def __ne__(self, Connection b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
