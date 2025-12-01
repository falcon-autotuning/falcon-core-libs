cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport pair_gname_group

cdef class ListPairGnameGroup:
    def __cinit__(self):
        self.handle = <_c_api.ListPairGnameGroupHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListPairGnameGroupHandle>0 and self.owned:
            _c_api.ListPairGnameGroup_destroy(self.handle)
        self.handle = <_c_api.ListPairGnameGroupHandle>0


cdef ListPairGnameGroup _list_pair_gname_group_from_capi(_c_api.ListPairGnameGroupHandle h):
    if h == <_c_api.ListPairGnameGroupHandle>0:
        return None
    cdef ListPairGnameGroup obj = ListPairGnameGroup.__new__(ListPairGnameGroup)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListPairGnameGroupHandle h
        h = _c_api.ListPairGnameGroup_create_empty()
        if h == <_c_api.ListPairGnameGroupHandle>0:
            raise MemoryError("Failed to create ListPairGnameGroup")
        cdef ListPairGnameGroup obj = <ListPairGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, PairGnameGroup data, size_t count):
        cdef _c_api.ListPairGnameGroupHandle h
        h = _c_api.ListPairGnameGroup_create(data.handle, count)
        if h == <_c_api.ListPairGnameGroupHandle>0:
            raise MemoryError("Failed to create ListPairGnameGroup")
        cdef ListPairGnameGroup obj = <ListPairGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListPairGnameGroupHandle h
        try:
            h = _c_api.ListPairGnameGroup_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListPairGnameGroupHandle>0:
            raise MemoryError("Failed to create ListPairGnameGroup")
        cdef ListPairGnameGroup obj = <ListPairGnameGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, PairGnameGroup value):
        cdef _c_api.ListPairGnameGroupHandle h_ret = _c_api.ListPairGnameGroup_fill_value(count, value.handle)
        if h_ret == <_c_api.ListPairGnameGroupHandle>0:
            return None
        return _list_pair_gname_group_from_capi(h_ret)

    def push_back(self, PairGnameGroup value):
        _c_api.ListPairGnameGroup_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListPairGnameGroup_size(self.handle)

    def empty(self, ):
        return _c_api.ListPairGnameGroup_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListPairGnameGroup_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListPairGnameGroup_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.PairGnameGroupHandle h_ret = _c_api.ListPairGnameGroup_at(self.handle, idx)
        if h_ret == <_c_api.PairGnameGroupHandle>0:
            return None
        return pair_gname_group._pair_gname_group_from_capi(h_ret)

    def items(self, PairGnameGroup out_buffer, size_t buffer_size):
        return _c_api.ListPairGnameGroup_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, PairGnameGroup value):
        return _c_api.ListPairGnameGroup_contains(self.handle, value.handle)

    def index(self, PairGnameGroup value):
        return _c_api.ListPairGnameGroup_index(self.handle, value.handle)

    def intersection(self, ListPairGnameGroup other):
        cdef _c_api.ListPairGnameGroupHandle h_ret = _c_api.ListPairGnameGroup_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListPairGnameGroupHandle>0:
            return None
        return _list_pair_gname_group_from_capi(h_ret)

    def equal(self, ListPairGnameGroup b):
        return _c_api.ListPairGnameGroup_equal(self.handle, b.handle)

    def __eq__(self, ListPairGnameGroup b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListPairGnameGroup b):
        return _c_api.ListPairGnameGroup_not_equal(self.handle, b.handle)

    def __ne__(self, ListPairGnameGroup b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
