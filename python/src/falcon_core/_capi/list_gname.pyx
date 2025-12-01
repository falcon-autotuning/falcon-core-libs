cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport gname

cdef class ListGname:
    def __cinit__(self):
        self.handle = <_c_api.ListGnameHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListGnameHandle>0 and self.owned:
            _c_api.ListGname_destroy(self.handle)
        self.handle = <_c_api.ListGnameHandle>0


cdef ListGname _list_gname_from_capi(_c_api.ListGnameHandle h):
    if h == <_c_api.ListGnameHandle>0:
        return None
    cdef ListGname obj = ListGname.__new__(ListGname)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListGnameHandle h
        h = _c_api.ListGname_create_empty()
        if h == <_c_api.ListGnameHandle>0:
            raise MemoryError("Failed to create ListGname")
        cdef ListGname obj = <ListGname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, Gname data, size_t count):
        cdef _c_api.ListGnameHandle h
        h = _c_api.ListGname_create(data.handle, count)
        if h == <_c_api.ListGnameHandle>0:
            raise MemoryError("Failed to create ListGname")
        cdef ListGname obj = <ListGname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListGnameHandle h
        try:
            h = _c_api.ListGname_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListGnameHandle>0:
            raise MemoryError("Failed to create ListGname")
        cdef ListGname obj = <ListGname>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, Gname value):
        cdef _c_api.ListGnameHandle h_ret = _c_api.ListGname_fill_value(count, value.handle)
        if h_ret == <_c_api.ListGnameHandle>0:
            return None
        return _list_gname_from_capi(h_ret)

    def push_back(self, Gname value):
        _c_api.ListGname_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListGname_size(self.handle)

    def empty(self, ):
        return _c_api.ListGname_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListGname_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListGname_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.GnameHandle h_ret = _c_api.ListGname_at(self.handle, idx)
        if h_ret == <_c_api.GnameHandle>0:
            return None
        return gname._gname_from_capi(h_ret)

    def items(self, Gname out_buffer, size_t buffer_size):
        return _c_api.ListGname_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, Gname value):
        return _c_api.ListGname_contains(self.handle, value.handle)

    def index(self, Gname value):
        return _c_api.ListGname_index(self.handle, value.handle)

    def intersection(self, ListGname other):
        cdef _c_api.ListGnameHandle h_ret = _c_api.ListGname_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListGnameHandle>0:
            return None
        return _list_gname_from_capi(h_ret)

    def equal(self, ListGname b):
        return _c_api.ListGname_equal(self.handle, b.handle)

    def __eq__(self, ListGname b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListGname b):
        return _c_api.ListGname_not_equal(self.handle, b.handle)

    def __ne__(self, ListGname b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
