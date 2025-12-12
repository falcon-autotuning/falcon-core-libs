cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport labelled_control_array
from . cimport list_labelled_control_array

cdef class AxesLabelledControlArray:
    def __cinit__(self):
        self.handle = <_c_api.AxesLabelledControlArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesLabelledControlArrayHandle>0 and self.owned:
            _c_api.AxesLabelledControlArray_destroy(self.handle)
        self.handle = <_c_api.AxesLabelledControlArrayHandle>0


cdef AxesLabelledControlArray _axes_labelled_control_array_from_capi(_c_api.AxesLabelledControlArrayHandle h):
    if h == <_c_api.AxesLabelledControlArrayHandle>0:
        return None
    cdef AxesLabelledControlArray obj = AxesLabelledControlArray.__new__(AxesLabelledControlArray)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesLabelledControlArrayHandle h
        h = _c_api.AxesLabelledControlArray_create_empty()
        if h == <_c_api.AxesLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create AxesLabelledControlArray")
        cdef AxesLabelledControlArray obj = <AxesLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, LabelledControlArray data, size_t count):
        cdef _c_api.AxesLabelledControlArrayHandle h
        h = _c_api.AxesLabelledControlArray_create_raw(data.handle, count)
        if h == <_c_api.AxesLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create AxesLabelledControlArray")
        cdef AxesLabelledControlArray obj = <AxesLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListLabelledControlArray data):
        cdef _c_api.AxesLabelledControlArrayHandle h
        h = _c_api.AxesLabelledControlArray_create(data.handle)
        if h == <_c_api.AxesLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create AxesLabelledControlArray")
        cdef AxesLabelledControlArray obj = <AxesLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesLabelledControlArrayHandle h
        try:
            h = _c_api.AxesLabelledControlArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create AxesLabelledControlArray")
        cdef AxesLabelledControlArray obj = <AxesLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, LabelledControlArray value):
        _c_api.AxesLabelledControlArray_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.AxesLabelledControlArray_size(self.handle)

    def empty(self, ):
        return _c_api.AxesLabelledControlArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesLabelledControlArray_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesLabelledControlArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.AxesLabelledControlArray_at(self.handle, idx)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return labelled_control_array._labelled_control_array_from_capi(h_ret)

    def items(self, LabelledControlArray out_buffer, size_t buffer_size):
        return _c_api.AxesLabelledControlArray_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, LabelledControlArray value):
        return _c_api.AxesLabelledControlArray_contains(self.handle, value.handle)

    def index(self, LabelledControlArray value):
        return _c_api.AxesLabelledControlArray_index(self.handle, value.handle)

    def intersection(self, AxesLabelledControlArray other):
        cdef _c_api.AxesLabelledControlArrayHandle h_ret = _c_api.AxesLabelledControlArray_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesLabelledControlArrayHandle>0:
            return None
        return _axes_labelled_control_array_from_capi(h_ret)

    def equal(self, AxesLabelledControlArray b):
        return _c_api.AxesLabelledControlArray_equal(self.handle, b.handle)

    def __eq__(self, AxesLabelledControlArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesLabelledControlArray b):
        return _c_api.AxesLabelledControlArray_not_equal(self.handle, b.handle)

    def __ne__(self, AxesLabelledControlArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
