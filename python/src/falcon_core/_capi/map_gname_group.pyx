# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .gname cimport Gname
from .group cimport Group
from .list_gname cimport ListGname
from .list_group cimport ListGroup
from .list_pair_gname_group cimport ListPairGnameGroup
from .pair_gname_group cimport PairGnameGroup

cdef class MapGnameGroup:
    cdef c_api.MapGnameGroupHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MapGnameGroupHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MapGnameGroupHandle>0 and self.owned:
            c_api.MapGnameGroup_destroy(self.handle)
        self.handle = <c_api.MapGnameGroupHandle>0

    cdef MapGnameGroup from_capi(cls, c_api.MapGnameGroupHandle h):
        cdef MapGnameGroup obj = <MapGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.MapGnameGroupHandle h
        h = c_api.MapGnameGroup_create_empty()
        if h == <c_api.MapGnameGroupHandle>0:
            raise MemoryError("Failed to create MapGnameGroup")
        cdef MapGnameGroup obj = <MapGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data, count):
        cdef c_api.MapGnameGroupHandle h
        h = c_api.MapGnameGroup_create(<c_api.PairGnameGroupHandle>data.handle, count)
        if h == <c_api.MapGnameGroupHandle>0:
            raise MemoryError("Failed to create MapGnameGroup")
        cdef MapGnameGroup obj = <MapGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MapGnameGroupHandle h
        try:
            h = c_api.MapGnameGroup_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MapGnameGroupHandle>0:
            raise MemoryError("Failed to create MapGnameGroup")
        cdef MapGnameGroup obj = <MapGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapGnameGroup_insert_or_assign(self.handle, <c_api.GnameHandle>key.handle, <c_api.GroupHandle>value.handle)

    def insert(self, key, value):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapGnameGroup_insert(self.handle, <c_api.GnameHandle>key.handle, <c_api.GroupHandle>value.handle)

    def at(self, key):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.GroupHandle h_ret
        h_ret = c_api.MapGnameGroup_at(self.handle, <c_api.GnameHandle>key.handle)
        if h_ret == <c_api.GroupHandle>0:
            return None
        return Group.from_capi(Group, h_ret)

    def erase(self, key):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapGnameGroup_erase(self.handle, <c_api.GnameHandle>key.handle)

    def size(self):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapGnameGroup_size(self.handle)

    def empty(self):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapGnameGroup_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MapGnameGroup_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapGnameGroup_contains(self.handle, <c_api.GnameHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListGnameHandle h_ret
        h_ret = c_api.MapGnameGroup_keys(self.handle)
        if h_ret == <c_api.ListGnameHandle>0:
            return None
        return ListGname.from_capi(ListGname, h_ret)

    def values(self):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListGroupHandle h_ret
        h_ret = c_api.MapGnameGroup_values(self.handle)
        if h_ret == <c_api.ListGroupHandle>0:
            return None
        return ListGroup.from_capi(ListGroup, h_ret)

    def items(self):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairGnameGroupHandle h_ret
        h_ret = c_api.MapGnameGroup_items(self.handle)
        if h_ret == <c_api.ListPairGnameGroupHandle>0:
            return None
        return ListPairGnameGroup.from_capi(ListPairGnameGroup, h_ret)

    def equal(self, b):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapGnameGroup_equal(self.handle, <c_api.MapGnameGroupHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MapGnameGroup_not_equal(self.handle, <c_api.MapGnameGroupHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MapGnameGroupHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MapGnameGroup_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MapGnameGroup _mapgnamegroup_from_capi(c_api.MapGnameGroupHandle h):
    cdef MapGnameGroup obj = <MapGnameGroup>MapGnameGroup.__new__(MapGnameGroup)
    obj.handle = h