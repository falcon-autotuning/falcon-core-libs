# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .pair_connection_pair_quantity_quantity cimport PairConnectionPairQuantityQuantity

cdef class ListPairConnectionPairQuantityQuantity:
    cdef c_api.ListPairConnectionPairQuantityQuantityHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ListPairConnectionPairQuantityQuantityHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ListPairConnectionPairQuantityQuantityHandle>0 and self.owned:
            c_api.ListPairConnectionPairQuantityQuantity_destroy(self.handle)
        self.handle = <c_api.ListPairConnectionPairQuantityQuantityHandle>0

    cdef ListPairConnectionPairQuantityQuantity from_capi(cls, c_api.ListPairConnectionPairQuantityQuantityHandle h):
        cdef ListPairConnectionPairQuantityQuantity obj = <ListPairConnectionPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ListPairConnectionPairQuantityQuantityHandle h
        h = c_api.ListPairConnectionPairQuantityQuantity_create_empty()
        if h == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create ListPairConnectionPairQuantityQuantity")
        cdef ListPairConnectionPairQuantityQuantity obj = <ListPairConnectionPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.ListPairConnectionPairQuantityQuantityHandle h
        h = c_api.ListPairConnectionPairQuantityQuantity_create(<c_api.PairConnectionPairQuantityQuantityHandle>data.handle, count)
        if h == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create ListPairConnectionPairQuantityQuantity")
        cdef ListPairConnectionPairQuantityQuantity obj = <ListPairConnectionPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ListPairConnectionPairQuantityQuantityHandle h
        try:
            h = c_api.ListPairConnectionPairQuantityQuantity_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise MemoryError("Failed to create ListPairConnectionPairQuantityQuantity")
        cdef ListPairConnectionPairQuantityQuantity obj = <ListPairConnectionPairQuantityQuantity>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(count, value):
        cdef c_api.ListPairConnectionPairQuantityQuantityHandle h_ret
        h_ret = c_api.ListPairConnectionPairQuantityQuantity_fill_value(count, <c_api.PairConnectionPairQuantityQuantityHandle>value.handle)
        if h_ret == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            return None
        return ListPairConnectionPairQuantityQuantity.from_capi(ListPairConnectionPairQuantityQuantity, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairConnectionPairQuantityQuantity_push_back(self.handle, <c_api.PairConnectionPairQuantityQuantityHandle>value.handle)

    def size(self):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairConnectionPairQuantityQuantity_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairConnectionPairQuantityQuantity_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairConnectionPairQuantityQuantity_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairConnectionPairQuantityQuantity_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PairConnectionPairQuantityQuantityHandle h_ret
        h_ret = c_api.ListPairConnectionPairQuantityQuantity_at(self.handle, idx)
        if h_ret == <c_api.PairConnectionPairQuantityQuantityHandle>0:
            return None
        return PairConnectionPairQuantityQuantity.from_capi(PairConnectionPairQuantityQuantity, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairConnectionPairQuantityQuantity_items(self.handle, <c_api.PairConnectionPairQuantityQuantityHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairConnectionPairQuantityQuantity_contains(self.handle, <c_api.PairConnectionPairQuantityQuantityHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairConnectionPairQuantityQuantity_index(self.handle, <c_api.PairConnectionPairQuantityQuantityHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairConnectionPairQuantityQuantityHandle h_ret
        h_ret = c_api.ListPairConnectionPairQuantityQuantity_intersection(self.handle, <c_api.ListPairConnectionPairQuantityQuantityHandle>other.handle)
        if h_ret == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            return None
        return ListPairConnectionPairQuantityQuantity.from_capi(ListPairConnectionPairQuantityQuantity, h_ret)

    def equal(self, b):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairConnectionPairQuantityQuantity_equal(self.handle, <c_api.ListPairConnectionPairQuantityQuantityHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairConnectionPairQuantityQuantity_not_equal(self.handle, <c_api.ListPairConnectionPairQuantityQuantityHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ListPairConnectionPairQuantityQuantityHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ListPairConnectionPairQuantityQuantity_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ListPairConnectionPairQuantityQuantity _listpairconnectionpairquantityquantity_from_capi(c_api.ListPairConnectionPairQuantityQuantityHandle h):
    cdef ListPairConnectionPairQuantityQuantity obj = <ListPairConnectionPairQuantityQuantity>ListPairConnectionPairQuantityQuantity.__new__(ListPairConnectionPairQuantityQuantity)
    obj.handle = h