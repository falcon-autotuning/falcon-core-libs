cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport control_array
from . cimport list_control_array

cdef class AxesControlArray:
    def __cinit__(self):
        self.handle = <_c_api.AxesControlArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesControlArrayHandle>0 and self.owned:
            _c_api.AxesControlArray_destroy(self.handle)
        self.handle = <_c_api.AxesControlArrayHandle>0


cdef AxesControlArray _axes_control_array_from_capi(_c_api.AxesControlArrayHandle h):
    if h == <_c_api.AxesControlArrayHandle>0:
        return None
    cdef AxesControlArray obj = AxesControlArray.__new__(AxesControlArray)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.AxesControlArrayHandle h
        h = _c_api.AxesControlArray_create_empty()
        if h == <_c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def raw(cls, ControlArray data, size_t count):
        cdef _c_api.AxesControlArrayHandle h
        h = _c_api.AxesControlArray_create_raw(data.handle, count)
        if h == <_c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, ListControlArray data):
        cdef _c_api.AxesControlArrayHandle h
        h = _c_api.AxesControlArray_create(data.handle)
        if h == <_c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesControlArrayHandle h
        try:
            h = _c_api.AxesControlArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesControlArrayHandle>0:
            raise MemoryError("Failed to create AxesControlArray")
        cdef AxesControlArray obj = <AxesControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, ControlArray value):
        _c_api.AxesControlArray_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.AxesControlArray_size(self.handle)

    def empty(self, ):
        return _c_api.AxesControlArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesControlArray_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesControlArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.ControlArrayHandle h_ret = _c_api.AxesControlArray_at(self.handle, idx)
        if h_ret == <_c_api.ControlArrayHandle>0:
            return None
        return control_array._control_array_from_capi(h_ret)

    def items(self, ControlArray out_buffer, size_t buffer_size):
        return _c_api.AxesControlArray_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, ControlArray value):
        return _c_api.AxesControlArray_contains(self.handle, value.handle)

    def index(self, ControlArray value):
        return _c_api.AxesControlArray_index(self.handle, value.handle)

    def intersection(self, AxesControlArray other):
        cdef _c_api.AxesControlArrayHandle h_ret = _c_api.AxesControlArray_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesControlArrayHandle>0:
            return None
        return _axes_control_array_from_capi(h_ret)

    def equal(self, AxesControlArray b):
        return _c_api.AxesControlArray_equal(self.handle, b.handle)

    def __eq__(self, AxesControlArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesControlArray b):
        return _c_api.AxesControlArray_not_equal(self.handle, b.handle)

    def __ne__(self, AxesControlArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
