cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection

cdef class ListConnection:
    def __cinit__(self):
        self.handle = <_c_api.ListConnectionHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListConnectionHandle>0 and self.owned:
            _c_api.ListConnection_destroy(self.handle)
        self.handle = <_c_api.ListConnectionHandle>0


cdef ListConnection _list_connection_from_capi(_c_api.ListConnectionHandle h):
    if h == <_c_api.ListConnectionHandle>0:
        return None
    cdef ListConnection obj = ListConnection.__new__(ListConnection)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.ListConnectionHandle h
        h = _c_api.ListConnection_create_empty()
        if h == <_c_api.ListConnectionHandle>0:
            raise MemoryError("Failed to create ListConnection")
        cdef ListConnection obj = <ListConnection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, Connection data, size_t count):
        cdef _c_api.ListConnectionHandle h
        h = _c_api.ListConnection_create(data.handle, count)
        if h == <_c_api.ListConnectionHandle>0:
            raise MemoryError("Failed to create ListConnection")
        cdef ListConnection obj = <ListConnection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListConnectionHandle h
        try:
            h = _c_api.ListConnection_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListConnectionHandle>0:
            raise MemoryError("Failed to create ListConnection")
        cdef ListConnection obj = <ListConnection>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, Connection value):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.ListConnection_fill_value(count, value.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret)

    def push_back(self, Connection value):
        _c_api.ListConnection_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListConnection_size(self.handle)

    def empty(self, ):
        return _c_api.ListConnection_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListConnection_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListConnection_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ConnectionHandle h_ret = _c_api.ListConnection_at(self.handle, idx)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def items(self, Connection out_buffer, size_t buffer_size):
        return _c_api.ListConnection_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, Connection value):
        return _c_api.ListConnection_contains(self.handle, value.handle)

    def index(self, Connection value):
        return _c_api.ListConnection_index(self.handle, value.handle)

    def intersection(self, ListConnection other):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.ListConnection_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret)

    def equal(self, ListConnection b):
        return _c_api.ListConnection_equal(self.handle, b.handle)

    def __eq__(self, ListConnection b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListConnection b):
        return _c_api.ListConnection_not_equal(self.handle, b.handle)

    def __ne__(self, ListConnection b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
