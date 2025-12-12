cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_int
from . cimport list_pair_int_int
from . cimport pair_int_int

cdef class MapIntInt:
    def __cinit__(self):
        self.handle = <_c_api.MapIntIntHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapIntIntHandle>0 and self.owned:
            _c_api.MapIntInt_destroy(self.handle)
        self.handle = <_c_api.MapIntIntHandle>0


cdef MapIntInt _map_int_int_from_capi(_c_api.MapIntIntHandle h):
    if h == <_c_api.MapIntIntHandle>0:
        return None
    cdef MapIntInt obj = MapIntInt.__new__(MapIntInt)
    obj.handle = h
    obj.owned = True
    return obj

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
    def new(cls, PairIntInt data, size_t count):
        cdef _c_api.MapIntIntHandle h
        h = _c_api.MapIntInt_create(data.handle, count)
        if h == <_c_api.MapIntIntHandle>0:
            raise MemoryError("Failed to create MapIntInt")
        cdef MapIntInt obj = <MapIntInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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
        return list_int._list_int_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListIntHandle h_ret = _c_api.MapIntInt_values(self.handle)
        if h_ret == <_c_api.ListIntHandle>0:
            return None
        return list_int._list_int_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairIntIntHandle h_ret = _c_api.MapIntInt_items(self.handle)
        if h_ret == <_c_api.ListPairIntIntHandle>0:
            return None
        return list_pair_int_int._list_pair_int_int_from_capi(h_ret)

    def equal(self, MapIntInt b):
        return _c_api.MapIntInt_equal(self.handle, b.handle)

    def __eq__(self, MapIntInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapIntInt b):
        return _c_api.MapIntInt_not_equal(self.handle, b.handle)

    def __ne__(self, MapIntInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
