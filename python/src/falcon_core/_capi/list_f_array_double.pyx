cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport f_array_double

cdef class ListFArrayDouble:
    def __cinit__(self):
        self.handle = <_c_api.ListFArrayDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListFArrayDoubleHandle>0 and self.owned:
            _c_api.ListFArrayDouble_destroy(self.handle)
        self.handle = <_c_api.ListFArrayDoubleHandle>0


cdef ListFArrayDouble _list_f_array_double_from_capi(_c_api.ListFArrayDoubleHandle h):
    if h == <_c_api.ListFArrayDoubleHandle>0:
        return None
    cdef ListFArrayDouble obj = ListFArrayDouble.__new__(ListFArrayDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListFArrayDoubleHandle h
        h = _c_api.ListFArrayDouble_create_empty()
        if h == <_c_api.ListFArrayDoubleHandle>0:
            raise MemoryError("Failed to create ListFArrayDouble")
        cdef ListFArrayDouble obj = <ListFArrayDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, FArrayDouble data, size_t count):
        cdef _c_api.ListFArrayDoubleHandle h
        h = _c_api.ListFArrayDouble_create(data.handle, count)
        if h == <_c_api.ListFArrayDoubleHandle>0:
            raise MemoryError("Failed to create ListFArrayDouble")
        cdef ListFArrayDouble obj = <ListFArrayDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListFArrayDoubleHandle h
        try:
            h = _c_api.ListFArrayDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListFArrayDoubleHandle>0:
            raise MemoryError("Failed to create ListFArrayDouble")
        cdef ListFArrayDouble obj = <ListFArrayDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, FArrayDouble value):
        cdef _c_api.ListFArrayDoubleHandle h_ret = _c_api.ListFArrayDouble_fill_value(count, value.handle)
        if h_ret == <_c_api.ListFArrayDoubleHandle>0:
            return None
        return _list_f_array_double_from_capi(h_ret)

    def push_back(self, FArrayDouble value):
        _c_api.ListFArrayDouble_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListFArrayDouble_size(self.handle)

    def empty(self, ):
        return _c_api.ListFArrayDouble_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListFArrayDouble_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListFArrayDouble_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.ListFArrayDouble_at(self.handle, idx)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def items(self, FArrayDouble out_buffer, size_t buffer_size):
        return _c_api.ListFArrayDouble_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, FArrayDouble value):
        return _c_api.ListFArrayDouble_contains(self.handle, value.handle)

    def index(self, FArrayDouble value):
        return _c_api.ListFArrayDouble_index(self.handle, value.handle)

    def intersection(self, ListFArrayDouble other):
        cdef _c_api.ListFArrayDoubleHandle h_ret = _c_api.ListFArrayDouble_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListFArrayDoubleHandle>0:
            return None
        return _list_f_array_double_from_capi(h_ret)

    def equal(self, ListFArrayDouble b):
        return _c_api.ListFArrayDouble_equal(self.handle, b.handle)

    def __eq__(self, ListFArrayDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListFArrayDouble b):
        return _c_api.ListFArrayDouble_not_equal(self.handle, b.handle)

    def __ne__(self, ListFArrayDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
