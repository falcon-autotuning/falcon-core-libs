# cython: language_level=3
# cython: c_string_type=str, c_string_encoding=utf-8
# Low-level Cython wrapper for the ListInt C-API

from . cimport c_api
from libc.stddef cimport size_t
from cpython.bytes cimport PyBytes_FromStringAndSize

cdef class ListInt:
    """Manages a ListIntHandle and its lifecycle."""
    cdef c_api.ListIntHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ListIntHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ListIntHandle>0 and self.owned:
            c_api.ListInt_destroy(self.handle)
        self.handle = <c_api.ListIntHandle>0

    @classmethod
    def create_empty(cls):
        """Factory for an empty list."""
        cdef ListInt new_obj = <ListInt>cls.__new__(cls)
        new_obj.handle = c_api.ListInt_create_empty()
        if new_obj.handle == <c_api.ListIntHandle>0:
            raise MemoryError("Failed to create ListInt")
        new_obj.owned = True
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
        new_obj.owned = True
        return new_obj

    def push_back(self, int value):
        c_api.ListInt_push_back(self.handle, value)

    def erase_at(self, size_t index):
        if index >= self.size():
            raise IndexError("list index out of range")
        c_api.ListInt_erase_at(self.handle, index)

    def clear(self):
        c_api.ListInt_clear(self.handle)

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

    def intersection(self, ListInt other):
        cdef c_api.ListIntHandle new_handle = c_api.ListInt_intersection(self.handle, other.handle)
        if new_handle == <c_api.ListIntHandle>0:
            raise MemoryError("Failed to create intersection ListInt")
        cdef ListInt new_obj = <ListInt>self.__class__.__new__(self.__class__)
        new_obj.handle = new_handle
        new_obj.owned = True
        return new_obj

    cdef ListInt from_capi(cls, c_api.ListIntHandle h):
        """
        Create a cdef ListInt wrapper directly from a raw C API handle.
        Returned wrapper is non-owning (won't free the handle).
        """
        cdef ListInt c = <ListInt>cls.__new__(cls)
        c.handle = h
        c.owned = False
        return c

# Module-level C factory for ListInt
cdef ListInt _listint_from_capi(c_api.ListIntHandle h):
    cdef ListInt c = <ListInt>ListInt.__new__(ListInt)
    c.handle = h
    c.owned = False
    return c
