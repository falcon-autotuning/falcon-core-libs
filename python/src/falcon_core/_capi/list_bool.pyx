cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class ListBool:
    def __cinit__(self):
        self.handle = <_c_api.ListBoolHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListBoolHandle>0 and self.owned:
            _c_api.ListBool_destroy(self.handle)
        self.handle = <_c_api.ListBoolHandle>0


cdef ListBool _list_bool_from_capi(_c_api.ListBoolHandle h):
    if h == <_c_api.ListBoolHandle>0:
        return None
    cdef ListBool obj = ListBool.__new__(ListBool)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListBoolHandle h
        h = _c_api.ListBool_create_empty()
        if h == <_c_api.ListBoolHandle>0:
            raise MemoryError("Failed to create ListBool")
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, bool data, size_t count):
        cdef _c_api.ListBoolHandle h
        h = _c_api.ListBool_create(data, count)
        if h == <_c_api.ListBoolHandle>0:
            raise MemoryError("Failed to create ListBool")
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListBoolHandle h
        try:
            h = _c_api.ListBool_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListBoolHandle>0:
            raise MemoryError("Failed to create ListBool")
        cdef ListBool obj = <ListBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def allocate(size_t count):
        cdef _c_api.ListBoolHandle h_ret = _c_api.ListBool_allocate(count)
        if h_ret == <_c_api.ListBoolHandle>0:
            return None
        return _list_bool_from_capi(h_ret)

    @staticmethod
    def fill_value(size_t count, bool value):
        cdef _c_api.ListBoolHandle h_ret = _c_api.ListBool_fill_value(count, value)
        if h_ret == <_c_api.ListBoolHandle>0:
            return None
        return _list_bool_from_capi(h_ret)

    def push_back(self, bool value):
        _c_api.ListBool_push_back(self.handle, value)

    def size(self, ):
        return _c_api.ListBool_size(self.handle)

    def empty(self, ):
        return _c_api.ListBool_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListBool_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListBool_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.ListBool_at(self.handle, idx)

    def items(self, bool out_buffer, size_t buffer_size):
        return _c_api.ListBool_items(self.handle, out_buffer, buffer_size)

    def contains(self, bool value):
        return _c_api.ListBool_contains(self.handle, value)

    def index(self, bool value):
        return _c_api.ListBool_index(self.handle, value)

    def intersection(self, ListBool other):
        cdef _c_api.ListBoolHandle h_ret = _c_api.ListBool_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListBoolHandle>0:
            return None
        return _list_bool_from_capi(h_ret)

    def equal(self, ListBool b):
        return _c_api.ListBool_equal(self.handle, b.handle)

    def __eq__(self, ListBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListBool b):
        return _c_api.ListBool_not_equal(self.handle, b.handle)

    def __ne__(self, ListBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
