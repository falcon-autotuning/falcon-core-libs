cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_int_int

cdef class ListPairIntInt:
    def __cinit__(self):
        self.handle = <_c_api.ListPairIntIntHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairIntIntHandle>0 and self.owned:
            _c_api.ListPairIntInt_destroy(self.handle)
        self.handle = <_c_api.ListPairIntIntHandle>0


cdef ListPairIntInt _list_pair_int_int_from_capi(_c_api.ListPairIntIntHandle h):
    if h == <_c_api.ListPairIntIntHandle>0:
        return None
    cdef ListPairIntInt obj = ListPairIntInt.__new__(ListPairIntInt)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListPairIntIntHandle h
        h = _c_api.ListPairIntInt_create_empty()
        if h == <_c_api.ListPairIntIntHandle>0:
            raise MemoryError("Failed to create ListPairIntInt")
        cdef ListPairIntInt obj = <ListPairIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairIntInt data, size_t count):
        cdef _c_api.ListPairIntIntHandle h
        h = _c_api.ListPairIntInt_create(data.handle, count)
        if h == <_c_api.ListPairIntIntHandle>0:
            raise MemoryError("Failed to create ListPairIntInt")
        cdef ListPairIntInt obj = <ListPairIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairIntIntHandle h
        try:
            h = _c_api.ListPairIntInt_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairIntIntHandle>0:
            raise MemoryError("Failed to create ListPairIntInt")
        cdef ListPairIntInt obj = <ListPairIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairIntInt value):
        cdef _c_api.ListPairIntIntHandle h_ret = _c_api.ListPairIntInt_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairIntIntHandle>0:
            return None
        return _list_pair_int_int_from_capi(h_ret)

    def push_back(self, PairIntInt value):
        _c_api.ListPairIntInt_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairIntInt_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairIntInt_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairIntInt_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairIntInt_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairIntIntHandle h_ret = _c_api.ListPairIntInt_at(self.handle, idx)
        if h_ret == <_c_api.PairIntIntHandle>0:
            return None
        return pair_int_int._pair_int_int_from_capi(h_ret)

    def items(self, PairIntInt out_buffer, size_t buffer_size):
        return _c_api.ListPairIntInt_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairIntInt value):
        return _c_api.ListPairIntInt_contains(self.handle, value.handle)

    def index(self, PairIntInt value):
        return _c_api.ListPairIntInt_index(self.handle, value.handle)

    def intersection(self, ListPairIntInt other):
        cdef _c_api.ListPairIntIntHandle h_ret = _c_api.ListPairIntInt_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairIntIntHandle>0:
            return None
        return _list_pair_int_int_from_capi(h_ret)

    def equal(self, ListPairIntInt b):
        return _c_api.ListPairIntInt_equal(self.handle, b.handle)

    def __eq__(self, ListPairIntInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairIntInt b):
        return _c_api.ListPairIntInt_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairIntInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
