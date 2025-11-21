# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .pair_size_t_size_t cimport PairSizeTSizeT

cdef class ListPairSizeTSizeT:
    cdef c_api.ListPairSizeTSizeTHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ListPairSizeTSizeTHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ListPairSizeTSizeTHandle>0 and self.owned:
            c_api.ListPairSizeTSizeT_destroy(self.handle)
        self.handle = <c_api.ListPairSizeTSizeTHandle>0

    cdef ListPairSizeTSizeT from_capi(cls, c_api.ListPairSizeTSizeTHandle h):
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ListPairSizeTSizeTHandle h
        h = c_api.ListPairSizeTSizeT_create_empty()
        if h == <c_api.ListPairSizeTSizeTHandle>0:
            raise MemoryError("Failed to create ListPairSizeTSizeT")
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.ListPairSizeTSizeTHandle h
        h = c_api.ListPairSizeTSizeT_create(<c_api.PairSizeTSizeTHandle>data.handle, count)
        if h == <c_api.ListPairSizeTSizeTHandle>0:
            raise MemoryError("Failed to create ListPairSizeTSizeT")
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ListPairSizeTSizeTHandle h
        try:
            h = c_api.ListPairSizeTSizeT_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ListPairSizeTSizeTHandle>0:
            raise MemoryError("Failed to create ListPairSizeTSizeT")
        cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(count, value):
        cdef c_api.ListPairSizeTSizeTHandle h_ret
        h_ret = c_api.ListPairSizeTSizeT_fill_value(count, <c_api.PairSizeTSizeTHandle>value.handle)
        if h_ret == <c_api.ListPairSizeTSizeTHandle>0:
            return None
        return ListPairSizeTSizeT.from_capi(ListPairSizeTSizeT, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairSizeTSizeT_push_back(self.handle, <c_api.PairSizeTSizeTHandle>value.handle)

    def size(self):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairSizeTSizeT_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairSizeTSizeT_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairSizeTSizeT_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairSizeTSizeT_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PairSizeTSizeTHandle h_ret
        h_ret = c_api.ListPairSizeTSizeT_at(self.handle, idx)
        if h_ret == <c_api.PairSizeTSizeTHandle>0:
            return None
        return PairSizeTSizeT.from_capi(PairSizeTSizeT, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairSizeTSizeT_items(self.handle, <c_api.PairSizeTSizeTHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairSizeTSizeT_contains(self.handle, <c_api.PairSizeTSizeTHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairSizeTSizeT_index(self.handle, <c_api.PairSizeTSizeTHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairSizeTSizeTHandle h_ret
        h_ret = c_api.ListPairSizeTSizeT_intersection(self.handle, <c_api.ListPairSizeTSizeTHandle>other.handle)
        if h_ret == <c_api.ListPairSizeTSizeTHandle>0:
            return None
        return ListPairSizeTSizeT.from_capi(ListPairSizeTSizeT, h_ret)

    def equal(self, b):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairSizeTSizeT_equal(self.handle, <c_api.ListPairSizeTSizeTHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairSizeTSizeT_not_equal(self.handle, <c_api.ListPairSizeTSizeTHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ListPairSizeTSizeTHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ListPairSizeTSizeT_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ListPairSizeTSizeT _listpairsizetsizet_from_capi(c_api.ListPairSizeTSizeTHandle h):
    cdef ListPairSizeTSizeT obj = <ListPairSizeTSizeT>ListPairSizeTSizeT.__new__(ListPairSizeTSizeT)
    obj.handle = h