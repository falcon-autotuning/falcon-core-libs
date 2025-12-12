cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_connection_float

cdef class ListPairConnectionFloat:
    def __cinit__(self):
        self.handle = <_c_api.ListPairConnectionFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairConnectionFloatHandle>0 and self.owned:
            _c_api.ListPairConnectionFloat_destroy(self.handle)
        self.handle = <_c_api.ListPairConnectionFloatHandle>0


cdef ListPairConnectionFloat _list_pair_connection_float_from_capi(_c_api.ListPairConnectionFloatHandle h):
    if h == <_c_api.ListPairConnectionFloatHandle>0:
        return None
    cdef ListPairConnectionFloat obj = ListPairConnectionFloat.__new__(ListPairConnectionFloat)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListPairConnectionFloatHandle h
        h = _c_api.ListPairConnectionFloat_create_empty()
        if h == <_c_api.ListPairConnectionFloatHandle>0:
            raise MemoryError("Failed to create ListPairConnectionFloat")
        cdef ListPairConnectionFloat obj = <ListPairConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairConnectionFloat data, size_t count):
        cdef _c_api.ListPairConnectionFloatHandle h
        h = _c_api.ListPairConnectionFloat_create(data.handle, count)
        if h == <_c_api.ListPairConnectionFloatHandle>0:
            raise MemoryError("Failed to create ListPairConnectionFloat")
        cdef ListPairConnectionFloat obj = <ListPairConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairConnectionFloatHandle h
        try:
            h = _c_api.ListPairConnectionFloat_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairConnectionFloatHandle>0:
            raise MemoryError("Failed to create ListPairConnectionFloat")
        cdef ListPairConnectionFloat obj = <ListPairConnectionFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairConnectionFloat value):
        cdef _c_api.ListPairConnectionFloatHandle h_ret = _c_api.ListPairConnectionFloat_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairConnectionFloatHandle>0:
            return None
        return _list_pair_connection_float_from_capi(h_ret)

    def push_back(self, PairConnectionFloat value):
        _c_api.ListPairConnectionFloat_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairConnectionFloat_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairConnectionFloat_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairConnectionFloat_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairConnectionFloat_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairConnectionFloatHandle h_ret = _c_api.ListPairConnectionFloat_at(self.handle, idx)
        if h_ret == <_c_api.PairConnectionFloatHandle>0:
            return None
        return pair_connection_float._pair_connection_float_from_capi(h_ret)

    def items(self, PairConnectionFloat out_buffer, size_t buffer_size):
        return _c_api.ListPairConnectionFloat_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairConnectionFloat value):
        return _c_api.ListPairConnectionFloat_contains(self.handle, value.handle)

    def index(self, PairConnectionFloat value):
        return _c_api.ListPairConnectionFloat_index(self.handle, value.handle)

    def intersection(self, ListPairConnectionFloat other):
        cdef _c_api.ListPairConnectionFloatHandle h_ret = _c_api.ListPairConnectionFloat_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairConnectionFloatHandle>0:
            return None
        return _list_pair_connection_float_from_capi(h_ret)

    def equal(self, ListPairConnectionFloat b):
        return _c_api.ListPairConnectionFloat_equal(self.handle, b.handle)

    def __eq__(self, ListPairConnectionFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairConnectionFloat b):
        return _c_api.ListPairConnectionFloat_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairConnectionFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
