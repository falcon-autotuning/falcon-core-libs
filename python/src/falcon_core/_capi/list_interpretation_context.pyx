cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport interpretation_context

cdef class ListInterpretationContext:
    def __cinit__(self):
        self.handle = <_c_api.ListInterpretationContextHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListInterpretationContextHandle>0 and self.owned:
            _c_api.ListInterpretationContext_destroy(self.handle)
        self.handle = <_c_api.ListInterpretationContextHandle>0


cdef ListInterpretationContext _list_interpretation_context_from_capi(_c_api.ListInterpretationContextHandle h):
    if h == <_c_api.ListInterpretationContextHandle>0:
        return None
    cdef ListInterpretationContext obj = ListInterpretationContext.__new__(ListInterpretationContext)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListInterpretationContextHandle h
        h = _c_api.ListInterpretationContext_create_empty()
        if h == <_c_api.ListInterpretationContextHandle>0:
            raise MemoryError("Failed to create ListInterpretationContext")
        cdef ListInterpretationContext obj = <ListInterpretationContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, InterpretationContext data, size_t count):
        cdef _c_api.ListInterpretationContextHandle h
        h = _c_api.ListInterpretationContext_create(data.handle, count)
        if h == <_c_api.ListInterpretationContextHandle>0:
            raise MemoryError("Failed to create ListInterpretationContext")
        cdef ListInterpretationContext obj = <ListInterpretationContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListInterpretationContextHandle h
        try:
            h = _c_api.ListInterpretationContext_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListInterpretationContextHandle>0:
            raise MemoryError("Failed to create ListInterpretationContext")
        cdef ListInterpretationContext obj = <ListInterpretationContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, InterpretationContext value):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.ListInterpretationContext_fill_value(count, value.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return _list_interpretation_context_from_capi(h_ret)

    def push_back(self, InterpretationContext value):
        _c_api.ListInterpretationContext_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListInterpretationContext_size(self.handle)

    def empty(self, ):
        return _c_api.ListInterpretationContext_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListInterpretationContext_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListInterpretationContext_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.InterpretationContextHandle h_ret = _c_api.ListInterpretationContext_at(self.handle, idx)
        if h_ret == <_c_api.InterpretationContextHandle>0:
            return None
        return interpretation_context._interpretation_context_from_capi(h_ret)

    def items(self, InterpretationContext out_buffer, size_t buffer_size):
        return _c_api.ListInterpretationContext_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, InterpretationContext value):
        return _c_api.ListInterpretationContext_contains(self.handle, value.handle)

    def index(self, InterpretationContext value):
        return _c_api.ListInterpretationContext_index(self.handle, value.handle)

    def intersection(self, ListInterpretationContext other):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.ListInterpretationContext_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return _list_interpretation_context_from_capi(h_ret)

    def equal(self, ListInterpretationContext b):
        return _c_api.ListInterpretationContext_equal(self.handle, b.handle)

    def __eq__(self, ListInterpretationContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListInterpretationContext b):
        return _c_api.ListInterpretationContext_not_equal(self.handle, b.handle)

    def __ne__(self, ListInterpretationContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
