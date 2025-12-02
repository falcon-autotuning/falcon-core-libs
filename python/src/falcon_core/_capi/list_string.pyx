cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class ListString:
    def __cinit__(self):
        self.handle = <_c_api.ListStringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListStringHandle>0 and self.owned:
            _c_api.ListString_destroy(self.handle)
        self.handle = <_c_api.ListStringHandle>0


cdef ListString _list_string_from_capi(_c_api.ListStringHandle h):
    if h == <_c_api.ListStringHandle>0:
        return None
    cdef ListString obj = ListString.__new__(ListString)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListStringHandle h
        h = _c_api.ListString_create_empty()
        if h == <_c_api.ListStringHandle>0:
            raise MemoryError("Failed to create ListString")
        cdef ListString obj = <ListString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, str data, size_t count):
        cdef bytes b_data = data.encode("utf-8")
        cdef StringHandle s_data = _c_api.String_create(b_data, len(b_data))
        cdef _c_api.ListStringHandle h
        try:
            h = _c_api.ListString_create(s_data, count)
        finally:
            _c_api.String_destroy(s_data)
        if h == <_c_api.ListStringHandle>0:
            raise MemoryError("Failed to create ListString")
        cdef ListString obj = <ListString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListStringHandle h
        try:
            h = _c_api.ListString_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListStringHandle>0:
            raise MemoryError("Failed to create ListString")
        cdef ListString obj = <ListString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def allocate(size_t count):
        cdef _c_api.ListStringHandle h_ret = _c_api.ListString_allocate(count)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    @staticmethod
    def fill_value(size_t count, str value):
        cdef bytes b_value = value.encode("utf-8")
        cdef StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        cdef _c_api.ListStringHandle h_ret = _c_api.ListString_fill_value(count, s_value)
        _c_api.String_destroy(s_value)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def push_back(self, str value):
        cdef bytes b_value = value.encode("utf-8")
        cdef StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        _c_api.ListString_push_back(self.handle, s_value)
        _c_api.String_destroy(s_value)

    def size(self, ):
        return _c_api.ListString_size(self.handle)

    def empty(self, ):
        return _c_api.ListString_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListString_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListString_clear(self.handle)

    def at(self, size_t idx):
        cdef StringHandle s_ret
        s_ret = _c_api.ListString_at(self.handle, idx)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def items(self, str out_buffer, size_t buffer_size):
        cdef bytes b_out_buffer = out_buffer.encode("utf-8")
        cdef StringHandle s_out_buffer = _c_api.String_create(b_out_buffer, len(b_out_buffer))
        cdef size_t ret_val
        try:
            ret_val = _c_api.ListString_items(self.handle, s_out_buffer, buffer_size)
        finally:
            _c_api.String_destroy(s_out_buffer)
        return ret_val

    def contains(self, str value):
        cdef bytes b_value = value.encode("utf-8")
        cdef StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        cdef bool ret_val
        try:
            ret_val = _c_api.ListString_contains(self.handle, s_value)
        finally:
            _c_api.String_destroy(s_value)
        return ret_val

    def index(self, str value):
        cdef bytes b_value = value.encode("utf-8")
        cdef StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        cdef size_t ret_val
        try:
            ret_val = _c_api.ListString_index(self.handle, s_value)
        finally:
            _c_api.String_destroy(s_value)
        return ret_val

    def intersection(self, ListString other):
        cdef _c_api.ListStringHandle h_ret = _c_api.ListString_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def equal(self, ListString b):
        return _c_api.ListString_equal(self.handle, b.handle)

    def __eq__(self, ListString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListString b):
        return _c_api.ListString_not_equal(self.handle, b.handle)

    def __ne__(self, ListString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
