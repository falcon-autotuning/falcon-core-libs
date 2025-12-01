cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t

cdef class ListInt:
    def __cinit__(self):
        self.handle = <_c_api.ListIntHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListIntHandle>0 and self.owned:
            _c_api.ListInt_destroy(self.handle)
        self.handle = <_c_api.ListIntHandle>0


cdef ListInt _list_int_from_capi(_c_api.ListIntHandle h):
    if h == <_c_api.ListIntHandle>0:
        return None
    cdef ListInt obj = ListInt.__new__(ListInt)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListIntHandle h
        h = _c_api.ListInt_create_empty()
        if h == <_c_api.ListIntHandle>0:
            raise MemoryError("Failed to create ListInt")
        cdef ListInt obj = <ListInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, int data, size_t count):
        cdef _c_api.ListIntHandle h
        h = _c_api.ListInt_create(data, count)
        if h == <_c_api.ListIntHandle>0:
            raise MemoryError("Failed to create ListInt")
        cdef ListInt obj = <ListInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListIntHandle h
        try:
            h = _c_api.ListInt_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListIntHandle>0:
            raise MemoryError("Failed to create ListInt")
        cdef ListInt obj = <ListInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def allocate(size_t count):
        cdef _c_api.ListIntHandle h_ret = _c_api.ListInt_allocate(count)
        if h_ret == <_c_api.ListIntHandle>0:
            return None
        return _list_int_from_capi(h_ret)

    @staticmethod
    def fill_value(size_t count, int value):
        cdef _c_api.ListIntHandle h_ret = _c_api.ListInt_fill_value(count, value)
        if h_ret == <_c_api.ListIntHandle>0:
            return None
        return _list_int_from_capi(h_ret)

    def push_back(self, int value):
        _c_api.ListInt_push_back(self.handle, value)

    def size(self, ):
        return _c_api.ListInt_size(self.handle)

    def empty(self, ):
        return _c_api.ListInt_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListInt_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListInt_clear(self.handle)

    def at(self, size_t idx):
        return _c_api.ListInt_at(self.handle, idx)

    def items(self, int out_buffer, size_t buffer_size):
        return _c_api.ListInt_items(self.handle, out_buffer, buffer_size)

    def contains(self, int value):
        return _c_api.ListInt_contains(self.handle, value)

    def index(self, int value):
        return _c_api.ListInt_index(self.handle, value)

    def intersection(self, ListInt other):
        cdef _c_api.ListIntHandle h_ret = _c_api.ListInt_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListIntHandle>0:
            return None
        return _list_int_from_capi(h_ret)

    def equal(self, ListInt b):
        return _c_api.ListInt_equal(self.handle, b.handle)

    def __eq__(self, ListInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListInt b):
        return _c_api.ListInt_not_equal(self.handle, b.handle)

    def __ne__(self, ListInt b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
