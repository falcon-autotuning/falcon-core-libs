# cython: language_level=3
# Cython wrapper for Connections C API that exposes a list-like low-level object.

from cpython.bytes cimport PyBytes_FromStringAndSize
from . cimport c_api
from .list_connection cimport ListConnection as _CListConnection
from .connection cimport Connection as _CConnection
from libc.stddef cimport size_t

# Import the high-level Python Connection wrapper class for returning owned objects
from ..physics.device_structures.connection import Connection as PyConnection

cdef class Connections:
    """Manages a ConnectionsHandle and exposes a list-like low-level interface."""

    # 'handle' cdef attribute is declared in connections.pxd; do not redeclare it here.

    def __cinit__(self):
        self.handle = <c_api.ConnectionsHandle>0

    def __dealloc__(self):
        if self.handle != <c_api.ConnectionsHandle>0:
            c_api.Connections_destroy(self.handle)
            self.handle = <c_api.ConnectionsHandle>0

    @classmethod
    def create_empty(cls):
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = c_api.Connections_create_empty()
        if obj.handle == <c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections")
        return obj

    @classmethod
    def from_list(cls, py_conn_list: list):
        """Create a Connections owning object from a Python list of Connection (Python-level) wrappers."""
        # Build a low-level ListConnection first (declare it as the cdef class so we can access cdef attrs)
        cdef _CListConnection c_list = _CListConnection.from_list(py_conn_list)
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = c_api.Connections_create(<void*>c_list.handle)
        if obj.handle == <c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create Connections from list")
        return obj

    def push_back(self, value):
        # value is expected to be a Python-level Connection wrapper with attribute _c
        c_conn = <_CConnection>value._c
        c_api.Connections_push_back(self.handle, c_conn.handle)

    def size(self):
        return c_api.Connections_size(self.handle)

    def empty(self):
        return bool(c_api.Connections_empty(self.handle))

    def erase_at(self, size_t idx):
        if idx >= self.size():
            raise IndexError("list index out of range")
        c_api.Connections_erase_at(self.handle, idx)

    def clear(self):
        c_api.Connections_clear(self.handle)

    def at(self, size_t index):
        if index >= self.size():
            raise IndexError("list index out of range")
        cdef c_api.ConnectionHandle h = c_api.Connections_at(self.handle, index)
        if h == <c_api.ConnectionHandle>0:
            raise MemoryError("Failed to get Connection from Connections at index")

        # Serialize the returned handle to JSON and reconstruct an owned Connection wrapper.
        cdef c_api.StringHandle s = c_api.Connection_to_json_string(h)
        if s == <c_api.StringHandle>0:
            raise MemoryError("Failed to serialize Connection")
        cdef const char* raw = s.raw
        cdef size_t ln = s.length
        try:
            b = PyBytes_FromStringAndSize(raw, ln)
            json_str = b.decode("utf-8")
        finally:
            c_api.String_destroy(s)

        cdef _CConnection c_conn = _CConnection.from_json(json_str)
        # Return a Python-level Connection wrapper (keeps consistency with ListConnection.at)
        return PyConnection(c_conn)

    def items(self):
        """Return a low-level ListConnection wrapper owning the list of items."""
        cdef c_api.ListConnectionHandle lh = c_api.Connections_items(self.handle)
        if lh == <c_api.ListConnectionHandle>0:
            raise MemoryError("Failed to get items list")
        cdef _CListConnection l = _CListConnection.__new__(_CListConnection)
        l.handle = lh
        return l

    def contains(self, value):
        c_conn = <_CConnection>value._c
        return bool(c_api.Connections_contains(self.handle, c_conn.handle))

    def index(self, value):
        c_conn = <_CConnection>value._c
        return c_api.Connections_index(self.handle, c_conn.handle)

    def intersection(self, Connections other):
        cdef c_api.ConnectionsHandle nh = c_api.Connections_intersection(self.handle, other.handle)
        if nh == <c_api.ConnectionsHandle>0:
            raise MemoryError("Failed to create intersection Connections")
        cdef Connections obj = <Connections>self.__class__.__new__(self.__class__)
        obj.handle = nh
        return obj

    def __richcmp__(self, other, int op):
        if not isinstance(other, Connections):
            return NotImplemented
        cdef Connections o = <Connections>other
        if op == 2:  # ==
            return bool(c_api.Connections_equal(self.handle, o.handle))
        elif op == 3:  # !=
            return bool(c_api.Connections_not_equal(self.handle, o.handle))
        return NotImplemented

    def to_json(self):
        if self.handle == <c_api.ConnectionsHandle>0:
            return ""
        cdef c_api.StringHandle s = c_api.Connections_to_json_string(self.handle)
        if s == <c_api.StringHandle>0:
            return ""
        cdef const char* raw = s.raw
        cdef size_t ln = s.length
        try:
            b = PyBytes_FromStringAndSize(raw, ln)
            return b.decode("utf-8")
        finally:
            c_api.String_destroy(s)

    @classmethod
    def from_json(cls, json_str):
        b = json_str.encode("utf-8")
        cdef const char* raw = b
        cdef size_t l = len(b)
        cdef c_api.StringHandle s = c_api.String_create(raw, l)
        try:
            h = c_api.Connections_from_json_string(s)
        finally:
            c_api.String_destroy(s)
        if h == <c_api.ConnectionsHandle>0:
            raise ValueError("failed to parse Connections from json")
        cdef Connections obj = <Connections>cls.__new__(cls)
        obj.handle = h
        return obj

    def is_gates(self):
        return bool(c_api.Connections_is_gates(self.handle))

    def is_ohmics(self):
        return bool(c_api.Connections_is_ohmics(self.handle))

    def is_dot_gates(self):
        return bool(c_api.Connections_is_dot_gates(self.handle))

    def is_plunger_gates(self):
        return bool(c_api.Connections_is_plunger_gates(self.handle))

    def is_barrier_gates(self):
        return bool(c_api.Connections_is_barrier_gates(self.handle))

    def is_reservoir_gates(self):
        return bool(c_api.Connections_is_reservoir_gates(self.handle))

    def is_screening_gates(self):
        return bool(c_api.Connections_is_screening_gates(self.handle))
