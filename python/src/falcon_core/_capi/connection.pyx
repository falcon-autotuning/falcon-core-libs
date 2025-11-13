# cython: language_level=3
# Minimal Cython wrapper for Connection C API
# This module exposes a thin, memory-safe cdef class that owns a ConnectionHandle.

from cpython.bytes cimport PyBytes_FromString
from libc.stddef cimport NULL
cimport c_api

cdef class Connection:
    cdef c_api.ConnectionHandle handle

    def __cinit__(self, handle=None):
        if handle is None:
            self.handle = <c_api.ConnectionHandle>NULL
        else:
            self.handle = handle

    def __dealloc__(self):
        if self.handle != <c_api.ConnectionHandle>NULL:
            c_api.Connection_destroy(self.handle)
            self.handle = <c_api.ConnectionHandle>NULL

    @classmethod
    def new_barrier(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_barrier_gate(name_bytes)
        if h == <c_api.ConnectionHandle>NULL:
            raise MemoryError("failed to create Connection")
        return cls(h)

    @classmethod
    def new_plunger(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_plunger_gate(name_bytes)
        if h == <c_api.ConnectionHandle>NULL:
            raise MemoryError("failed to create Connection")
        return cls(h)

    @classmethod
    def new_reservoir(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_reservoir_gate(name_bytes)
        if h == <c_api.ConnectionHandle>NULL:
            raise MemoryError("failed to create Connection")
        return cls(h)

    @classmethod
    def new_screening(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_screening_gate(name_bytes)
        if h == <c_api.ConnectionHandle>NULL:
            raise MemoryError("failed to create Connection")
        return cls(h)

    @classmethod
    def new_ohmic(cls, name):
        name_bytes = name.encode("utf-8")
        h = c_api.Connection_create_ohmic(name_bytes)
        if h == <c_api.ConnectionHandle>NULL:
            raise MemoryError("failed to create Connection")
        return cls(h)

    @classmethod
    def from_json(cls, json_str):
        b = json_str.encode("utf-8")
        h = c_api.Connection_from_json_string(b)
        if h == <c_api.ConnectionHandle>NULL:
            raise ValueError("failed to parse Connection from json")
        return cls(h)

    def close(self):
        if self.handle != <c_api.ConnectionHandle>NULL:
            c_api.Connection_destroy(self.handle)
            self.handle = <c_api.ConnectionHandle>NULL

    def name(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return ""
        cdef const char* s = c_api.Connection_name(self.handle)
        if s == NULL:
            return ""
        b = PyBytes_FromString(s)
        return b.decode("utf-8")

    def type(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return ""
        cdef const char* s = c_api.Connection_type(self.handle)
        if s == NULL:
            return ""
        b = PyBytes_FromString(s)
        return b.decode("utf-8")

    def to_json(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return ""
        cdef const char* s = c_api.Connection_to_json_string(self.handle)
        if s == NULL:
            return ""
        b = PyBytes_FromString(s)
        return b.decode("utf-8")

    def is_dot_gate(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return False
        return bool(c_api.Connection_is_dot_gate(self.handle))

    def is_barrier_gate(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return False
        return bool(c_api.Connection_is_barrier_gate(self.handle))

    def is_plunger_gate(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return False
        return bool(c_api.Connection_is_plunger_gate(self.handle))

    def is_reservoir_gate(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return False
        return bool(c_api.Connection_is_reservoir_gate(self.handle))

    def is_screening_gate(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return False
        return bool(c_api.Connection_is_screening_gate(self.handle))

    def is_ohmic(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return False
        return bool(c_api.Connection_is_ohmic(self.handle))

    def is_gate(self):
        if self.handle == <c_api.ConnectionHandle>NULL:
            return False
        return bool(c_api.Connection_is_gate(self.handle))

    def __richcmp__(self, other, int op):
        # op: 2 ==, 3 !=
        if not isinstance(other, Connection):
            return NotImplemented
        if self.handle == <c_api.ConnectionHandle>NULL or other.handle == <c_api.ConnectionHandle>NULL:
            if op == 2:
                return False
            elif op == 3:
                return True
            else:
                return NotImplemented
        if op == 2:
            return bool(c_api.Connection_equal(self.handle, other.handle))
        elif op == 3:
            return bool(c_api.Connection_not_equal(self.handle, other.handle))
        return NotImplemented
