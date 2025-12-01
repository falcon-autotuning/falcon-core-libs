cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_interpretation_context_string

cdef class ListPairInterpretationContextString:
    def __cinit__(self):
        self.handle = <_c_api.ListPairInterpretationContextStringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairInterpretationContextStringHandle>0 and self.owned:
            _c_api.ListPairInterpretationContextString_destroy(self.handle)
        self.handle = <_c_api.ListPairInterpretationContextStringHandle>0


cdef ListPairInterpretationContextString _list_pair_interpretation_context_string_from_capi(_c_api.ListPairInterpretationContextStringHandle h):
    if h == <_c_api.ListPairInterpretationContextStringHandle>0:
        return None
    cdef ListPairInterpretationContextString obj = ListPairInterpretationContextString.__new__(ListPairInterpretationContextString)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairInterpretationContextStringHandle h
        h = _c_api.ListPairInterpretationContextString_create_empty()
        if h == <_c_api.ListPairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextString")
        cdef ListPairInterpretationContextString obj = <ListPairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairInterpretationContextString data, size_t count):
        cdef _c_api.ListPairInterpretationContextStringHandle h
        h = _c_api.ListPairInterpretationContextString_create(data.handle, count)
        if h == <_c_api.ListPairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextString")
        cdef ListPairInterpretationContextString obj = <ListPairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairInterpretationContextStringHandle h
        try:
            h = _c_api.ListPairInterpretationContextString_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairInterpretationContextStringHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextString")
        cdef ListPairInterpretationContextString obj = <ListPairInterpretationContextString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairInterpretationContextString value):
        cdef _c_api.ListPairInterpretationContextStringHandle h_ret = _c_api.ListPairInterpretationContextString_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairInterpretationContextStringHandle>0:
            return None
        return _list_pair_interpretation_context_string_from_capi(h_ret)

    def push_back(self, PairInterpretationContextString value):
        _c_api.ListPairInterpretationContextString_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairInterpretationContextString_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairInterpretationContextString_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairInterpretationContextString_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairInterpretationContextString_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairInterpretationContextStringHandle h_ret = _c_api.ListPairInterpretationContextString_at(self.handle, idx)
        if h_ret == <_c_api.PairInterpretationContextStringHandle>0:
            return None
        return pair_interpretation_context_string._pair_interpretation_context_string_from_capi(h_ret)

    def items(self, PairInterpretationContextString out_buffer, size_t buffer_size):
        return _c_api.ListPairInterpretationContextString_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairInterpretationContextString value):
        return _c_api.ListPairInterpretationContextString_contains(self.handle, value.handle)

    def index(self, PairInterpretationContextString value):
        return _c_api.ListPairInterpretationContextString_index(self.handle, value.handle)

    def intersection(self, ListPairInterpretationContextString other):
        cdef _c_api.ListPairInterpretationContextStringHandle h_ret = _c_api.ListPairInterpretationContextString_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairInterpretationContextStringHandle>0:
            return None
        return _list_pair_interpretation_context_string_from_capi(h_ret)

    def equal(self, ListPairInterpretationContextString b):
        return _c_api.ListPairInterpretationContextString_equal(self.handle, b.handle)

    def __eq__(self, ListPairInterpretationContextString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairInterpretationContextString b):
        return _c_api.ListPairInterpretationContextString_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairInterpretationContextString b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
