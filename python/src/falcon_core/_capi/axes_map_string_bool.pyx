cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_map_string_bool
from . cimport map_string_bool

cdef class AxesMapStringBool:
    def __cinit__(self):
        self.handle = <_c_api.AxesMapStringBoolHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesMapStringBoolHandle>0 and self.owned:
            _c_api.AxesMapStringBool_destroy(self.handle)
        self.handle = <_c_api.AxesMapStringBoolHandle>0


cdef AxesMapStringBool _axes_map_string_bool_from_capi(_c_api.AxesMapStringBoolHandle h):
    if h == <_c_api.AxesMapStringBoolHandle>0:
        return None
    cdef AxesMapStringBool obj = AxesMapStringBool.__new__(AxesMapStringBool)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesMapStringBoolHandle h
        h = _c_api.AxesMapStringBool_create_empty()
        if h == <_c_api.AxesMapStringBoolHandle>0:
            raise MemoryError("Failed to create AxesMapStringBool")
        cdef AxesMapStringBool obj = <AxesMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, MapStringBool data, size_t count):
        cdef _c_api.AxesMapStringBoolHandle h
        h = _c_api.AxesMapStringBool_create_raw(data.handle, count)
        if h == <_c_api.AxesMapStringBoolHandle>0:
            raise MemoryError("Failed to create AxesMapStringBool")
        cdef AxesMapStringBool obj = <AxesMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListMapStringBool data):
        cdef _c_api.AxesMapStringBoolHandle h
        h = _c_api.AxesMapStringBool_create(data.handle)
        if h == <_c_api.AxesMapStringBoolHandle>0:
            raise MemoryError("Failed to create AxesMapStringBool")
        cdef AxesMapStringBool obj = <AxesMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesMapStringBoolHandle h
        try:
            h = _c_api.AxesMapStringBool_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesMapStringBoolHandle>0:
            raise MemoryError("Failed to create AxesMapStringBool")
        cdef AxesMapStringBool obj = <AxesMapStringBool>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, MapStringBool value):
        _c_api.AxesMapStringBool_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.AxesMapStringBool_size(self.handle)

    def empty(self, ):
        return _c_api.AxesMapStringBool_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesMapStringBool_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesMapStringBool_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.MapStringBoolHandle h_ret = _c_api.AxesMapStringBool_at(self.handle, idx)
        if h_ret == <_c_api.MapStringBoolHandle>0:
            return None
        return map_string_bool._map_string_bool_from_capi(h_ret)

    def items(self, MapStringBool out_buffer, size_t buffer_size):
        return _c_api.AxesMapStringBool_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, MapStringBool value):
        return _c_api.AxesMapStringBool_contains(self.handle, value.handle)

    def index(self, MapStringBool value):
        return _c_api.AxesMapStringBool_index(self.handle, value.handle)

    def intersection(self, AxesMapStringBool other):
        cdef _c_api.AxesMapStringBoolHandle h_ret = _c_api.AxesMapStringBool_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesMapStringBoolHandle>0:
            return None
        return _axes_map_string_bool_from_capi(h_ret)

    def equal(self, AxesMapStringBool b):
        return _c_api.AxesMapStringBool_equal(self.handle, b.handle)

    def __eq__(self, AxesMapStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesMapStringBool b):
        return _c_api.AxesMapStringBool_not_equal(self.handle, b.handle)

    def __ne__(self, AxesMapStringBool b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
