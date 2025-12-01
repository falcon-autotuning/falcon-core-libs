cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_connection_quantity

cdef class ListPairConnectionQuantity:
    def __cinit__(self):
        self.handle = <_c_api.ListPairConnectionQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairConnectionQuantityHandle>0 and self.owned:
            _c_api.ListPairConnectionQuantity_destroy(self.handle)
        self.handle = <_c_api.ListPairConnectionQuantityHandle>0


cdef ListPairConnectionQuantity _list_pair_connection_quantity_from_capi(_c_api.ListPairConnectionQuantityHandle h):
    if h == <_c_api.ListPairConnectionQuantityHandle>0:
        return None
    cdef ListPairConnectionQuantity obj = ListPairConnectionQuantity.__new__(ListPairConnectionQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairConnectionQuantityHandle h
        h = _c_api.ListPairConnectionQuantity_create_empty()
        if h == <_c_api.ListPairConnectionQuantityHandle>0:
            raise MemoryError("Failed to create ListPairConnectionQuantity")
        cdef ListPairConnectionQuantity obj = <ListPairConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairConnectionQuantity data, size_t count):
        cdef _c_api.ListPairConnectionQuantityHandle h
        h = _c_api.ListPairConnectionQuantity_create(data.handle, count)
        if h == <_c_api.ListPairConnectionQuantityHandle>0:
            raise MemoryError("Failed to create ListPairConnectionQuantity")
        cdef ListPairConnectionQuantity obj = <ListPairConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairConnectionQuantityHandle h
        try:
            h = _c_api.ListPairConnectionQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairConnectionQuantityHandle>0:
            raise MemoryError("Failed to create ListPairConnectionQuantity")
        cdef ListPairConnectionQuantity obj = <ListPairConnectionQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairConnectionQuantity value):
        cdef _c_api.ListPairConnectionQuantityHandle h_ret = _c_api.ListPairConnectionQuantity_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairConnectionQuantityHandle>0:
            return None
        return _list_pair_connection_quantity_from_capi(h_ret)

    def push_back(self, PairConnectionQuantity value):
        _c_api.ListPairConnectionQuantity_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairConnectionQuantity_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairConnectionQuantity_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairConnectionQuantity_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairConnectionQuantity_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairConnectionQuantityHandle h_ret = _c_api.ListPairConnectionQuantity_at(self.handle, idx)
        if h_ret == <_c_api.PairConnectionQuantityHandle>0:
            return None
        return pair_connection_quantity._pair_connection_quantity_from_capi(h_ret)

    def items(self, PairConnectionQuantity out_buffer, size_t buffer_size):
        return _c_api.ListPairConnectionQuantity_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairConnectionQuantity value):
        return _c_api.ListPairConnectionQuantity_contains(self.handle, value.handle)

    def index(self, PairConnectionQuantity value):
        return _c_api.ListPairConnectionQuantity_index(self.handle, value.handle)

    def intersection(self, ListPairConnectionQuantity other):
        cdef _c_api.ListPairConnectionQuantityHandle h_ret = _c_api.ListPairConnectionQuantity_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairConnectionQuantityHandle>0:
            return None
        return _list_pair_connection_quantity_from_capi(h_ret)

    def equal(self, ListPairConnectionQuantity b):
        return _c_api.ListPairConnectionQuantity_equal(self.handle, b.handle)

    def __eq__(self, ListPairConnectionQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairConnectionQuantity b):
        return _c_api.ListPairConnectionQuantity_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairConnectionQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
