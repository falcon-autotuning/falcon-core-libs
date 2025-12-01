cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport group

cdef class ListGroup:
    def __cinit__(self):
        self.handle = <_c_api.ListGroupHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListGroupHandle>0 and self.owned:
            _c_api.ListGroup_destroy(self.handle)
        self.handle = <_c_api.ListGroupHandle>0


cdef ListGroup _list_group_from_capi(_c_api.ListGroupHandle h):
    if h == <_c_api.ListGroupHandle>0:
        return None
    cdef ListGroup obj = ListGroup.__new__(ListGroup)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListGroupHandle h
        h = _c_api.ListGroup_create_empty()
        if h == <_c_api.ListGroupHandle>0:
            raise MemoryError("Failed to create ListGroup")
        cdef ListGroup obj = <ListGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, Group data, size_t count):
        cdef _c_api.ListGroupHandle h
        h = _c_api.ListGroup_create(data.handle, count)
        if h == <_c_api.ListGroupHandle>0:
            raise MemoryError("Failed to create ListGroup")
        cdef ListGroup obj = <ListGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListGroupHandle h
        try:
            h = _c_api.ListGroup_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListGroupHandle>0:
            raise MemoryError("Failed to create ListGroup")
        cdef ListGroup obj = <ListGroup>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, Group value):
        cdef _c_api.ListGroupHandle h_ret = _c_api.ListGroup_fill_value(count, value.handle)
        if h_ret == <_c_api.ListGroupHandle>0:
            return None
        return _list_group_from_capi(h_ret)

    def push_back(self, Group value):
        _c_api.ListGroup_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListGroup_size(self.handle)

    def empty(self, ):
        return _c_api.ListGroup_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListGroup_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListGroup_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.GroupHandle h_ret = _c_api.ListGroup_at(self.handle, idx)
        if h_ret == <_c_api.GroupHandle>0:
            return None
        return group._group_from_capi(h_ret)

    def items(self, Group out_buffer, size_t buffer_size):
        return _c_api.ListGroup_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, Group value):
        return _c_api.ListGroup_contains(self.handle, value.handle)

    def index(self, Group value):
        return _c_api.ListGroup_index(self.handle, value.handle)

    def intersection(self, ListGroup other):
        cdef _c_api.ListGroupHandle h_ret = _c_api.ListGroup_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListGroupHandle>0:
            return None
        return _list_group_from_capi(h_ret)

    def equal(self, ListGroup b):
        return _c_api.ListGroup_equal(self.handle, b.handle)

    def __eq__(self, ListGroup b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListGroup b):
        return _c_api.ListGroup_not_equal(self.handle, b.handle)

    def __ne__(self, ListGroup b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
