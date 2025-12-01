cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport control_array

cdef class ListControlArray:
    def __cinit__(self):
        self.handle = <_c_api.ListControlArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListControlArrayHandle>0 and self.owned:
            _c_api.ListControlArray_destroy(self.handle)
        self.handle = <_c_api.ListControlArrayHandle>0


cdef ListControlArray _list_control_array_from_capi(_c_api.ListControlArrayHandle h):
    if h == <_c_api.ListControlArrayHandle>0:
        return None
    cdef ListControlArray obj = ListControlArray.__new__(ListControlArray)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListControlArrayHandle h
        h = _c_api.ListControlArray_create_empty()
        if h == <_c_api.ListControlArrayHandle>0:
            raise MemoryError("Failed to create ListControlArray")
        cdef ListControlArray obj = <ListControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, ControlArray data, size_t count):
        cdef _c_api.ListControlArrayHandle h
        h = _c_api.ListControlArray_create(data.handle, count)
        if h == <_c_api.ListControlArrayHandle>0:
            raise MemoryError("Failed to create ListControlArray")
        cdef ListControlArray obj = <ListControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListControlArrayHandle h
        try:
            h = _c_api.ListControlArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListControlArrayHandle>0:
            raise MemoryError("Failed to create ListControlArray")
        cdef ListControlArray obj = <ListControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, ControlArray value):
        cdef _c_api.ListControlArrayHandle h_ret = _c_api.ListControlArray_fill_value(count, value.handle)
        if h_ret == <_c_api.ListControlArrayHandle>0:
            return None
        return _list_control_array_from_capi(h_ret)

    def push_back(self, ControlArray value):
        _c_api.ListControlArray_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListControlArray_size(self.handle)

    def empty(self, ):
        return _c_api.ListControlArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListControlArray_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListControlArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ControlArrayHandle h_ret = _c_api.ListControlArray_at(self.handle, idx)
        if h_ret == <_c_api.ControlArrayHandle>0:
            return None
        return control_array._control_array_from_capi(h_ret)

    def items(self, ControlArray out_buffer, size_t buffer_size):
        return _c_api.ListControlArray_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, ControlArray value):
        return _c_api.ListControlArray_contains(self.handle, value.handle)

    def index(self, ControlArray value):
        return _c_api.ListControlArray_index(self.handle, value.handle)

    def intersection(self, ListControlArray other):
        cdef _c_api.ListControlArrayHandle h_ret = _c_api.ListControlArray_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListControlArrayHandle>0:
            return None
        return _list_control_array_from_capi(h_ret)

    def equal(self, ListControlArray b):
        return _c_api.ListControlArray_equal(self.handle, b.handle)

    def __eq__(self, ListControlArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListControlArray b):
        return _c_api.ListControlArray_not_equal(self.handle, b.handle)

    def __ne__(self, ListControlArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
