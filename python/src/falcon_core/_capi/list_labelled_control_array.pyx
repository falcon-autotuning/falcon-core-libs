cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport labelled_control_array

cdef class ListLabelledControlArray:
    def __cinit__(self):
        self.handle = <_c_api.ListLabelledControlArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListLabelledControlArrayHandle>0 and self.owned:
            _c_api.ListLabelledControlArray_destroy(self.handle)
        self.handle = <_c_api.ListLabelledControlArrayHandle>0


cdef ListLabelledControlArray _list_labelled_control_array_from_capi(_c_api.ListLabelledControlArrayHandle h):
    if h == <_c_api.ListLabelledControlArrayHandle>0:
        return None
    cdef ListLabelledControlArray obj = ListLabelledControlArray.__new__(ListLabelledControlArray)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListLabelledControlArrayHandle h
        h = _c_api.ListLabelledControlArray_create_empty()
        if h == <_c_api.ListLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create ListLabelledControlArray")
        cdef ListLabelledControlArray obj = <ListLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, LabelledControlArray data, size_t count):
        cdef _c_api.ListLabelledControlArrayHandle h
        h = _c_api.ListLabelledControlArray_create(data.handle, count)
        if h == <_c_api.ListLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create ListLabelledControlArray")
        cdef ListLabelledControlArray obj = <ListLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListLabelledControlArrayHandle h
        try:
            h = _c_api.ListLabelledControlArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create ListLabelledControlArray")
        cdef ListLabelledControlArray obj = <ListLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, LabelledControlArray value):
        cdef _c_api.ListLabelledControlArrayHandle h_ret = _c_api.ListLabelledControlArray_fill_value(count, value.handle)
        if h_ret == <_c_api.ListLabelledControlArrayHandle>0:
            return None
        return _list_labelled_control_array_from_capi(h_ret)

    def push_back(self, LabelledControlArray value):
        _c_api.ListLabelledControlArray_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListLabelledControlArray_size(self.handle)

    def empty(self, ):
        return _c_api.ListLabelledControlArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListLabelledControlArray_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListLabelledControlArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.ListLabelledControlArray_at(self.handle, idx)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return labelled_control_array._labelled_control_array_from_capi(h_ret)

    def items(self, LabelledControlArray out_buffer, size_t buffer_size):
        return _c_api.ListLabelledControlArray_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, LabelledControlArray value):
        return _c_api.ListLabelledControlArray_contains(self.handle, value.handle)

    def index(self, LabelledControlArray value):
        return _c_api.ListLabelledControlArray_index(self.handle, value.handle)

    def intersection(self, ListLabelledControlArray other):
        cdef _c_api.ListLabelledControlArrayHandle h_ret = _c_api.ListLabelledControlArray_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListLabelledControlArrayHandle>0:
            return None
        return _list_labelled_control_array_from_capi(h_ret)

    def equal(self, ListLabelledControlArray b):
        return _c_api.ListLabelledControlArray_equal(self.handle, b.handle)

    def __eq__(self, ListLabelledControlArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListLabelledControlArray b):
        return _c_api.ListLabelledControlArray_not_equal(self.handle, b.handle)

    def __ne__(self, ListLabelledControlArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
