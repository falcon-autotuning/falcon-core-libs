cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport discretizer
from . cimport list_discretizer

cdef class AxesDiscretizer:
    def __cinit__(self):
        self.handle = <_c_api.AxesDiscretizerHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesDiscretizerHandle>0 and self.owned:
            _c_api.AxesDiscretizer_destroy(self.handle)
        self.handle = <_c_api.AxesDiscretizerHandle>0


cdef AxesDiscretizer _axes_discretizer_from_capi(_c_api.AxesDiscretizerHandle h):
    if h == <_c_api.AxesDiscretizerHandle>0:
        return None
    cdef AxesDiscretizer obj = AxesDiscretizer.__new__(AxesDiscretizer)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.AxesDiscretizerHandle h
        h = _c_api.AxesDiscretizer_create_empty()
        if h == <_c_api.AxesDiscretizerHandle>0:
            raise MemoryError("Failed to create AxesDiscretizer")
        cdef AxesDiscretizer obj = <AxesDiscretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def raw(cls, Discretizer data, size_t count):
        cdef _c_api.AxesDiscretizerHandle h
        h = _c_api.AxesDiscretizer_create_raw(data.handle, count)
        if h == <_c_api.AxesDiscretizerHandle>0:
            raise MemoryError("Failed to create AxesDiscretizer")
        cdef AxesDiscretizer obj = <AxesDiscretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, ListDiscretizer data):
        cdef _c_api.AxesDiscretizerHandle h
        h = _c_api.AxesDiscretizer_create(data.handle)
        if h == <_c_api.AxesDiscretizerHandle>0:
            raise MemoryError("Failed to create AxesDiscretizer")
        cdef AxesDiscretizer obj = <AxesDiscretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesDiscretizerHandle h
        try:
            h = _c_api.AxesDiscretizer_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesDiscretizerHandle>0:
            raise MemoryError("Failed to create AxesDiscretizer")
        cdef AxesDiscretizer obj = <AxesDiscretizer>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, Discretizer value):
        _c_api.AxesDiscretizer_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.AxesDiscretizer_size(self.handle)

    def empty(self, ):
        return _c_api.AxesDiscretizer_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesDiscretizer_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesDiscretizer_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.DiscretizerHandle h_ret = _c_api.AxesDiscretizer_at(self.handle, idx)
        if h_ret == <_c_api.DiscretizerHandle>0:
            return None
        return discretizer._discretizer_from_capi(h_ret)

    def items(self, Discretizer out_buffer, size_t buffer_size):
        return _c_api.AxesDiscretizer_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, Discretizer value):
        return _c_api.AxesDiscretizer_contains(self.handle, value.handle)

    def index(self, Discretizer value):
        return _c_api.AxesDiscretizer_index(self.handle, value.handle)

    def intersection(self, AxesDiscretizer other):
        cdef _c_api.AxesDiscretizerHandle h_ret = _c_api.AxesDiscretizer_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesDiscretizerHandle>0:
            return None
        return _axes_discretizer_from_capi(h_ret)

    def equal(self, AxesDiscretizer b):
        return _c_api.AxesDiscretizer_equal(self.handle, b.handle)

    def __eq__(self, AxesDiscretizer b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesDiscretizer b):
        return _c_api.AxesDiscretizer_not_equal(self.handle, b.handle)

    def __ne__(self, AxesDiscretizer b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
