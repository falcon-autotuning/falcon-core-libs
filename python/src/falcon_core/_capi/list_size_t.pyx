cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class ListSizeT:
    def __cinit__(self):
        self.handle = <_c_api.ListSizeTHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListSizeTHandle>0 and self.owned:
            _c_api.ListSizeT_destroy(self.handle)
        self.handle = <_c_api.ListSizeTHandle>0


cdef ListSizeT _list_size_t_from_capi(_c_api.ListSizeTHandle h):
    if h == <_c_api.ListSizeTHandle>0:
        return None
    cdef ListSizeT obj = ListSizeT.__new__(ListSizeT)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListSizeTHandle h
        h = _c_api.ListSizeT_create_empty()
        if h == <_c_api.ListSizeTHandle>0:
            raise MemoryError("Failed to create ListSizeT")
        cdef ListSizeT obj = <ListSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, size_t data, size_t count):
        cdef _c_api.ListSizeTHandle h
        h = _c_api.ListSizeT_create(data, count)
        if h == <_c_api.ListSizeTHandle>0:
            raise MemoryError("Failed to create ListSizeT")
        cdef ListSizeT obj = <ListSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListSizeTHandle h
        try:
            h = _c_api.ListSizeT_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListSizeTHandle>0:
            raise MemoryError("Failed to create ListSizeT")
        cdef ListSizeT obj = <ListSizeT>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def allocate(size_t count):
        cdef _c_api.ListSizeTHandle h_ret = _c_api.ListSizeT_allocate(count)
        if h_ret == <_c_api.ListSizeTHandle>0:
            return None
        return _list_size_t_from_capi(h_ret)

    @staticmethod
    def fill_value(size_t count, size_t value):
        cdef _c_api.ListSizeTHandle h_ret = _c_api.ListSizeT_fill_value(count, value)
        if h_ret == <_c_api.ListSizeTHandle>0:
            return None
        return _list_size_t_from_capi(h_ret)

    def push_back(self, size_t value):
        _c_api.ListSizeT_push_back(self.handle, value)

    def size(self, ):
        return _c_api.ListSizeT_size(self.handle)

    def empty(self, ):
        return _c_api.ListSizeT_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListSizeT_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListSizeT_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.ListSizeT_at(self.handle, idx)

    def items(self, size_t out_buffer, size_t buffer_size):
        return _c_api.ListSizeT_items(self.handle, out_buffer, buffer_size)

    def contains(self, size_t value):
        return _c_api.ListSizeT_contains(self.handle, value)

    def index(self, size_t value):
        return _c_api.ListSizeT_index(self.handle, value)

    def intersection(self, ListSizeT other):
        cdef _c_api.ListSizeTHandle h_ret = _c_api.ListSizeT_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListSizeTHandle>0:
            return None
        return _list_size_t_from_capi(h_ret)

    def equal(self, ListSizeT b):
        return _c_api.ListSizeT_equal(self.handle, b.handle)

    def __eq__(self, ListSizeT b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListSizeT b):
        return _c_api.ListSizeT_not_equal(self.handle, b.handle)

    def __ne__(self, ListSizeT b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
