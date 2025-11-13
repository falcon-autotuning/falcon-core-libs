# cython: language_level=3
# Minimal Cython wrapper for Connection C API
# This module exposes a thin, memory-safe cdef class that owns a ConnectionHandle.

from cpython.bytes cimport PyBytes_FromString
cimport c_api

cdef class Connection:
    cdef c_api.ConnectionHandle handle

    def __cinit__(self):
        # initialize handle to 0 (NULL)
        self.handle = <c_api.ConnectionHandle>0

    def __dealloc__(self):
        if self.handle != <c_api.ConnectionHandle>0:
            c_api.Connection_destroy(self.handle)
            self.handle = <c_api.ConnectionHandle>0

    @classmethod
    def new_barrier(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_barrier_gate(name_bytes)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("failed to create Connection")
        cdef Connection c = <Connection>cls.__new__(cls)
        c.handle = h
        return c

    @classmethod
    def new_plunger(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_plunger_gate(name_bytes)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("failed to create Connection")
        cdef Connection c = <Connection>cls.__new__(cls)
        c.handle = h
        return c

    @classmethod
    def new_reservoir(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_reservoir_gate(name_bytes)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("failed to create Connection")
        cdef Connection c = <Connection>cls.__new__(cls)
        c.handle = h
        return c

    @classmethod
    def new_screening(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_screening_gate(name_bytes)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("failed to create Connection")
        cdef Connection c = <Connection>cls.__new__(cls)
        c.handle = h
        return c

    @classmethod
    def new_ohmic(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_ohmic(name_bytes)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("failed to create Connection")
        cdef Connection c = <Connection>cls.__new__(cls)
        c.handle = h
        return c

    @classmethod
    def from_json(cls, json_str):
        b = json_str.encode("utf-8")
        h = c_api.Connection_from_json_string(b)
        if h == <c_api.ConnectionHandle>0:
            raise ValueError("failed to parse Connection from json")
        cdef Connection c = <Connection>cls.__new__(cls)
        c.handle = h
        return c

    def close(self):
        if self.handle != <c_api.ConnectionHandle>0:
            c_api.Connection_destroy(self.handle)
            self.handle = <c_api.ConnectionHandle>0

    def name(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return ""
        cdef const char* s = c_api.Connection_name(self.handle)
        if s == <const char*>0:
            return ""
        b = PyBytes_FromString(s)
        return b.decode("utf-8")

    def type(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return ""
        cdef const char* s = c_api.Connection_type(self.handle)
        if s == <const char*>0:
            return ""
        b = PyBytes_FromString(s)
        return b.decode("utf-8")

    def to_json(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return ""
        cdef const char* s = c_api.Connection_to_json_string(self.handle)
        if s == <const char*>0:
            return ""
        b = PyBytes_FromString(s)
        return b.decode("utf-8")

    def is_dot_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return False
        return bool(c_api.Connection_is_dot_gate(self.handle))

    def is_barrier_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return False
        return bool(c_api.Connection_is_barrier_gate(self.handle))

    def is_plunger_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return False
        return bool(c_api.Connection_is_plunger_gate(self.handle))

    def is_reservoir_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return False
        return bool(c_api.Connection_is_reservoir_gate(self.handle))

    def is_screening_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return False
        return bool(c_api.Connection_is_screening_gate(self.handle))

    def is_ohmic(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return False
        return bool(c_api.Connection_is_ohmic(self.handle))

    def is_gate(self):
        if self.handle == <c_api.ConnectionHandle>0:
            return False
        return bool(c_api.Connection_is_gate(self.handle))

    def __richcmp__(self, other, int op):
        # op: 2 ==, 3 !=
        if not isinstance(other, Connection):
            return NotImplemented
        cdef Connection o = <Connection>other
        if self.handle == <c_api.ConnectionHandle>0 or o.handle == <c_api.ConnectionHandle>0:
            if op == 2:
                return False
            elif op == 3:
                return True
            else:
                return NotImplemented
        if op == 2:
            return bool(c_api.Connection_equal(self.handle, o.handle))
        elif op == 3:
            return bool(c_api.Connection_not_equal(self.handle, o.handle))
        return NotImplemented
