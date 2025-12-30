cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .gname cimport Gname, _gname_from_capi
from .group cimport Group, _group_from_capi
from .list_gname cimport ListGname, _list_gname_from_capi
from .list_group cimport ListGroup, _list_group_from_capi
from .list_pair_gname_group cimport ListPairGnameGroup, _list_pair_gname_group_from_capi
from .pair_gname_group cimport PairGnameGroup, _pair_gname_group_from_capi

cdef class MapGnameGroup:
    def __cinit__(self):
        self.handle = <_c_api.MapGnameGroupHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MapGnameGroupHandle>0 and self.owned:
            _c_api.MapGnameGroup_destroy(self.handle)
        self.handle = <_c_api.MapGnameGroupHandle>0


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
    def new(cls, size_t[:] data, size_t count):
        cdef _c_api.MapGnameGroupHandle h
        h = _c_api.MapGnameGroup_create(<_c_api.PairGnameGroupHandle*>&data[0], count)
        if h == <_c_api.MapGnameGroupHandle>0:
            raise MemoryError("Failed to create MapGnameGroup")
        cdef MapGnameGroup obj = <MapGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def copy(self, ):
        cdef _c_api.MapGnameGroupHandle h_ret = _c_api.MapGnameGroup_copy(self.handle)
        if h_ret == <_c_api.MapGnameGroupHandle>0:
            return None
        return _map_gname_group_from_capi(h_ret, owned=(h_ret != <_c_api.MapGnameGroupHandle>self.handle))

    def insert_or_assign(self, Gname key, Group value):
        _c_api.MapGnameGroup_insert_or_assign(self.handle, key.handle if key is not None else <_c_api.GnameHandle>0, value.handle if value is not None else <_c_api.GroupHandle>0)

    def insert(self, Gname key, Group value):
        _c_api.MapGnameGroup_insert(self.handle, key.handle if key is not None else <_c_api.GnameHandle>0, value.handle if value is not None else <_c_api.GroupHandle>0)

    def at(self, Gname key):
        cdef _c_api.GroupHandle h_ret = _c_api.MapGnameGroup_at(self.handle, key.handle if key is not None else <_c_api.GnameHandle>0)
        if h_ret == <_c_api.GroupHandle>0:
            return None
        return _group_from_capi(h_ret, owned=False)

    def erase(self, Gname key):
        _c_api.MapGnameGroup_erase(self.handle, key.handle if key is not None else <_c_api.GnameHandle>0)

    def size(self, ):
        return _c_api.MapGnameGroup_size(self.handle)

    def empty(self, ):
        return _c_api.MapGnameGroup_empty(self.handle)

    def clear(self, ):
        _c_api.MapGnameGroup_clear(self.handle)

    def contains(self, Gname key):
        return _c_api.MapGnameGroup_contains(self.handle, key.handle if key is not None else <_c_api.GnameHandle>0)

    def keys(self, ):
        cdef _c_api.ListGnameHandle h_ret = _c_api.MapGnameGroup_keys(self.handle)
        if h_ret == <_c_api.ListGnameHandle>0:
            return None
        return _list_gname_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListGroupHandle h_ret = _c_api.MapGnameGroup_values(self.handle)
        if h_ret == <_c_api.ListGroupHandle>0:
            return None
        return _list_group_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairGnameGroupHandle h_ret = _c_api.MapGnameGroup_items(self.handle)
        if h_ret == <_c_api.ListPairGnameGroupHandle>0:
            return None
        return _list_pair_gname_group_from_capi(h_ret)

    def equal(self, MapGnameGroup other):
        return _c_api.MapGnameGroup_equal(self.handle, other.handle if other is not None else <_c_api.MapGnameGroupHandle>0)

    def __eq__(self, MapGnameGroup other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, MapGnameGroup other):
        return _c_api.MapGnameGroup_not_equal(self.handle, other.handle if other is not None else <_c_api.MapGnameGroupHandle>0)

    def __ne__(self, MapGnameGroup other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.MapGnameGroup_to_json_string(self.handle)
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

cdef MapGnameGroup _map_gname_group_from_capi(_c_api.MapGnameGroupHandle h, bint owned=True):
    if h == <_c_api.MapGnameGroupHandle>0:
        return None
    cdef MapGnameGroup obj = MapGnameGroup.__new__(MapGnameGroup)
    obj.handle = h
    obj.owned = owned
    return obj
