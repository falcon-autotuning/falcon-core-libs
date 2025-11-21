# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .pair_string_double cimport PairStringDouble

cdef class ListPairStringDouble:
    cdef c_api.ListPairStringDoubleHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ListPairStringDoubleHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ListPairStringDoubleHandle>0 and self.owned:
            c_api.ListPairStringDouble_destroy(self.handle)
        self.handle = <c_api.ListPairStringDoubleHandle>0

    cdef ListPairStringDouble from_capi(cls, c_api.ListPairStringDoubleHandle h):
        cdef ListPairStringDouble obj = <ListPairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.ListPairStringDoubleHandle h
        h = c_api.ListPairStringDouble_create_empty()
        if h == <c_api.ListPairStringDoubleHandle>0:
            raise MemoryError("Failed to create ListPairStringDouble")
        cdef ListPairStringDouble obj = <ListPairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.ListPairStringDoubleHandle h
        h = c_api.ListPairStringDouble_create(<c_api.PairStringDoubleHandle>data.handle, count)
        if h == <c_api.ListPairStringDoubleHandle>0:
            raise MemoryError("Failed to create ListPairStringDouble")
        cdef ListPairStringDouble obj = <ListPairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ListPairStringDoubleHandle h
        try:
            h = c_api.ListPairStringDouble_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ListPairStringDoubleHandle>0:
            raise MemoryError("Failed to create ListPairStringDouble")
        cdef ListPairStringDouble obj = <ListPairStringDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(count, value):
        cdef c_api.ListPairStringDoubleHandle h_ret
        h_ret = c_api.ListPairStringDouble_fill_value(count, <c_api.PairStringDoubleHandle>value.handle)
        if h_ret == <c_api.ListPairStringDoubleHandle>0:
            return None
        return ListPairStringDouble.from_capi(ListPairStringDouble, h_ret)

    def push_back(self, value):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairStringDouble_push_back(self.handle, <c_api.PairStringDoubleHandle>value.handle)

    def size(self):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairStringDouble_size(self.handle)

    def empty(self):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairStringDouble_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairStringDouble_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ListPairStringDouble_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.PairStringDoubleHandle h_ret
        h_ret = c_api.ListPairStringDouble_at(self.handle, idx)
        if h_ret == <c_api.PairStringDoubleHandle>0:
            return None
        return PairStringDouble.from_capi(PairStringDouble, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairStringDouble_items(self.handle, <c_api.PairStringDoubleHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairStringDouble_contains(self.handle, <c_api.PairStringDoubleHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairStringDouble_index(self.handle, <c_api.PairStringDoubleHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairStringDoubleHandle h_ret
        h_ret = c_api.ListPairStringDouble_intersection(self.handle, <c_api.ListPairStringDoubleHandle>other.handle)
        if h_ret == <c_api.ListPairStringDoubleHandle>0:
            return None
        return ListPairStringDouble.from_capi(ListPairStringDouble, h_ret)

    def equal(self, b):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairStringDouble_equal(self.handle, <c_api.ListPairStringDoubleHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ListPairStringDouble_not_equal(self.handle, <c_api.ListPairStringDoubleHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.ListPairStringDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ListPairStringDouble_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ListPairStringDouble _listpairstringdouble_from_capi(c_api.ListPairStringDoubleHandle h):
    cdef ListPairStringDouble obj = <ListPairStringDouble>ListPairStringDouble.__new__(ListPairStringDouble)
    obj.handle = h