# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool

cdef class ListString:
    cdef c_api.ListStringHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ListStringHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ListStringHandle>0 and self.owned:
            c_api.ListString_destroy(self.handle)
        self.handle = <c_api.ListStringHandle>0

    cdef ListString from_capi(cls, c_api.ListStringHandle h):
        cdef ListString obj = <ListString>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ListStringHandle h
        h = c_api.ListString_create_empty()
        if h == <c_api.ListStringHandle>0:
            raise MemoryError("Failed to create ListString")
        cdef ListString obj = <ListString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        data_bytes = data.encode("utf-8")
        cdef const char* raw_data = data_bytes
        cdef size_t len_data = len(data_bytes)
        cdef c_api.StringHandle s_data = c_api.String_create(raw_data, len_data)
        cdef c_api.ListStringHandle h
        try:
            h = c_api.ListString_create(s_data, count)
        finally:
            c_api.String_destroy(s_data)
        if h == <c_api.ListStringHandle>0:
            raise MemoryError("Failed to create ListString")
        cdef ListString obj = <ListString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ListStringHandle h
        try:
            h = c_api.ListString_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ListStringHandle>0:
            raise MemoryError("Failed to create ListString")
        cdef ListString obj = <ListString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def allocate(count):
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.ListString_allocate(count)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    @staticmethod
    def fill_value(count, value):
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        cdef c_api.ListStringHandle h_ret
        try:
            h_ret = c_api.ListString_fill_value(count, s_value)
        finally:
            c_api.String_destroy(s_value)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        try:
            c_api.ListString_push_back(self.handle, s_value)
        finally:
            c_api.String_destroy(s_value)

    def size(self):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListString_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListString_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListString_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListString_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ListString_at(self.handle, idx)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        out_buffer_bytes = out_buffer.encode("utf-8")
        cdef const char* raw_out_buffer = out_buffer_bytes
        cdef size_t len_out_buffer = len(out_buffer_bytes)
        cdef c_api.StringHandle s_out_buffer = c_api.String_create(raw_out_buffer, len_out_buffer)
        cdef size_t ret_val
        try:
            ret_val = c_api.ListString_items(self.handle, s_out_buffer, buffer_size)
        finally:
            c_api.String_destroy(s_out_buffer)
        return ret_val

    def contains(self, value):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        cdef bool ret_val
        try:
            ret_val = c_api.ListString_contains(self.handle, s_value)
        finally:
            c_api.String_destroy(s_value)
        return ret_val

    def index(self, value):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        cdef size_t ret_val
        try:
            ret_val = c_api.ListString_index(self.handle, s_value)
        finally:
            c_api.String_destroy(s_value)
        return ret_val

    def intersection(self, other):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.ListString_intersection(self.handle, <c_api.ListStringHandle>other.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def equal(self, b):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListString_equal(self.handle, <c_api.ListStringHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListString_not_equal(self.handle, <c_api.ListStringHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ListStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ListString_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ListString _liststring_from_capi(c_api.ListStringHandle h):
    cdef ListString obj = <ListString>ListString.__new__(ListString)
    obj.handle = h