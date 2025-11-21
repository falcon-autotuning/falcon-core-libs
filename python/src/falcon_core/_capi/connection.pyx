# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class Connection:
    cdef c_api.ConnectionHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ConnectionHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ConnectionHandle>0 and self.owned:
            c_api.Connection_destroy(self.handle)
        self.handle = <c_api.ConnectionHandle>0

    cdef Connection from_capi(cls, c_api.ConnectionHandle h):
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_barrier_gate(cls, name):
        name_bytes = name.encode("utf-8")
        cdef const char* raw_name = name_bytes
        cdef size_t len_name = len(name_bytes)
        cdef c_api.StringHandle s_name = c_api.String_create(raw_name, len_name)
        cdef c_api.ConnectionHandle h
        try:
            h = c_api.Connection_create_barrier_gate(s_name)
        finally:
            c_api.String_destroy(s_name)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_plunger_gate(cls, name):
        name_bytes = name.encode("utf-8")
        cdef const char* raw_name = name_bytes
        cdef size_t len_name = len(name_bytes)
        cdef c_api.StringHandle s_name = c_api.String_create(raw_name, len_name)
        cdef c_api.ConnectionHandle h
        try:
            h = c_api.Connection_create_plunger_gate(s_name)
        finally:
            c_api.String_destroy(s_name)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_reservoir_gate(cls, name):
        name_bytes = name.encode("utf-8")
        cdef const char* raw_name = name_bytes
        cdef size_t len_name = len(name_bytes)
        cdef c_api.StringHandle s_name = c_api.String_create(raw_name, len_name)
        cdef c_api.ConnectionHandle h
        try:
            h = c_api.Connection_create_reservoir_gate(s_name)
        finally:
            c_api.String_destroy(s_name)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_screening_gate(cls, name):
        name_bytes = name.encode("utf-8")
        cdef const char* raw_name = name_bytes
        cdef size_t len_name = len(name_bytes)
        cdef c_api.StringHandle s_name = c_api.String_create(raw_name, len_name)
        cdef c_api.ConnectionHandle h
        try:
            h = c_api.Connection_create_screening_gate(s_name)
        finally:
            c_api.String_destroy(s_name)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_ohmic(cls, name):
        name_bytes = name.encode("utf-8")
        cdef const char* raw_name = name_bytes
        cdef size_t len_name = len(name_bytes)
        cdef c_api.StringHandle s_name = c_api.String_create(raw_name, len_name)
        cdef c_api.ConnectionHandle h
        try:
            h = c_api.Connection_create_ohmic(s_name)
        finally:
            c_api.String_destroy(s_name)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ConnectionHandle h
        try:
            h = c_api.Connection_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("Failed to create Connection")
        cdef Connection obj = <Connection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def name(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Connection_name(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def type(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Connection_type(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def is_dot_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connection_is_dot_gate(self.handle)

    def is_barrier_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connection_is_barrier_gate(self.handle)

    def is_plunger_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connection_is_plunger_gate(self.handle)

    def is_reservoir_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connection_is_reservoir_gate(self.handle)

    def is_screening_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connection_is_screening_gate(self.handle)

    def is_ohmic(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connection_is_ohmic(self.handle)

    def is_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connection_is_gate(self.handle)

    def equal(self, b):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connection_equal(self.handle, <c_api.ConnectionHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Connection_not_equal(self.handle, <c_api.ConnectionHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ConnectionHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Connection_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Connection _connection_from_capi(c_api.ConnectionHandle h):
    cdef Connection obj = <Connection>Connection.__new__(Connection)
    obj.handle = h