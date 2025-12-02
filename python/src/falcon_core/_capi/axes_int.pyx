cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_int

cdef class AxesInt:
    def __cinit__(self):
        self.handle = <_c_api.AxesIntHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesIntHandle>0 and self.owned:
            _c_api.AxesInt_destroy(self.handle)
        self.handle = <_c_api.AxesIntHandle>0


cdef AxesInt _axes_int_from_capi(_c_api.AxesIntHandle h):
    if h == <_c_api.AxesIntHandle>0:
        return None
    cdef AxesInt obj = AxesInt.__new__(AxesInt)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesIntHandle h
        h = _c_api.AxesInt_create_empty()
        if h == <_c_api.AxesIntHandle>0:
            raise MemoryError("Failed to create AxesInt")
        cdef AxesInt obj = <AxesInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, int data, size_t count):
        cdef _c_api.AxesIntHandle h
        h = _c_api.AxesInt_create_raw(data, count)
        if h == <_c_api.AxesIntHandle>0:
            raise MemoryError("Failed to create AxesInt")
        cdef AxesInt obj = <AxesInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListInt data):
        cdef _c_api.AxesIntHandle h
        h = _c_api.AxesInt_create(data.handle)
        if h == <_c_api.AxesIntHandle>0:
            raise MemoryError("Failed to create AxesInt")
        cdef AxesInt obj = <AxesInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesIntHandle h
        try:
            h = _c_api.AxesInt_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesIntHandle>0:
            raise MemoryError("Failed to create AxesInt")
        cdef AxesInt obj = <AxesInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, int value):
        _c_api.AxesInt_push_back(self.handle, value)

    def size(self, ):
        return _c_api.AxesInt_size(self.handle)

    def empty(self, ):
        return _c_api.AxesInt_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesInt_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesInt_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.AxesInt_at(self.handle, idx)

    def items(self, int out_buffer, size_t buffer_size):
        return _c_api.AxesInt_items(self.handle, out_buffer, buffer_size)

    def contains(self, int value):
        return _c_api.AxesInt_contains(self.handle, value)

    def index(self, int value):
        return _c_api.AxesInt_index(self.handle, value)

    def intersection(self, AxesInt other):
        cdef _c_api.AxesIntHandle h_ret = _c_api.AxesInt_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesIntHandle>0:
            return None
        return _axes_int_from_capi(h_ret)

    def equal(self, AxesInt b):
        return _c_api.AxesInt_equal(self.handle, b.handle)

    def __eq__(self, AxesInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesInt b):
        return _c_api.AxesInt_not_equal(self.handle, b.handle)

    def __ne__(self, AxesInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
