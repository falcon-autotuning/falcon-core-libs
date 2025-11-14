# cython: language_level=3
# cython: c_string_type=str, c_string_encoding=utf-8
# Low-level Cython wrapper for the ListInt C-API

from . cimport c_api
from libc.stddef cimport size_t
from cpython.bytes cimport PyBytes_FromStringAndSize

cdef class ListInt:
    """Manages a ListIntHandle and its lifecycle."""
    cdef c_api.ListIntHandle handle

    def __cinit__(self):
        self.handle = <c_api.ListIntHandle>0

    def __dealloc__(self):
        if self.handle != <c_api.ListIntHandle>0:
            c_api.ListInt_destroy(self.handle)

    @classmethod
    def create_empty(cls):
        """Factory for an empty list."""
        cdef ListInt new_obj = <ListInt>cls.__new__(cls)
        new_obj.handle = c_api.ListInt_create_empty()
        if new_obj.handle == <c_api.ListIntHandle>0:
            raise MemoryError("Failed to create ListInt")
        return new_obj

    @classmethod
    def from_list(cls, int_list: list):
        """Factory from a Python list of ints."""
        cdef ListInt new_obj = <ListInt>cls.__new__(cls)
        new_obj.handle = c_api.ListInt_create_empty()
        if new_obj.handle == <c_api.ListIntHandle>0:
            raise MemoryError("Failed to create ListInt")
        for item in int_list:
            c_api.ListInt_push_back(new_obj.handle, item)
        return new_obj

    def push_back(self, int value):
        c_api.ListInt_push_back(self.handle, value)

    def at(self, size_t index):
        if index >= self.size():
            raise IndexError("list index out of range")
        return c_api.ListInt_at(self.handle, index)

    def size(self):
        return c_api.ListInt_size(self.handle)

    def __richcmp__(self, other, int op):
        if not isinstance(other, ListInt):
            return NotImplemented
        cdef ListInt o = <ListInt>other
        if op == 2:  # ==
            return bool(c_api.ListInt_equal(self.handle, o.handle))
        elif op == 3:  # !=
            return not bool(c_api.ListInt_equal(self.handle, o.handle))
        return NotImplemented
