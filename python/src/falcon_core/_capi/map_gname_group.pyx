cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport gname
from . cimport group
from . cimport list_gname
from . cimport list_group
from . cimport list_pair_gname_group
from . cimport pair_gname_group

cdef class MapGnameGroup:
    def __cinit__(self):
        self.handle = <_c_api.MapGnameGroupHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapGnameGroupHandle>0 and self.owned:
            _c_api.MapGnameGroup_destroy(self.handle)
        self.handle = <_c_api.MapGnameGroupHandle>0


cdef MapGnameGroup _map_gname_group_from_capi(_c_api.MapGnameGroupHandle h):
    if h == <_c_api.MapGnameGroupHandle>0:
        return None
    cdef MapGnameGroup obj = MapGnameGroup.__new__(MapGnameGroup)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.MapGnameGroupHandle h
        h = _c_api.MapGnameGroup_create_empty()
        if h == <_c_api.MapGnameGroupHandle>0:
            raise MemoryError("Failed to create MapGnameGroup")
        cdef MapGnameGroup obj = <MapGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, PairGnameGroup data, size_t count):
        cdef _c_api.MapGnameGroupHandle h
        h = _c_api.MapGnameGroup_create(data.handle, count)
        if h == <_c_api.MapGnameGroupHandle>0:
            raise MemoryError("Failed to create MapGnameGroup")
        cdef MapGnameGroup obj = <MapGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MapGnameGroupHandle h
        try:
            h = _c_api.MapGnameGroup_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MapGnameGroupHandle>0:
            raise MemoryError("Failed to create MapGnameGroup")
        cdef MapGnameGroup obj = <MapGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, Gname key, Group value):
        _c_api.MapGnameGroup_insert_or_assign(self.handle, key.handle, value.handle)

    def insert(self, Gname key, Group value):
        _c_api.MapGnameGroup_insert(self.handle, key.handle, value.handle)

    def at(self, Gname key):
        cdef _c_api.GroupHandle h_ret = _c_api.MapGnameGroup_at(self.handle, key.handle)
        if h_ret == <_c_api.GroupHandle>0:
            return None
        return group._group_from_capi(h_ret)

    def erase(self, Gname key):
        _c_api.MapGnameGroup_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.MapGnameGroup_size(self.handle)

    def empty(self, ):
        return _c_api.MapGnameGroup_empty(self.handle)

    def clear(self, ):
        _c_api.MapGnameGroup_clear(self.handle)

    def contains(self, Gname key):
        return _c_api.MapGnameGroup_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListGnameHandle h_ret = _c_api.MapGnameGroup_keys(self.handle)
        if h_ret == <_c_api.ListGnameHandle>0:
            return None
        return list_gname._list_gname_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListGroupHandle h_ret = _c_api.MapGnameGroup_values(self.handle)
        if h_ret == <_c_api.ListGroupHandle>0:
            return None
        return list_group._list_group_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairGnameGroupHandle h_ret = _c_api.MapGnameGroup_items(self.handle)
        if h_ret == <_c_api.ListPairGnameGroupHandle>0:
            return None
        return list_pair_gname_group._list_pair_gname_group_from_capi(h_ret)

    def equal(self, MapGnameGroup b):
        return _c_api.MapGnameGroup_equal(self.handle, b.handle)

    def __eq__(self, MapGnameGroup b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MapGnameGroup b):
        return _c_api.MapGnameGroup_not_equal(self.handle, b.handle)

    def __ne__(self, MapGnameGroup b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
