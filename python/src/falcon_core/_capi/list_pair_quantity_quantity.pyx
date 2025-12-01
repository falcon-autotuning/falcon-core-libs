cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_quantity_quantity

cdef class ListPairQuantityQuantity:
    def __cinit__(self):
        self.handle = <_c_api.ListPairQuantityQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairQuantityQuantityHandle>0 and self.owned:
            _c_api.ListPairQuantityQuantity_destroy(self.handle)
        self.handle = <_c_api.ListPairQuantityQuantityHandle>0


cdef ListPairQuantityQuantity _list_pair_quantity_quantity_from_capi(_c_api.ListPairQuantityQuantityHandle h):
    if h == <_c_api.ListPairQuantityQuantityHandle>0:
        return None
    cdef ListPairQuantityQuantity obj = ListPairQuantityQuantity.__new__(ListPairQuantityQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairQuantityQuantityHandle h
        h = _c_api.ListPairQuantityQuantity_create_empty()
        if h == <_c_api.ListPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create ListPairQuantityQuantity")
        cdef ListPairQuantityQuantity obj = <ListPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairQuantityQuantity data, size_t count):
        cdef _c_api.ListPairQuantityQuantityHandle h
        h = _c_api.ListPairQuantityQuantity_create(data.handle, count)
        if h == <_c_api.ListPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create ListPairQuantityQuantity")
        cdef ListPairQuantityQuantity obj = <ListPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairQuantityQuantityHandle h
        try:
            h = _c_api.ListPairQuantityQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create ListPairQuantityQuantity")
        cdef ListPairQuantityQuantity obj = <ListPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairQuantityQuantity value):
        cdef _c_api.ListPairQuantityQuantityHandle h_ret = _c_api.ListPairQuantityQuantity_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairQuantityQuantityHandle>0:
            return None
        return _list_pair_quantity_quantity_from_capi(h_ret)

    def push_back(self, PairQuantityQuantity value):
        _c_api.ListPairQuantityQuantity_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairQuantityQuantity_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairQuantityQuantity_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairQuantityQuantity_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairQuantityQuantity_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairQuantityQuantityHandle h_ret = _c_api.ListPairQuantityQuantity_at(self.handle, idx)
        if h_ret == <_c_api.PairQuantityQuantityHandle>0:
            return None
        return pair_quantity_quantity._pair_quantity_quantity_from_capi(h_ret)

    def items(self, PairQuantityQuantity out_buffer, size_t buffer_size):
        return _c_api.ListPairQuantityQuantity_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairQuantityQuantity value):
        return _c_api.ListPairQuantityQuantity_contains(self.handle, value.handle)

    def index(self, PairQuantityQuantity value):
        return _c_api.ListPairQuantityQuantity_index(self.handle, value.handle)

    def intersection(self, ListPairQuantityQuantity other):
        cdef _c_api.ListPairQuantityQuantityHandle h_ret = _c_api.ListPairQuantityQuantity_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairQuantityQuantityHandle>0:
            return None
        return _list_pair_quantity_quantity_from_capi(h_ret)

    def equal(self, ListPairQuantityQuantity b):
        return _c_api.ListPairQuantityQuantity_equal(self.handle, b.handle)

    def __eq__(self, ListPairQuantityQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairQuantityQuantity b):
        return _c_api.ListPairQuantityQuantity_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairQuantityQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
