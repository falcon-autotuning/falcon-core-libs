cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_string_double

cdef class ListPairStringDouble:
    def __cinit__(self):
        self.handle = <_c_api.ListPairStringDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairStringDoubleHandle>0 and self.owned:
            _c_api.ListPairStringDouble_destroy(self.handle)
        self.handle = <_c_api.ListPairStringDoubleHandle>0


cdef ListPairStringDouble _list_pair_string_double_from_capi(_c_api.ListPairStringDoubleHandle h):
    if h == <_c_api.ListPairStringDoubleHandle>0:
        return None
    cdef ListPairStringDouble obj = ListPairStringDouble.__new__(ListPairStringDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairStringDoubleHandle h
        h = _c_api.ListPairStringDouble_create_empty()
        if h == <_c_api.ListPairStringDoubleHandle>0:
            raise MemoryError("Failed to create ListPairStringDouble")
        cdef ListPairStringDouble obj = <ListPairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairStringDouble data, size_t count):
        cdef _c_api.ListPairStringDoubleHandle h
        h = _c_api.ListPairStringDouble_create(data.handle, count)
        if h == <_c_api.ListPairStringDoubleHandle>0:
            raise MemoryError("Failed to create ListPairStringDouble")
        cdef ListPairStringDouble obj = <ListPairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairStringDoubleHandle h
        try:
            h = _c_api.ListPairStringDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairStringDoubleHandle>0:
            raise MemoryError("Failed to create ListPairStringDouble")
        cdef ListPairStringDouble obj = <ListPairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairStringDouble value):
        cdef _c_api.ListPairStringDoubleHandle h_ret = _c_api.ListPairStringDouble_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairStringDoubleHandle>0:
            return None
        return _list_pair_string_double_from_capi(h_ret)

    def push_back(self, PairStringDouble value):
        _c_api.ListPairStringDouble_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairStringDouble_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairStringDouble_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairStringDouble_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairStringDouble_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairStringDoubleHandle h_ret = _c_api.ListPairStringDouble_at(self.handle, idx)
        if h_ret == <_c_api.PairStringDoubleHandle>0:
            return None
        return pair_string_double._pair_string_double_from_capi(h_ret)

    def items(self, PairStringDouble out_buffer, size_t buffer_size):
        return _c_api.ListPairStringDouble_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairStringDouble value):
        return _c_api.ListPairStringDouble_contains(self.handle, value.handle)

    def index(self, PairStringDouble value):
        return _c_api.ListPairStringDouble_index(self.handle, value.handle)

    def intersection(self, ListPairStringDouble other):
        cdef _c_api.ListPairStringDoubleHandle h_ret = _c_api.ListPairStringDouble_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairStringDoubleHandle>0:
            return None
        return _list_pair_string_double_from_capi(h_ret)

    def equal(self, ListPairStringDouble b):
        return _c_api.ListPairStringDouble_equal(self.handle, b.handle)

    def __eq__(self, ListPairStringDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairStringDouble b):
        return _c_api.ListPairStringDouble_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairStringDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
