cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class ListFloat:
    def __cinit__(self):
        self.handle = <_c_api.ListFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListFloatHandle>0 and self.owned:
            _c_api.ListFloat_destroy(self.handle)
        self.handle = <_c_api.ListFloatHandle>0


cdef ListFloat _list_float_from_capi(_c_api.ListFloatHandle h):
    if h == <_c_api.ListFloatHandle>0:
        return None
    cdef ListFloat obj = ListFloat.__new__(ListFloat)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListFloatHandle h
        h = _c_api.ListFloat_create_empty()
        if h == <_c_api.ListFloatHandle>0:
            raise MemoryError("Failed to create ListFloat")
        cdef ListFloat obj = <ListFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, float data, size_t count):
        cdef _c_api.ListFloatHandle h
        h = _c_api.ListFloat_create(data, count)
        if h == <_c_api.ListFloatHandle>0:
            raise MemoryError("Failed to create ListFloat")
        cdef ListFloat obj = <ListFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListFloatHandle h
        try:
            h = _c_api.ListFloat_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListFloatHandle>0:
            raise MemoryError("Failed to create ListFloat")
        cdef ListFloat obj = <ListFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def allocate(size_t count):
        cdef _c_api.ListFloatHandle h_ret = _c_api.ListFloat_allocate(count)
        if h_ret == <_c_api.ListFloatHandle>0:
            return None
        return _list_float_from_capi(h_ret)

    @staticmethod
    def fill_value(size_t count, float value):
        cdef _c_api.ListFloatHandle h_ret = _c_api.ListFloat_fill_value(count, value)
        if h_ret == <_c_api.ListFloatHandle>0:
            return None
        return _list_float_from_capi(h_ret)

    def push_back(self, float value):
        _c_api.ListFloat_push_back(self.handle, value)

    def size(self, ):
        return _c_api.ListFloat_size(self.handle)

    def empty(self, ):
        return _c_api.ListFloat_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListFloat_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListFloat_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.ListFloat_at(self.handle, idx)

    def items(self, float out_buffer, size_t buffer_size):
        return _c_api.ListFloat_items(self.handle, out_buffer, buffer_size)

    def contains(self, float value):
        return _c_api.ListFloat_contains(self.handle, value)

    def index(self, float value):
        return _c_api.ListFloat_index(self.handle, value)

    def intersection(self, ListFloat other):
        cdef _c_api.ListFloatHandle h_ret = _c_api.ListFloat_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListFloatHandle>0:
            return None
        return _list_float_from_capi(h_ret)

    def equal(self, ListFloat b):
        return _c_api.ListFloat_equal(self.handle, b.handle)

    def __eq__(self, ListFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListFloat b):
        return _c_api.ListFloat_not_equal(self.handle, b.handle)

    def __ne__(self, ListFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
