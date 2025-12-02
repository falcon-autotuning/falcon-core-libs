cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_size_t_size_t

cdef class ListPairSizeTSizeT:
    def __cinit__(self):
        self.handle = <_c_api.ListPairSizeTSizeTHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairSizeTSizeTHandle>0 and self.owned:
            _c_api.ListPairSizeTSizeT_destroy(self.handle)
        self.handle = <_c_api.ListPairSizeTSizeTHandle>0


cdef ListPairSizeTSizeT _list_pair_size_t_size_t_from_capi(_c_api.ListPairSizeTSizeTHandle h):
    if h == <_c_api.ListPairSizeTSizeTHandle>0:
        return None
    cdef ListPairSizeTSizeT obj = ListPairSizeTSizeT.__new__(ListPairSizeTSizeT)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListPairSizeTSizeTHandle h
        h = _c_api.ListPairSizeTSizeT_create_empty()
        if h == <_c_api.ListPairSizeTSizeTHandle>0:
            raise MemoryError("Failed to create ListPairSizeTSizeT")
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairSizeTSizeT data, size_t count):
        cdef _c_api.ListPairSizeTSizeTHandle h
        h = _c_api.ListPairSizeTSizeT_create(data.handle, count)
        if h == <_c_api.ListPairSizeTSizeTHandle>0:
            raise MemoryError("Failed to create ListPairSizeTSizeT")
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairSizeTSizeTHandle h
        try:
            h = _c_api.ListPairSizeTSizeT_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairSizeTSizeTHandle>0:
            raise MemoryError("Failed to create ListPairSizeTSizeT")
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairSizeTSizeT value):
        cdef _c_api.ListPairSizeTSizeTHandle h_ret = _c_api.ListPairSizeTSizeT_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairSizeTSizeTHandle>0:
            return None
        return _list_pair_size_t_size_t_from_capi(h_ret)

    def push_back(self, PairSizeTSizeT value):
        _c_api.ListPairSizeTSizeT_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairSizeTSizeT_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairSizeTSizeT_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairSizeTSizeT_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairSizeTSizeT_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairSizeTSizeTHandle h_ret = _c_api.ListPairSizeTSizeT_at(self.handle, idx)
        if h_ret == <_c_api.PairSizeTSizeTHandle>0:
            return None
        return pair_size_t_size_t._pair_size_t_size_t_from_capi(h_ret)

    def items(self, PairSizeTSizeT out_buffer, size_t buffer_size):
        return _c_api.ListPairSizeTSizeT_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairSizeTSizeT value):
        return _c_api.ListPairSizeTSizeT_contains(self.handle, value.handle)

    def index(self, PairSizeTSizeT value):
        return _c_api.ListPairSizeTSizeT_index(self.handle, value.handle)

    def intersection(self, ListPairSizeTSizeT other):
        cdef _c_api.ListPairSizeTSizeTHandle h_ret = _c_api.ListPairSizeTSizeT_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairSizeTSizeTHandle>0:
            return None
        return _list_pair_size_t_size_t_from_capi(h_ret)

    def equal(self, ListPairSizeTSizeT b):
        return _c_api.ListPairSizeTSizeT_equal(self.handle, b.handle)

    def __eq__(self, ListPairSizeTSizeT b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairSizeTSizeT b):
        return _c_api.ListPairSizeTSizeT_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairSizeTSizeT b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
