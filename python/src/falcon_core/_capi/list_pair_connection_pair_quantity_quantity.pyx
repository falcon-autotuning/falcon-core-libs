cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_connection_pair_quantity_quantity

cdef class ListPairConnectionPairQuantityQuantity:
    def __cinit__(self):
        self.handle = <_c_api.ListPairConnectionPairQuantityQuantityHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairConnectionPairQuantityQuantityHandle>0 and self.owned:
            _c_api.ListPairConnectionPairQuantityQuantity_destroy(self.handle)
        self.handle = <_c_api.ListPairConnectionPairQuantityQuantityHandle>0


cdef ListPairConnectionPairQuantityQuantity _list_pair_connection_pair_quantity_quantity_from_capi(_c_api.ListPairConnectionPairQuantityQuantityHandle h):
    if h == <_c_api.ListPairConnectionPairQuantityQuantityHandle>0:
        return None
    cdef ListPairConnectionPairQuantityQuantity obj = ListPairConnectionPairQuantityQuantity.__new__(ListPairConnectionPairQuantityQuantity)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairConnectionPairQuantityQuantityHandle h
        h = _c_api.ListPairConnectionPairQuantityQuantity_create_empty()
        if h == <_c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create ListPairConnectionPairQuantityQuantity")
        cdef ListPairConnectionPairQuantityQuantity obj = <ListPairConnectionPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairConnectionPairQuantityQuantity data, size_t count):
        cdef _c_api.ListPairConnectionPairQuantityQuantityHandle h
        h = _c_api.ListPairConnectionPairQuantityQuantity_create(data.handle, count)
        if h == <_c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create ListPairConnectionPairQuantityQuantity")
        cdef ListPairConnectionPairQuantityQuantity obj = <ListPairConnectionPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairConnectionPairQuantityQuantityHandle h
        try:
            h = _c_api.ListPairConnectionPairQuantityQuantity_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create ListPairConnectionPairQuantityQuantity")
        cdef ListPairConnectionPairQuantityQuantity obj = <ListPairConnectionPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairConnectionPairQuantityQuantity value):
        cdef _c_api.ListPairConnectionPairQuantityQuantityHandle h_ret = _c_api.ListPairConnectionPairQuantityQuantity_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            return None
        return _list_pair_connection_pair_quantity_quantity_from_capi(h_ret)

    def push_back(self, PairConnectionPairQuantityQuantity value):
        _c_api.ListPairConnectionPairQuantityQuantity_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairConnectionPairQuantityQuantity_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairConnectionPairQuantityQuantity_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairConnectionPairQuantityQuantity_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairConnectionPairQuantityQuantity_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairConnectionPairQuantityQuantityHandle h_ret = _c_api.ListPairConnectionPairQuantityQuantity_at(self.handle, idx)
        if h_ret == <_c_api.PairConnectionPairQuantityQuantityHandle>0:
            return None
        return pair_connection_pair_quantity_quantity._pair_connection_pair_quantity_quantity_from_capi(h_ret)

    def items(self, PairConnectionPairQuantityQuantity out_buffer, size_t buffer_size):
        return _c_api.ListPairConnectionPairQuantityQuantity_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairConnectionPairQuantityQuantity value):
        return _c_api.ListPairConnectionPairQuantityQuantity_contains(self.handle, value.handle)

    def index(self, PairConnectionPairQuantityQuantity value):
        return _c_api.ListPairConnectionPairQuantityQuantity_index(self.handle, value.handle)

    def intersection(self, ListPairConnectionPairQuantityQuantity other):
        cdef _c_api.ListPairConnectionPairQuantityQuantityHandle h_ret = _c_api.ListPairConnectionPairQuantityQuantity_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            return None
        return _list_pair_connection_pair_quantity_quantity_from_capi(h_ret)

    def equal(self, ListPairConnectionPairQuantityQuantity b):
        return _c_api.ListPairConnectionPairQuantityQuantity_equal(self.handle, b.handle)

    def __eq__(self, ListPairConnectionPairQuantityQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairConnectionPairQuantityQuantity b):
        return _c_api.ListPairConnectionPairQuantityQuantity_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairConnectionPairQuantityQuantity b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
