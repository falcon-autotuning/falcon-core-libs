# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class ListBool:
    cdef c_api.ListBoolHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ListBoolHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ListBoolHandle>0 and self.owned:
            c_api.ListBool_destroy(self.handle)
        self.handle = <c_api.ListBoolHandle>0

    cdef ListBool from_capi(cls, c_api.ListBoolHandle h):
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ListBoolHandle h
        h = c_api.ListBool_create_empty()
        if h == <c_api.ListBoolHandle>0:
            raise MemoryError("Failed to create ListBool")
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.ListBoolHandle h
        h = c_api.ListBool_create(data, count)
        if h == <c_api.ListBoolHandle>0:
            raise MemoryError("Failed to create ListBool")
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ListBoolHandle h
        try:
            h = c_api.ListBool_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ListBoolHandle>0:
            raise MemoryError("Failed to create ListBool")
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def allocate(count):
        cdef c_api.ListBoolHandle h_ret
        h_ret = c_api.ListBool_allocate(count)
        if h_ret == <c_api.ListBoolHandle>0:
            return None
        return ListBool.from_capi(ListBool, h_ret)

    @staticmethod
    def fill_value(count, value):
        cdef c_api.ListBoolHandle h_ret
        h_ret = c_api.ListBool_fill_value(count, value)
        if h_ret == <c_api.ListBoolHandle>0:
            return None
        return ListBool.from_capi(ListBool, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListBool_push_back(self.handle, value)

    def size(self):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListBool_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListBool_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListBool_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListBool_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListBool_at(self.handle, idx)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListBool_items(self.handle, out_buffer, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListBool_contains(self.handle, value)

    def index(self, value):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListBool_index(self.handle, value)

    def intersection(self, other):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListBoolHandle h_ret
        h_ret = c_api.ListBool_intersection(self.handle, <c_api.ListBoolHandle>other.handle)
        if h_ret == <c_api.ListBoolHandle>0:
            return None
        return ListBool.from_capi(ListBool, h_ret)

    def equal(self, b):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListBool_equal(self.handle, <c_api.ListBoolHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListBool_not_equal(self.handle, <c_api.ListBoolHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ListBoolHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ListBool_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ListBool _listbool_from_capi(c_api.ListBoolHandle h):
    cdef ListBool obj = <ListBool>ListBool.__new__(ListBool)
    obj.handle = h