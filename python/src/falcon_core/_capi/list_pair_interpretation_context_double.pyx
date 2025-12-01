cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_interpretation_context_double

cdef class ListPairInterpretationContextDouble:
    def __cinit__(self):
        self.handle = <_c_api.ListPairInterpretationContextDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairInterpretationContextDoubleHandle>0 and self.owned:
            _c_api.ListPairInterpretationContextDouble_destroy(self.handle)
        self.handle = <_c_api.ListPairInterpretationContextDoubleHandle>0


cdef ListPairInterpretationContextDouble _list_pair_interpretation_context_double_from_capi(_c_api.ListPairInterpretationContextDoubleHandle h):
    if h == <_c_api.ListPairInterpretationContextDoubleHandle>0:
        return None
    cdef ListPairInterpretationContextDouble obj = ListPairInterpretationContextDouble.__new__(ListPairInterpretationContextDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairInterpretationContextDoubleHandle h
        h = _c_api.ListPairInterpretationContextDouble_create_empty()
        if h == <_c_api.ListPairInterpretationContextDoubleHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextDouble")
        cdef ListPairInterpretationContextDouble obj = <ListPairInterpretationContextDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairInterpretationContextDouble data, size_t count):
        cdef _c_api.ListPairInterpretationContextDoubleHandle h
        h = _c_api.ListPairInterpretationContextDouble_create(data.handle, count)
        if h == <_c_api.ListPairInterpretationContextDoubleHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextDouble")
        cdef ListPairInterpretationContextDouble obj = <ListPairInterpretationContextDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairInterpretationContextDoubleHandle h
        try:
            h = _c_api.ListPairInterpretationContextDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairInterpretationContextDoubleHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextDouble")
        cdef ListPairInterpretationContextDouble obj = <ListPairInterpretationContextDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairInterpretationContextDouble value):
        cdef _c_api.ListPairInterpretationContextDoubleHandle h_ret = _c_api.ListPairInterpretationContextDouble_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairInterpretationContextDoubleHandle>0:
            return None
        return _list_pair_interpretation_context_double_from_capi(h_ret)

    def push_back(self, PairInterpretationContextDouble value):
        _c_api.ListPairInterpretationContextDouble_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairInterpretationContextDouble_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairInterpretationContextDouble_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairInterpretationContextDouble_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairInterpretationContextDouble_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairInterpretationContextDoubleHandle h_ret = _c_api.ListPairInterpretationContextDouble_at(self.handle, idx)
        if h_ret == <_c_api.PairInterpretationContextDoubleHandle>0:
            return None
        return pair_interpretation_context_double._pair_interpretation_context_double_from_capi(h_ret)

    def items(self, PairInterpretationContextDouble out_buffer, size_t buffer_size):
        return _c_api.ListPairInterpretationContextDouble_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairInterpretationContextDouble value):
        return _c_api.ListPairInterpretationContextDouble_contains(self.handle, value.handle)

    def index(self, PairInterpretationContextDouble value):
        return _c_api.ListPairInterpretationContextDouble_index(self.handle, value.handle)

    def intersection(self, ListPairInterpretationContextDouble other):
        cdef _c_api.ListPairInterpretationContextDoubleHandle h_ret = _c_api.ListPairInterpretationContextDouble_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairInterpretationContextDoubleHandle>0:
            return None
        return _list_pair_interpretation_context_double_from_capi(h_ret)

    def equal(self, ListPairInterpretationContextDouble b):
        return _c_api.ListPairInterpretationContextDouble_equal(self.handle, b.handle)

    def __eq__(self, ListPairInterpretationContextDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairInterpretationContextDouble b):
        return _c_api.ListPairInterpretationContextDouble_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairInterpretationContextDouble b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
