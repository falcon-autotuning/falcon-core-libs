# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connections cimport Connections
from .f_array_int cimport FArrayInt
from .list_list_size_t cimport ListListSizeT
from .list_pair_size_t_size_t cimport ListPairSizeTSizeT

cdef class Adjacency:
    cdef c_api.AdjacencyHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.AdjacencyHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.AdjacencyHandle>0 and self.owned:
            c_api.Adjacency_destroy(self.handle)
        self.handle = <c_api.AdjacencyHandle>0

    cdef Adjacency from_capi(cls, c_api.AdjacencyHandle h):
        cdef Adjacency obj = <Adjacency>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, data, shape, ndim, indexes):
        cdef c_api.AdjacencyHandle h
        h = c_api.Adjacency_create(data, shape, ndim, <c_api.ConnectionsHandle>indexes.handle)
        if h == <c_api.AdjacencyHandle>0:
            raise MemoryError("Failed to create Adjacency")
        cdef Adjacency obj = <Adjacency>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.AdjacencyHandle h
        try:
            h = c_api.Adjacency_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.AdjacencyHandle>0:
            raise MemoryError("Failed to create Adjacency")
        cdef Adjacency obj = <Adjacency>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def indexes(self):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.Adjacency_indexes(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def get_true_pairs(self):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairSizeTSizeTHandle h_ret
        h_ret = c_api.Adjacency_get_true_pairs(self.handle)
        if h_ret == <c_api.ListPairSizeTSizeTHandle>0:
            return None
        return ListPairSizeTSizeT.from_capi(ListPairSizeTSizeT, h_ret)

    def size(self):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Adjacency_size(self.handle)

    def dimension(self):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Adjacency_dimension(self.handle)

    def shape(self, out_buffer, ndim):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Adjacency_shape(self.handle, out_buffer, ndim)

    def data(self, out_buffer, numdata):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Adjacency_data(self.handle, out_buffer, numdata)

    def timesequals_farray(self, other):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        c_api.Adjacency_timesequals_farray(self.handle, <c_api.FArrayIntHandle>other.handle)

    def times_farray(self, other):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AdjacencyHandle h_ret
        h_ret = c_api.Adjacency_times_farray(self.handle, <c_api.FArrayIntHandle>other.handle)
        if h_ret == <c_api.AdjacencyHandle>0:
            return None
        return Adjacency.from_capi(Adjacency, h_ret)

    def equality(self, other):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Adjacency_equality(self.handle, <c_api.AdjacencyHandle>other.handle)

    def notequality(self, other):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Adjacency_notequality(self.handle, <c_api.AdjacencyHandle>other.handle)

    def sum(self):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.Adjacency_sum(self.handle)

    def where(self, value):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListListSizeTHandle h_ret
        h_ret = c_api.Adjacency_where(self.handle, value)
        if h_ret == <c_api.ListListSizeTHandle>0:
            return None
        return ListListSizeT.from_capi(ListListSizeT, h_ret)

    def flip(self, axis):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AdjacencyHandle h_ret
        h_ret = c_api.Adjacency_flip(self.handle, axis)
        if h_ret == <c_api.AdjacencyHandle>0:
            return None
        return Adjacency.from_capi(Adjacency, h_ret)

    def to_json_string(self):
        if self.handle == <c_api.AdjacencyHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.Adjacency_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef Adjacency _adjacency_from_capi(c_api.AdjacencyHandle h):
    cdef Adjacency obj = <Adjacency>Adjacency.__new__(Adjacency)
    obj.handle = h