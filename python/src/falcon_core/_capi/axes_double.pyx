cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_double

cdef class AxesDouble:
    def __cinit__(self):
        self.handle = <_c_api.AxesDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesDoubleHandle>0 and self.owned:
            _c_api.AxesDouble_destroy(self.handle)
        self.handle = <_c_api.AxesDoubleHandle>0


cdef AxesDouble _axes_double_from_capi(_c_api.AxesDoubleHandle h):
    if h == <_c_api.AxesDoubleHandle>0:
        return None
    cdef AxesDouble obj = AxesDouble.__new__(AxesDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesDoubleHandle h
        h = _c_api.AxesDouble_create_empty()
        if h == <_c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, double data, size_t count):
        cdef _c_api.AxesDoubleHandle h
        h = _c_api.AxesDouble_create_raw(data, count)
        if h == <_c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListDouble data):
        cdef _c_api.AxesDoubleHandle h
        h = _c_api.AxesDouble_create(data.handle)
        if h == <_c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesDoubleHandle h
        try:
            h = _c_api.AxesDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesDoubleHandle>0:
            raise MemoryError("Failed to create AxesDouble")
        cdef AxesDouble obj = <AxesDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, double value):
        _c_api.AxesDouble_push_back(self.handle, value)

    def size(self, ):
        return _c_api.AxesDouble_size(self.handle)

    def empty(self, ):
        return _c_api.AxesDouble_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesDouble_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesDouble_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.AxesDouble_at(self.handle, idx)

    def items(self, double out_buffer, size_t buffer_size):
        return _c_api.AxesDouble_items(self.handle, out_buffer, buffer_size)

    def contains(self, double value):
        return _c_api.AxesDouble_contains(self.handle, value)

    def index(self, double value):
        return _c_api.AxesDouble_index(self.handle, value)

    def intersection(self, AxesDouble other):
        cdef _c_api.AxesDoubleHandle h_ret = _c_api.AxesDouble_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesDoubleHandle>0:
            return None
        return _axes_double_from_capi(h_ret)

    def equal(self, AxesDouble b):
        return _c_api.AxesDouble_equal(self.handle, b.handle)

    def __eq__(self, AxesDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesDouble b):
        return _c_api.AxesDouble_not_equal(self.handle, b.handle)

    def __ne__(self, AxesDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
