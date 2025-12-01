cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class ListDouble:
    def __cinit__(self):
        self.handle = <_c_api.ListDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListDoubleHandle>0 and self.owned:
            _c_api.ListDouble_destroy(self.handle)
        self.handle = <_c_api.ListDoubleHandle>0


cdef ListDouble _list_double_from_capi(_c_api.ListDoubleHandle h):
    if h == <_c_api.ListDoubleHandle>0:
        return None
    cdef ListDouble obj = ListDouble.__new__(ListDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListDoubleHandle h
        h = _c_api.ListDouble_create_empty()
        if h == <_c_api.ListDoubleHandle>0:
            raise MemoryError("Failed to create ListDouble")
        cdef ListDouble obj = <ListDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, double data, size_t count):
        cdef _c_api.ListDoubleHandle h
        h = _c_api.ListDouble_create(data, count)
        if h == <_c_api.ListDoubleHandle>0:
            raise MemoryError("Failed to create ListDouble")
        cdef ListDouble obj = <ListDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListDoubleHandle h
        try:
            h = _c_api.ListDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListDoubleHandle>0:
            raise MemoryError("Failed to create ListDouble")
        cdef ListDouble obj = <ListDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def allocate(size_t count):
        cdef _c_api.ListDoubleHandle h_ret = _c_api.ListDouble_allocate(count)
        if h_ret == <_c_api.ListDoubleHandle>0:
            return None
        return _list_double_from_capi(h_ret)

    @staticmethod
    def fill_value(size_t count, double value):
        cdef _c_api.ListDoubleHandle h_ret = _c_api.ListDouble_fill_value(count, value)
        if h_ret == <_c_api.ListDoubleHandle>0:
            return None
        return _list_double_from_capi(h_ret)

    def push_back(self, double value):
        _c_api.ListDouble_push_back(self.handle, value)

    def size(self, ):
        return _c_api.ListDouble_size(self.handle)

    def empty(self, ):
        return _c_api.ListDouble_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListDouble_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListDouble_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.ListDouble_at(self.handle, idx)

    def items(self, double out_buffer, size_t buffer_size):
        return _c_api.ListDouble_items(self.handle, out_buffer, buffer_size)

    def contains(self, double value):
        return _c_api.ListDouble_contains(self.handle, value)

    def index(self, double value):
        return _c_api.ListDouble_index(self.handle, value)

    def intersection(self, ListDouble other):
        cdef _c_api.ListDoubleHandle h_ret = _c_api.ListDouble_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListDoubleHandle>0:
            return None
        return _list_double_from_capi(h_ret)

    def equal(self, ListDouble b):
        return _c_api.ListDouble_equal(self.handle, b.handle)

    def __eq__(self, ListDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListDouble b):
        return _c_api.ListDouble_not_equal(self.handle, b.handle)

    def __ne__(self, ListDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
