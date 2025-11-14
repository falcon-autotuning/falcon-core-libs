# cython: language_level=3
# cython: c_string_type=str, c_string_encoding=utf-8
# Low-level Cython wrapper for the ListConnection C-API

from . cimport c_api
from .connection cimport Connection as _CConnection
from libc.stddef cimport size_t

# Import the Python class to wrap the handles we get back
from ..physics.device_structures.connection import Connection as PyConnection

cdef class ListConnection:
    """Manages a ListConnectionHandle and its lifecycle."""
    cdef c_api.ListConnectionHandle handle

    def __cinit__(self):
        self.handle = <c_api.ListConnectionHandle>0

    def __dealloc__(self):
        if self.handle != <c_api.ListConnectionHandle>0:
            c_api.ListConnection_destroy(self.handle)

    @classmethod
    def create_empty(cls):
        """Factory for an empty list."""
        cdef ListConnection new_obj = <ListConnection>cls.__new__(cls)
        new_obj.handle = c_api.ListConnection_create_empty()
        if new_obj.handle == <c_api.ListConnectionHandle>0:
            raise MemoryError("Failed to create ListConnection")
        return new_obj

    @classmethod
    def from_list(cls, conn_list: list):
        """Factory from a Python list of Connection objects."""
        cdef ListConnection new_obj = <ListConnection>cls.__new__(cls)
        new_obj.handle = c_api.ListConnection_create_empty()
        if new_obj.handle == <c_api.ListConnectionHandle>0:
            raise MemoryError("Failed to create ListConnection")
        for item in conn_list:
            # Extract the underlying C object's handle to pass to the C-API
            c_api.ListConnection_push_back(new_obj.handle, item._c.handle)
        return new_obj

    def push_back(self, PyConnection value):
        c_api.ListConnection_push_back(self.handle, value._c.handle)

    def at(self, size_t index):
        if index >= self.size():
            raise IndexError("list index out of range")
        # Get the raw ConnectionHandle from the C-API
        cdef c_api.ConnectionHandle conn_handle = c_api.ListConnection_at(self.handle, index)
        # We need to wrap it in a new Cython Connection object
        cdef _CConnection c_conn = _CConnection.__new__(_CConnection)
        c_conn.handle = conn_handle
        # Then wrap that in the final Python Connection object
        return PyConnection(c_conn)

    def size(self):
        return c_api.ListConnection_size(self.handle)

    def __richcmp__(self, other, int op):
        if not isinstance(other, ListConnection):
            return NotImplemented
        cdef ListConnection o = <ListConnection>other
        if op == 2:  # ==
            return bool(c_api.ListConnection_equal(self.handle, o.handle))
        elif op == 3:  # !=
            return not bool(c_api.ListConnection_equal(self.handle, o.handle))
        return NotImplemented
