cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_string_string

cdef class ListPairStringString:
    def __cinit__(self):
        self.handle = <_c_api.ListPairStringStringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairStringStringHandle>0 and self.owned:
            _c_api.ListPairStringString_destroy(self.handle)
        self.handle = <_c_api.ListPairStringStringHandle>0


cdef ListPairStringString _list_pair_string_string_from_capi(_c_api.ListPairStringStringHandle h):
    if h == <_c_api.ListPairStringStringHandle>0:
        return None
    cdef ListPairStringString obj = ListPairStringString.__new__(ListPairStringString)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListPairStringStringHandle h
        h = _c_api.ListPairStringString_create_empty()
        if h == <_c_api.ListPairStringStringHandle>0:
            raise MemoryError("Failed to create ListPairStringString")
        cdef ListPairStringString obj = <ListPairStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairStringString data, size_t count):
        cdef _c_api.ListPairStringStringHandle h
        h = _c_api.ListPairStringString_create(data.handle, count)
        if h == <_c_api.ListPairStringStringHandle>0:
            raise MemoryError("Failed to create ListPairStringString")
        cdef ListPairStringString obj = <ListPairStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairStringStringHandle h
        try:
            h = _c_api.ListPairStringString_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairStringStringHandle>0:
            raise MemoryError("Failed to create ListPairStringString")
        cdef ListPairStringString obj = <ListPairStringString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairStringString value):
        cdef _c_api.ListPairStringStringHandle h_ret = _c_api.ListPairStringString_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairStringStringHandle>0:
            return None
        return _list_pair_string_string_from_capi(h_ret)

    def push_back(self, PairStringString value):
        _c_api.ListPairStringString_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairStringString_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairStringString_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairStringString_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairStringString_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairStringStringHandle h_ret = _c_api.ListPairStringString_at(self.handle, idx)
        if h_ret == <_c_api.PairStringStringHandle>0:
            return None
        return pair_string_string._pair_string_string_from_capi(h_ret)

    def items(self, PairStringString out_buffer, size_t buffer_size):
        return _c_api.ListPairStringString_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairStringString value):
        return _c_api.ListPairStringString_contains(self.handle, value.handle)

    def index(self, PairStringString value):
        return _c_api.ListPairStringString_index(self.handle, value.handle)

    def intersection(self, ListPairStringString other):
        cdef _c_api.ListPairStringStringHandle h_ret = _c_api.ListPairStringString_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairStringStringHandle>0:
            return None
        return _list_pair_string_string_from_capi(h_ret)

    def equal(self, ListPairStringString b):
        return _c_api.ListPairStringString_equal(self.handle, b.handle)

    def __eq__(self, ListPairStringString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairStringString b):
        return _c_api.ListPairStringString_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairStringString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
