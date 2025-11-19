# cython: language_level=3
from cpython.bytes cimport PyBytes_FromStringAndSize
from . cimport c_api
# list_int is provided as a .pyx module (no .pxd present). Import it as a Python module
# and access its exported extension type at runtime.
from . import list_int as _list_int_mod
from libc.stddef cimport size_t
import json

# Import the high-level Python List wrapper so we can return List objects
# for keys() and values().
from ..generic.list import List as PyList

cdef class MapIntInt:
    """Manages a MapIntIntHandle and its lifecycle."""

    def __cinit__(self):
        self.handle = <c_api.MapIntIntHandle>0
        self.owned = True

    def __dealloc__(self):
        if hasattr(self, "handle") and self.handle != <c_api.MapIntIntHandle>0 and getattr(self, "owned", True):
            c_api.MapIntInt_destroy(self.handle)
        self.handle = <c_api.MapIntIntHandle>0

    @classmethod
    def create_empty(cls):
        cdef MapIntInt m = <MapIntInt>cls.__new__(cls)
        m.handle = c_api.MapIntInt_create_empty()
        if m.handle == <c_api.MapIntIntHandle>0:
            raise MemoryError("Failed to create MapIntInt")
        m.owned = True
        return m

    @classmethod
    def from_json(cls, json_str):
        b = json_str.encode("utf-8")
        cdef const char* raw = b
        cdef size_t l = len(b)
        cdef c_api.StringHandle s = c_api.String_create(raw, l)
        try:
            h = c_api.MapIntInt_from_json_string(s)
        finally:
            c_api.String_destroy(s)
        if h == <c_api.MapIntIntHandle>0:
            raise ValueError("failed to parse MapIntInt from json")
        m = <MapIntInt>cls.__new__(cls)
        m.handle = h
        m.owned = True
        return m

    def insert_or_assign(self, int key, int value):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise ValueError("Map is closed")
        c_api.MapIntInt_insert_or_assign(self.handle, key, value)

    def insert(self, int key, int value):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise ValueError("Map is closed")
        c_api.MapIntInt_insert(self.handle, key, value)

    def at(self, int key):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise ValueError("Map is closed")
        return c_api.MapIntInt_at(self.handle, key)

    def erase(self, int key):
        if self.handle == <c_api.MapIntIntHandle>0:
            raise ValueError("Map is closed")
        c_api.MapIntInt_erase(self.handle, key)

    def size(self):
        return c_api.MapIntInt_size(self.handle)

    def empty(self):
        return bool(c_api.MapIntInt_empty(self.handle))

    def clear(self):
        c_api.MapIntInt_clear(self.handle)

    def contains(self, int key):
        return bool(c_api.MapIntInt_contains(self.handle, key))

    def to_json(self):
        if self.handle == <c_api.MapIntIntHandle>0:
            return ""
        cdef c_api.StringHandle s = c_api.MapIntInt_to_json_string(self.handle)
        if s == <c_api.StringHandle>0:
            return ""
        cdef const char* raw = s.raw
        cdef size_t ln = s.length
        try:
            b = PyBytes_FromStringAndSize(raw, ln)
            return b.decode("utf-8")
        finally:
            c_api.String_destroy(s)

    def keys(self):
        """Return a high-level List[int] wrapper for the keys."""
        # If the map is closed, return an empty high-level List
        if self.handle == <c_api.MapIntIntHandle>0:
            return PyList(_list_int_mod.ListInt.create_empty(), _list_int_mod.ListInt)

        cdef c_api.ListIntHandle lh = c_api.MapIntInt_keys(self.handle)
        if lh == <c_api.ListIntHandle>0:
            return PyList(_list_int_mod.ListInt.create_empty(), _list_int_mod.ListInt)

        # Wrap the returned ListIntHandle into a ListInt instance (owning)
        c_list = _list_int_mod.ListInt.__new__(_list_int_mod.ListInt)
        c_list.handle = lh
        c_list.owned = True

        # Return a Python-level generic List wrapper around the c_list
        return PyList(c_list, _list_int_mod.ListInt)

    def values(self):
        """Return a high-level List[int] wrapper for the values."""
        if self.handle == <c_api.MapIntIntHandle>0:
            return PyList(_list_int_mod.ListInt.create_empty(), _list_int_mod.ListInt)

        cdef c_api.ListIntHandle lh = c_api.MapIntInt_values(self.handle)
        if lh == <c_api.ListIntHandle>0:
            return PyList(_list_int_mod.ListInt.create_empty(), _list_int_mod.ListInt)

        # Wrap the returned ListIntHandle into a ListInt instance (owning)
        c_list = _list_int_mod.ListInt.__new__(_list_int_mod.ListInt)
        c_list.handle = lh
        c_list.owned = True

        # Return a Python-level generic List wrapper around the c_list
        return PyList(c_list, _list_int_mod.ListInt)

    def __richcmp__(self, other, int op):
        if not isinstance(other, MapIntInt):
            return NotImplemented
        cdef MapIntInt o = <MapIntInt>other
        if op == 2:  # ==
            return bool(c_api.MapIntInt_equal(self.handle, o.handle))
        elif op == 3:  # !=
            return bool(c_api.MapIntInt_not_equal(self.handle, o.handle))
        return NotImplemented

    cdef MapIntInt from_capi(cls, c_api.MapIntIntHandle h):
        cdef MapIntInt m = <MapIntInt>cls.__new__(cls)
        m.handle = h
        m.owned = False
        return m


# Module-level C factory for MapIntInt
cdef MapIntInt _mapintint_from_capi(c_api.MapIntIntHandle h):
    cdef MapIntInt m = <MapIntInt>MapIntInt.__new__(MapIntInt)
    m.handle = h
    m.owned = False
    return m
