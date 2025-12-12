cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connections
from . cimport f_array_int
from . cimport list_list_size_t
from . cimport list_pair_size_t_size_t

cdef class Adjacency:
    def __cinit__(self):
        self.handle = <_c_api.AdjacencyHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AdjacencyHandle>0 and self.owned:
            _c_api.Adjacency_destroy(self.handle)
        self.handle = <_c_api.AdjacencyHandle>0


cdef Adjacency _adjacency_from_capi(_c_api.AdjacencyHandle h):
    if h == <_c_api.AdjacencyHandle>0:
        return None
    cdef Adjacency obj = Adjacency.__new__(Adjacency)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, int data, size_t shape, size_t ndim, Connections indexes):
        cdef _c_api.AdjacencyHandle h
        h = _c_api.Adjacency_create(data, shape, ndim, indexes.handle)
        if h == <_c_api.AdjacencyHandle>0:
            raise MemoryError("Failed to create Adjacency")
        cdef Adjacency obj = <Adjacency>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AdjacencyHandle h
        try:
            h = _c_api.Adjacency_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AdjacencyHandle>0:
            raise MemoryError("Failed to create Adjacency")
        cdef Adjacency obj = <Adjacency>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def indexes(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Adjacency_indexes(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def get_true_pairs(self, ):
        cdef _c_api.ListPairSizeTSizeTHandle h_ret = _c_api.Adjacency_get_true_pairs(self.handle)
        if h_ret == <_c_api.ListPairSizeTSizeTHandle>0:
            return None
        return list_pair_size_t_size_t._list_pair_size_t_size_t_from_capi(h_ret)

    def size(self, ):
        return _c_api.Adjacency_size(self.handle)

    def dimension(self, ):
        return _c_api.Adjacency_dimension(self.handle)

    def shape(self, size_t out_buffer, size_t ndim):
        return _c_api.Adjacency_shape(self.handle, out_buffer, ndim)

    def data(self, int out_buffer, size_t numdata):
        return _c_api.Adjacency_data(self.handle, out_buffer, numdata)

    def timesequals_farray(self, FArrayInt other):
        _c_api.Adjacency_timesequals_farray(self.handle, other.handle)

    def times_farray(self, FArrayInt other):
        cdef _c_api.AdjacencyHandle h_ret = _c_api.Adjacency_times_farray(self.handle, other.handle)
        if h_ret == <_c_api.AdjacencyHandle>0:
            return None
        return _adjacency_from_capi(h_ret)

    def equality(self, Adjacency other):
        return _c_api.Adjacency_equality(self.handle, other.handle)

    def notequality(self, Adjacency other):
        return _c_api.Adjacency_notequality(self.handle, other.handle)

    def sum(self, ):
        return _c_api.Adjacency_sum(self.handle)

    def where(self, int value):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.Adjacency_where(self.handle, value)
        if h_ret == <_c_api.ListListSizeTHandle>0:
            return None
        return list_list_size_t._list_list_size_t_from_capi(h_ret)

    def flip(self, size_t axis):
        cdef _c_api.AdjacencyHandle h_ret = _c_api.Adjacency_flip(self.handle, axis)
        if h_ret == <_c_api.AdjacencyHandle>0:
            return None
        return _adjacency_from_capi(h_ret)
