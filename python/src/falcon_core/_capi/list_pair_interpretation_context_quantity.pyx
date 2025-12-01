cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_interpretation_context_quantity

cdef class ListPairInterpretationContextQuantity:
    def __cinit__(self):
        self.handle = <_c_api.ListPairInterpretationContextQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairInterpretationContextQuantityHandle>0 and self.owned:
            _c_api.ListPairInterpretationContextQuantity_destroy(self.handle)
        self.handle = <_c_api.ListPairInterpretationContextQuantityHandle>0


cdef ListPairInterpretationContextQuantity _list_pair_interpretation_context_quantity_from_capi(_c_api.ListPairInterpretationContextQuantityHandle h):
    if h == <_c_api.ListPairInterpretationContextQuantityHandle>0:
        return None
    cdef ListPairInterpretationContextQuantity obj = ListPairInterpretationContextQuantity.__new__(ListPairInterpretationContextQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairInterpretationContextQuantityHandle h
        h = _c_api.ListPairInterpretationContextQuantity_create_empty()
        if h == <_c_api.ListPairInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextQuantity")
        cdef ListPairInterpretationContextQuantity obj = <ListPairInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairInterpretationContextQuantity data, size_t count):
        cdef _c_api.ListPairInterpretationContextQuantityHandle h
        h = _c_api.ListPairInterpretationContextQuantity_create(data.handle, count)
        if h == <_c_api.ListPairInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextQuantity")
        cdef ListPairInterpretationContextQuantity obj = <ListPairInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairInterpretationContextQuantityHandle h
        try:
            h = _c_api.ListPairInterpretationContextQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairInterpretationContextQuantityHandle>0:
            raise MemoryError("Failed to create ListPairInterpretationContextQuantity")
        cdef ListPairInterpretationContextQuantity obj = <ListPairInterpretationContextQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairInterpretationContextQuantity value):
        cdef _c_api.ListPairInterpretationContextQuantityHandle h_ret = _c_api.ListPairInterpretationContextQuantity_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairInterpretationContextQuantityHandle>0:
            return None
        return _list_pair_interpretation_context_quantity_from_capi(h_ret)

    def push_back(self, PairInterpretationContextQuantity value):
        _c_api.ListPairInterpretationContextQuantity_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairInterpretationContextQuantity_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairInterpretationContextQuantity_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairInterpretationContextQuantity_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairInterpretationContextQuantity_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairInterpretationContextQuantityHandle h_ret = _c_api.ListPairInterpretationContextQuantity_at(self.handle, idx)
        if h_ret == <_c_api.PairInterpretationContextQuantityHandle>0:
            return None
        return pair_interpretation_context_quantity._pair_interpretation_context_quantity_from_capi(h_ret)

    def items(self, PairInterpretationContextQuantity out_buffer, size_t buffer_size):
        return _c_api.ListPairInterpretationContextQuantity_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairInterpretationContextQuantity value):
        return _c_api.ListPairInterpretationContextQuantity_contains(self.handle, value.handle)

    def index(self, PairInterpretationContextQuantity value):
        return _c_api.ListPairInterpretationContextQuantity_index(self.handle, value.handle)

    def intersection(self, ListPairInterpretationContextQuantity other):
        cdef _c_api.ListPairInterpretationContextQuantityHandle h_ret = _c_api.ListPairInterpretationContextQuantity_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairInterpretationContextQuantityHandle>0:
            return None
        return _list_pair_interpretation_context_quantity_from_capi(h_ret)

    def equal(self, ListPairInterpretationContextQuantity b):
        return _c_api.ListPairInterpretationContextQuantity_equal(self.handle, b.handle)

    def __eq__(self, ListPairInterpretationContextQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairInterpretationContextQuantity b):
        return _c_api.ListPairInterpretationContextQuantity_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairInterpretationContextQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
