cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connections cimport Connections, _connections_from_capi
from .f_array_int cimport FArrayInt, _f_array_int_from_capi
from .list_list_size_t cimport ListListSizeT, _list_list_size_t_from_capi
from .list_pair_size_t_size_t cimport ListPairSizeTSizeT, _list_pair_size_t_size_t_from_capi

cdef class Adjacency:
    def __cinit__(self):
        self.handle = <_c_api.AdjacencyHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AdjacencyHandle>0 and self.owned:
            _c_api.Adjacency_destroy(self.handle)
        self.handle = <_c_api.AdjacencyHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    @classmethod
    def new(cls, int[:] data, size_t[:] shape, size_t ndim, Connections indexes):
        cdef _c_api.AdjacencyHandle h
        h = _c_api.Adjacency_create(&data[0], &shape[0], ndim, indexes.handle if indexes is not None else <_c_api.ConnectionsHandle>0)
        if h == <_c_api.AdjacencyHandle>0:
            raise MemoryError("Failed to create Adjacency")
        cdef Adjacency obj = <Adjacency>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self):
        cdef _c_api.AdjacencyHandle h_ret = _c_api.Adjacency_copy(self.handle)
        if h_ret == <_c_api.AdjacencyHandle>0: return None
        return _adjacency_from_capi(h_ret, owned=(h_ret != <_c_api.AdjacencyHandle>self.handle))

    def equal(self, Adjacency other):
        return _c_api.Adjacency_equal(self.handle, other.handle if other is not None else <_c_api.AdjacencyHandle>0)

    def __eq__(self, Adjacency other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.equal(other)

    def not_equal(self, Adjacency other):
        return _c_api.Adjacency_not_equal(self.handle, other.handle if other is not None else <_c_api.AdjacencyHandle>0)

    def __ne__(self, Adjacency other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.not_equal(other)

    def to_json(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Adjacency_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def indexes(self):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Adjacency_indexes(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0: return None
        return _connections_from_capi(h_ret, owned=True)

    def indexes(self):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.Adjacency_indexes(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0: return None
        return _connections_from_capi(h_ret, owned=True)

    def get_true_pairs(self):
        cdef _c_api.ListPairSizeTSizeTHandle h_ret = _c_api.Adjacency_get_true_pairs(self.handle)
        if h_ret == <_c_api.ListPairSizeTSizeTHandle>0: return None
        return _list_pair_size_t_size_t_from_capi(h_ret, owned=False)

    def size(self):
        return _c_api.Adjacency_size(self.handle)

    def dimension(self):
        return _c_api.Adjacency_dimension(self.handle)

    def shape(self, size_t[:] out_buffer, size_t ndim):
        return _c_api.Adjacency_shape(self.handle, &out_buffer[0], ndim)

    def data(self, int[:] out_buffer, size_t numdata):
        return _c_api.Adjacency_data(self.handle, &out_buffer[0], numdata)

    def times_equals_farray(self, FArrayInt other):
        _c_api.Adjacency_times_equals_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)

    def times_farray(self, FArrayInt other):
        cdef _c_api.AdjacencyHandle h_ret = _c_api.Adjacency_times_farray(self.handle, other.handle if other is not None else <_c_api.FArrayIntHandle>0)
        if h_ret == <_c_api.AdjacencyHandle>0: return None
        return _adjacency_from_capi(h_ret, owned=(h_ret != <_c_api.AdjacencyHandle>self.handle))

    def sum(self):
        return _c_api.Adjacency_sum(self.handle)

    def where(self, int value):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.Adjacency_where(self.handle, value)
        if h_ret == <_c_api.ListListSizeTHandle>0: return None
        return _list_list_size_t_from_capi(h_ret, owned=True)

    def flip(self, size_t axis):
        cdef _c_api.AdjacencyHandle h_ret = _c_api.Adjacency_flip(self.handle, axis)
        if h_ret == <_c_api.AdjacencyHandle>0: return None
        return _adjacency_from_capi(h_ret, owned=(h_ret != <_c_api.AdjacencyHandle>self.handle))

    def __len__(self):
        return self.size

    def __repr__(self):
        return f"{self.__class__.__name__}({self.to_json()})"

    def __str__(self):
        return self.to_json()

cdef Adjacency _adjacency_from_capi(_c_api.AdjacencyHandle h, bint owned=True):
    if h == <_c_api.AdjacencyHandle>0:
        return None
    cdef Adjacency obj = Adjacency.__new__(Adjacency)
    obj.handle = h
    obj.owned = owned
    return obj
