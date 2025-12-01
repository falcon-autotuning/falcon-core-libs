cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport map_string_bool

cdef class ListMapStringBool:
    def __cinit__(self):
        self.handle = <_c_api.ListMapStringBoolHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListMapStringBoolHandle>0 and self.owned:
            _c_api.ListMapStringBool_destroy(self.handle)
        self.handle = <_c_api.ListMapStringBoolHandle>0


cdef ListMapStringBool _list_map_string_bool_from_capi(_c_api.ListMapStringBoolHandle h):
    if h == <_c_api.ListMapStringBoolHandle>0:
        return None
    cdef ListMapStringBool obj = ListMapStringBool.__new__(ListMapStringBool)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListMapStringBoolHandle h
        h = _c_api.ListMapStringBool_create_empty()
        if h == <_c_api.ListMapStringBoolHandle>0:
            raise MemoryError("Failed to create ListMapStringBool")
        cdef ListMapStringBool obj = <ListMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, MapStringBool data, size_t count):
        cdef _c_api.ListMapStringBoolHandle h
        h = _c_api.ListMapStringBool_create(data.handle, count)
        if h == <_c_api.ListMapStringBoolHandle>0:
            raise MemoryError("Failed to create ListMapStringBool")
        cdef ListMapStringBool obj = <ListMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListMapStringBoolHandle h
        try:
            h = _c_api.ListMapStringBool_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListMapStringBoolHandle>0:
            raise MemoryError("Failed to create ListMapStringBool")
        cdef ListMapStringBool obj = <ListMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, MapStringBool value):
        cdef _c_api.ListMapStringBoolHandle h_ret = _c_api.ListMapStringBool_fill_value(count, value.handle)
        if h_ret == <_c_api.ListMapStringBoolHandle>0:
            return None
        return _list_map_string_bool_from_capi(h_ret)

    def push_back(self, MapStringBool value):
        _c_api.ListMapStringBool_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListMapStringBool_size(self.handle)

    def empty(self, ):
        return _c_api.ListMapStringBool_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListMapStringBool_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListMapStringBool_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.MapStringBoolHandle h_ret = _c_api.ListMapStringBool_at(self.handle, idx)
        if h_ret == <_c_api.MapStringBoolHandle>0:
            return None
        return map_string_bool._map_string_bool_from_capi(h_ret)

    def items(self, MapStringBool out_buffer, size_t buffer_size):
        return _c_api.ListMapStringBool_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, MapStringBool value):
        return _c_api.ListMapStringBool_contains(self.handle, value.handle)

    def index(self, MapStringBool value):
        return _c_api.ListMapStringBool_index(self.handle, value.handle)

    def intersection(self, ListMapStringBool other):
        cdef _c_api.ListMapStringBoolHandle h_ret = _c_api.ListMapStringBool_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListMapStringBoolHandle>0:
            return None
        return _list_map_string_bool_from_capi(h_ret)

    def equal(self, ListMapStringBool b):
        return _c_api.ListMapStringBool_equal(self.handle, b.handle)

    def __eq__(self, ListMapStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListMapStringBool b):
        return _c_api.ListMapStringBool_not_equal(self.handle, b.handle)

    def __ne__(self, ListMapStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
