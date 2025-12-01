cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_float_float

cdef class ListPairFloatFloat:
    def __cinit__(self):
        self.handle = <_c_api.ListPairFloatFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairFloatFloatHandle>0 and self.owned:
            _c_api.ListPairFloatFloat_destroy(self.handle)
        self.handle = <_c_api.ListPairFloatFloatHandle>0


cdef ListPairFloatFloat _list_pair_float_float_from_capi(_c_api.ListPairFloatFloatHandle h):
    if h == <_c_api.ListPairFloatFloatHandle>0:
        return None
    cdef ListPairFloatFloat obj = ListPairFloatFloat.__new__(ListPairFloatFloat)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairFloatFloatHandle h
        h = _c_api.ListPairFloatFloat_create_empty()
        if h == <_c_api.ListPairFloatFloatHandle>0:
            raise MemoryError("Failed to create ListPairFloatFloat")
        cdef ListPairFloatFloat obj = <ListPairFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairFloatFloat data, size_t count):
        cdef _c_api.ListPairFloatFloatHandle h
        h = _c_api.ListPairFloatFloat_create(data.handle, count)
        if h == <_c_api.ListPairFloatFloatHandle>0:
            raise MemoryError("Failed to create ListPairFloatFloat")
        cdef ListPairFloatFloat obj = <ListPairFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairFloatFloatHandle h
        try:
            h = _c_api.ListPairFloatFloat_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairFloatFloatHandle>0:
            raise MemoryError("Failed to create ListPairFloatFloat")
        cdef ListPairFloatFloat obj = <ListPairFloatFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairFloatFloat value):
        cdef _c_api.ListPairFloatFloatHandle h_ret = _c_api.ListPairFloatFloat_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairFloatFloatHandle>0:
            return None
        return _list_pair_float_float_from_capi(h_ret)

    def push_back(self, PairFloatFloat value):
        _c_api.ListPairFloatFloat_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairFloatFloat_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairFloatFloat_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairFloatFloat_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairFloatFloat_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairFloatFloatHandle h_ret = _c_api.ListPairFloatFloat_at(self.handle, idx)
        if h_ret == <_c_api.PairFloatFloatHandle>0:
            return None
        return pair_float_float._pair_float_float_from_capi(h_ret)

    def items(self, PairFloatFloat out_buffer, size_t buffer_size):
        return _c_api.ListPairFloatFloat_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairFloatFloat value):
        return _c_api.ListPairFloatFloat_contains(self.handle, value.handle)

    def index(self, PairFloatFloat value):
        return _c_api.ListPairFloatFloat_index(self.handle, value.handle)

    def intersection(self, ListPairFloatFloat other):
        cdef _c_api.ListPairFloatFloatHandle h_ret = _c_api.ListPairFloatFloat_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairFloatFloatHandle>0:
            return None
        return _list_pair_float_float_from_capi(h_ret)

    def equal(self, ListPairFloatFloat b):
        return _c_api.ListPairFloatFloat_equal(self.handle, b.handle)

    def __eq__(self, ListPairFloatFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairFloatFloat b):
        return _c_api.ListPairFloatFloat_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairFloatFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
