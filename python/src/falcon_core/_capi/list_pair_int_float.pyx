cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_int_float

cdef class ListPairIntFloat:
    def __cinit__(self):
        self.handle = <_c_api.ListPairIntFloatHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairIntFloatHandle>0 and self.owned:
            _c_api.ListPairIntFloat_destroy(self.handle)
        self.handle = <_c_api.ListPairIntFloatHandle>0


cdef ListPairIntFloat _list_pair_int_float_from_capi(_c_api.ListPairIntFloatHandle h):
    if h == <_c_api.ListPairIntFloatHandle>0:
        return None
    cdef ListPairIntFloat obj = ListPairIntFloat.__new__(ListPairIntFloat)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListPairIntFloatHandle h
        h = _c_api.ListPairIntFloat_create_empty()
        if h == <_c_api.ListPairIntFloatHandle>0:
            raise MemoryError("Failed to create ListPairIntFloat")
        cdef ListPairIntFloat obj = <ListPairIntFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairIntFloat data, size_t count):
        cdef _c_api.ListPairIntFloatHandle h
        h = _c_api.ListPairIntFloat_create(data.handle, count)
        if h == <_c_api.ListPairIntFloatHandle>0:
            raise MemoryError("Failed to create ListPairIntFloat")
        cdef ListPairIntFloat obj = <ListPairIntFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairIntFloatHandle h
        try:
            h = _c_api.ListPairIntFloat_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairIntFloatHandle>0:
            raise MemoryError("Failed to create ListPairIntFloat")
        cdef ListPairIntFloat obj = <ListPairIntFloat>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairIntFloat value):
        cdef _c_api.ListPairIntFloatHandle h_ret = _c_api.ListPairIntFloat_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairIntFloatHandle>0:
            return None
        return _list_pair_int_float_from_capi(h_ret)

    def push_back(self, PairIntFloat value):
        _c_api.ListPairIntFloat_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairIntFloat_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairIntFloat_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairIntFloat_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairIntFloat_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairIntFloatHandle h_ret = _c_api.ListPairIntFloat_at(self.handle, idx)
        if h_ret == <_c_api.PairIntFloatHandle>0:
            return None
        return pair_int_float._pair_int_float_from_capi(h_ret)

    def items(self, PairIntFloat out_buffer, size_t buffer_size):
        return _c_api.ListPairIntFloat_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairIntFloat value):
        return _c_api.ListPairIntFloat_contains(self.handle, value.handle)

    def index(self, PairIntFloat value):
        return _c_api.ListPairIntFloat_index(self.handle, value.handle)

    def intersection(self, ListPairIntFloat other):
        cdef _c_api.ListPairIntFloatHandle h_ret = _c_api.ListPairIntFloat_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairIntFloatHandle>0:
            return None
        return _list_pair_int_float_from_capi(h_ret)

    def equal(self, ListPairIntFloat b):
        return _c_api.ListPairIntFloat_equal(self.handle, b.handle)

    def __eq__(self, ListPairIntFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairIntFloat b):
        return _c_api.ListPairIntFloat_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairIntFloat b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
