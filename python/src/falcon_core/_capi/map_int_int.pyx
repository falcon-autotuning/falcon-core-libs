cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .list_int cimport ListInt, _list_int_from_capi
from .list_pair_int_int cimport ListPairIntInt, _list_pair_int_int_from_capi
from .pair_int_int cimport PairIntInt, _pair_int_int_from_capi

cdef class MapIntInt:
    def __cinit__(self):
        self.handle = <_c_api.MapIntIntHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapIntIntHandle>0 and self.owned:
            _c_api.MapIntInt_destroy(self.handle)
        self.handle = <_c_api.MapIntIntHandle>0


    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapIntIntHandle h
        h = _c_api.MapIntInt_create_empty()
        if h == <_c_api.MapIntIntHandle>0:
            raise MemoryError("Failed to create MapIntInt")
        cdef MapIntInt obj = <MapIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.MapIntIntHandle h
        h = _c_api.MapIntInt_create(<_c_api.PairIntIntHandle*>&data[0], count)
        if h == <_c_api.MapIntIntHandle>0:
            raise MemoryError("Failed to create MapIntInt")
        cdef MapIntInt obj = <MapIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapIntIntHandle h
        try:
            h = _c_api.MapIntInt_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapIntIntHandle>0:
            raise MemoryError("Failed to create MapIntInt")
        cdef MapIntInt obj = <MapIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.MapIntIntHandle h_ret = _c_api.MapIntInt_copy(self.handle)
        if h_ret == <_c_api.MapIntIntHandle>0:
            return None
        return _map_int_int_from_capi(h_ret, owned=(h_ret != <_c_api.MapIntIntHandle>self.handle))

    def insert_or_assign(self, int key, int value):
        _c_api.MapIntInt_insert_or_assign(self.handle, key, value)

    def insert(self, int key, int value):
        _c_api.MapIntInt_insert(self.handle, key, value)

    def at(self, int key):
        return _c_api.MapIntInt_at(self.handle, key)

    def erase(self, int key):
        _c_api.MapIntInt_erase(self.handle, key)

    def size(self, ):
        return _c_api.MapIntInt_size(self.handle)

    def empty(self, ):
        return _c_api.MapIntInt_empty(self.handle)

    def clear(self, ):
        _c_api.MapIntInt_clear(self.handle)

    def contains(self, int key):
        return _c_api.MapIntInt_contains(self.handle, key)

    def keys(self, ):
        cdef _c_api.ListIntHandle h_ret = _c_api.MapIntInt_keys(self.handle)
        if h_ret == <_c_api.ListIntHandle>0:
            return None
        return _list_int_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListIntHandle h_ret = _c_api.MapIntInt_values(self.handle)
        if h_ret == <_c_api.ListIntHandle>0:
            return None
        return _list_int_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairIntIntHandle h_ret = _c_api.MapIntInt_items(self.handle)
        if h_ret == <_c_api.ListPairIntIntHandle>0:
            return None
        return _list_pair_int_int_from_capi(h_ret)

    def equal(self, MapIntInt other):
        return _c_api.MapIntInt_equal(self.handle, other.handle if other is not None else <_c_api.MapIntIntHandle>0)

    def __eq__(self, MapIntInt other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, MapIntInt other):
        return _c_api.MapIntInt_not_equal(self.handle, other.handle if other is not None else <_c_api.MapIntIntHandle>0)

    def __ne__(self, MapIntInt other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.MapIntInt_to_json_string(self.handle)
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

cdef MapIntInt _map_int_int_from_capi(_c_api.MapIntIntHandle h, bint owned=True):
    if h == <_c_api.MapIntIntHandle>0:
        return None
    cdef MapIntInt obj = MapIntInt.__new__(MapIntInt)
    obj.handle = h
    obj.owned = owned
    return obj
