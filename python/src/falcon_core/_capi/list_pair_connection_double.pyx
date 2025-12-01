cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_connection_double

cdef class ListPairConnectionDouble:
    def __cinit__(self):
        self.handle = <_c_api.ListPairConnectionDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairConnectionDoubleHandle>0 and self.owned:
            _c_api.ListPairConnectionDouble_destroy(self.handle)
        self.handle = <_c_api.ListPairConnectionDoubleHandle>0


cdef ListPairConnectionDouble _list_pair_connection_double_from_capi(_c_api.ListPairConnectionDoubleHandle h):
    if h == <_c_api.ListPairConnectionDoubleHandle>0:
        return None
    cdef ListPairConnectionDouble obj = ListPairConnectionDouble.__new__(ListPairConnectionDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairConnectionDoubleHandle h
        h = _c_api.ListPairConnectionDouble_create_empty()
        if h == <_c_api.ListPairConnectionDoubleHandle>0:
            raise MemoryError("Failed to create ListPairConnectionDouble")
        cdef ListPairConnectionDouble obj = <ListPairConnectionDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairConnectionDouble data, size_t count):
        cdef _c_api.ListPairConnectionDoubleHandle h
        h = _c_api.ListPairConnectionDouble_create(data.handle, count)
        if h == <_c_api.ListPairConnectionDoubleHandle>0:
            raise MemoryError("Failed to create ListPairConnectionDouble")
        cdef ListPairConnectionDouble obj = <ListPairConnectionDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairConnectionDoubleHandle h
        try:
            h = _c_api.ListPairConnectionDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairConnectionDoubleHandle>0:
            raise MemoryError("Failed to create ListPairConnectionDouble")
        cdef ListPairConnectionDouble obj = <ListPairConnectionDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairConnectionDouble value):
        cdef _c_api.ListPairConnectionDoubleHandle h_ret = _c_api.ListPairConnectionDouble_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairConnectionDoubleHandle>0:
            return None
        return _list_pair_connection_double_from_capi(h_ret)

    def push_back(self, PairConnectionDouble value):
        _c_api.ListPairConnectionDouble_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairConnectionDouble_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairConnectionDouble_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairConnectionDouble_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairConnectionDouble_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairConnectionDoubleHandle h_ret = _c_api.ListPairConnectionDouble_at(self.handle, idx)
        if h_ret == <_c_api.PairConnectionDoubleHandle>0:
            return None
        return pair_connection_double._pair_connection_double_from_capi(h_ret)

    def items(self, PairConnectionDouble out_buffer, size_t buffer_size):
        return _c_api.ListPairConnectionDouble_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairConnectionDouble value):
        return _c_api.ListPairConnectionDouble_contains(self.handle, value.handle)

    def index(self, PairConnectionDouble value):
        return _c_api.ListPairConnectionDouble_index(self.handle, value.handle)

    def intersection(self, ListPairConnectionDouble other):
        cdef _c_api.ListPairConnectionDoubleHandle h_ret = _c_api.ListPairConnectionDouble_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairConnectionDoubleHandle>0:
            return None
        return _list_pair_connection_double_from_capi(h_ret)

    def equal(self, ListPairConnectionDouble b):
        return _c_api.ListPairConnectionDouble_equal(self.handle, b.handle)

    def __eq__(self, ListPairConnectionDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairConnectionDouble b):
        return _c_api.ListPairConnectionDouble_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairConnectionDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
