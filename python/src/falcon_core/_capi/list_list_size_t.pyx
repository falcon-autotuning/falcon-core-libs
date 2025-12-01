cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_size_t

cdef class ListListSizeT:
    def __cinit__(self):
        self.handle = <_c_api.ListListSizeTHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListListSizeTHandle>0 and self.owned:
            _c_api.ListListSizeT_destroy(self.handle)
        self.handle = <_c_api.ListListSizeTHandle>0


cdef ListListSizeT _list_list_size_t_from_capi(_c_api.ListListSizeTHandle h):
    if h == <_c_api.ListListSizeTHandle>0:
        return None
    cdef ListListSizeT obj = ListListSizeT.__new__(ListListSizeT)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListListSizeTHandle h
        h = _c_api.ListListSizeT_create_empty()
        if h == <_c_api.ListListSizeTHandle>0:
            raise MemoryError("Failed to create ListListSizeT")
        cdef ListListSizeT obj = <ListListSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, ListSizeT data, size_t count):
        cdef _c_api.ListListSizeTHandle h
        h = _c_api.ListListSizeT_create(data.handle, count)
        if h == <_c_api.ListListSizeTHandle>0:
            raise MemoryError("Failed to create ListListSizeT")
        cdef ListListSizeT obj = <ListListSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListListSizeTHandle h
        try:
            h = _c_api.ListListSizeT_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListListSizeTHandle>0:
            raise MemoryError("Failed to create ListListSizeT")
        cdef ListListSizeT obj = <ListListSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, ListSizeT value):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.ListListSizeT_fill_value(count, value.handle)
        if h_ret == <_c_api.ListListSizeTHandle>0:
            return None
        return _list_list_size_t_from_capi(h_ret)

    def push_back(self, ListSizeT value):
        _c_api.ListListSizeT_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListListSizeT_size(self.handle)

    def empty(self, ):
        return _c_api.ListListSizeT_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListListSizeT_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListListSizeT_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ListSizeTHandle h_ret = _c_api.ListListSizeT_at(self.handle, idx)
        if h_ret == <_c_api.ListSizeTHandle>0:
            return None
        return list_size_t._list_size_t_from_capi(h_ret)

    def items(self, ListSizeT out_buffer, size_t buffer_size):
        return _c_api.ListListSizeT_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, ListSizeT value):
        return _c_api.ListListSizeT_contains(self.handle, value.handle)

    def index(self, ListSizeT value):
        return _c_api.ListListSizeT_index(self.handle, value.handle)

    def intersection(self, ListListSizeT other):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.ListListSizeT_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListListSizeTHandle>0:
            return None
        return _list_list_size_t_from_capi(h_ret)

    def equal(self, ListListSizeT b):
        return _c_api.ListListSizeT_equal(self.handle, b.handle)

    def __eq__(self, ListListSizeT b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListListSizeT b):
        return _c_api.ListListSizeT_not_equal(self.handle, b.handle)

    def __ne__(self, ListListSizeT b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
