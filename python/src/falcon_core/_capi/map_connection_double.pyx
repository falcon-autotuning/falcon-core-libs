cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .list_connection cimport ListConnection, _list_connection_from_capi
from .list_double cimport ListDouble, _list_double_from_capi
from .list_pair_connection_double cimport ListPairConnectionDouble, _list_pair_connection_double_from_capi
from .pair_connection_double cimport PairConnectionDouble, _pair_connection_double_from_capi

cdef class MapConnectionDouble:
    def __cinit__(self):
        self.handle = <_c_api.MapConnectionDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapConnectionDoubleHandle>0 and self.owned:
            _c_api.MapConnectionDouble_destroy(self.handle)
        self.handle = <_c_api.MapConnectionDoubleHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapConnectionDoubleHandle h
        h = _c_api.MapConnectionDouble_create_empty()
        if h == <_c_api.MapConnectionDoubleHandle>0:
            raise MemoryError("Failed to create MapConnectionDouble")
        cdef MapConnectionDouble obj = <MapConnectionDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.MapConnectionDoubleHandle h
        h = _c_api.MapConnectionDouble_create(<_c_api.PairConnectionDoubleHandle*>&data[0], count)
        if h == <_c_api.MapConnectionDoubleHandle>0:
            raise MemoryError("Failed to create MapConnectionDouble")
        cdef MapConnectionDouble obj = <MapConnectionDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapConnectionDoubleHandle h
        try:
            h = _c_api.MapConnectionDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapConnectionDoubleHandle>0:
            raise MemoryError("Failed to create MapConnectionDouble")
        cdef MapConnectionDouble obj = <MapConnectionDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.MapConnectionDoubleHandle h_ret = _c_api.MapConnectionDouble_copy(self.handle)
        if h_ret == <_c_api.MapConnectionDoubleHandle>0:
            return None
        return _map_connection_double_from_capi(h_ret, owned=(h_ret != <_c_api.MapConnectionDoubleHandle>self.handle))

    def insert_or_assign(self, Connection key, double value):
        _c_api.MapConnectionDouble_insert_or_assign(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0, value)

    def insert(self, Connection key, double value):
        _c_api.MapConnectionDouble_insert(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0, value)

    def at(self, Connection key):
        return _c_api.MapConnectionDouble_at(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)

    def erase(self, Connection key):
        _c_api.MapConnectionDouble_erase(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)

    def size(self, ):
        return _c_api.MapConnectionDouble_size(self.handle)

    def empty(self, ):
        return _c_api.MapConnectionDouble_empty(self.handle)

    def clear(self, ):
        _c_api.MapConnectionDouble_clear(self.handle)

    def contains(self, Connection key):
        return _c_api.MapConnectionDouble_contains(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)

    def keys(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.MapConnectionDouble_keys(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListDoubleHandle h_ret = _c_api.MapConnectionDouble_values(self.handle)
        if h_ret == <_c_api.ListDoubleHandle>0:
            return None
        return _list_double_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairConnectionDoubleHandle h_ret = _c_api.MapConnectionDouble_items(self.handle)
        if h_ret == <_c_api.ListPairConnectionDoubleHandle>0:
            return None
        return _list_pair_connection_double_from_capi(h_ret)

    def equal(self, MapConnectionDouble other):
        return _c_api.MapConnectionDouble_equal(self.handle, other.handle if other is not None else <_c_api.MapConnectionDoubleHandle>0)

    def __eq__(self, MapConnectionDouble other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, MapConnectionDouble other):
        return _c_api.MapConnectionDouble_not_equal(self.handle, other.handle if other is not None else <_c_api.MapConnectionDoubleHandle>0)

    def __ne__(self, MapConnectionDouble other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.MapConnectionDouble_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

cdef MapConnectionDouble _map_connection_double_from_capi(_c_api.MapConnectionDoubleHandle h, bint owned=True):
    if h == <_c_api.MapConnectionDoubleHandle>0:
        return None
    cdef MapConnectionDouble obj = MapConnectionDouble.__new__(MapConnectionDouble)
    obj.handle = h
    obj.owned = owned
    return obj
