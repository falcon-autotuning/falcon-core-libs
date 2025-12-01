cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport labelled_measured_array

cdef class ListLabelledMeasuredArray:
    def __cinit__(self):
        self.handle = <_c_api.ListLabelledMeasuredArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListLabelledMeasuredArrayHandle>0 and self.owned:
            _c_api.ListLabelledMeasuredArray_destroy(self.handle)
        self.handle = <_c_api.ListLabelledMeasuredArrayHandle>0


cdef ListLabelledMeasuredArray _list_labelled_measured_array_from_capi(_c_api.ListLabelledMeasuredArrayHandle h):
    if h == <_c_api.ListLabelledMeasuredArrayHandle>0:
        return None
    cdef ListLabelledMeasuredArray obj = ListLabelledMeasuredArray.__new__(ListLabelledMeasuredArray)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListLabelledMeasuredArrayHandle h
        h = _c_api.ListLabelledMeasuredArray_create_empty()
        if h == <_c_api.ListLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create ListLabelledMeasuredArray")
        cdef ListLabelledMeasuredArray obj = <ListLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, LabelledMeasuredArray data, size_t count):
        cdef _c_api.ListLabelledMeasuredArrayHandle h
        h = _c_api.ListLabelledMeasuredArray_create(data.handle, count)
        if h == <_c_api.ListLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create ListLabelledMeasuredArray")
        cdef ListLabelledMeasuredArray obj = <ListLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListLabelledMeasuredArrayHandle h
        try:
            h = _c_api.ListLabelledMeasuredArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create ListLabelledMeasuredArray")
        cdef ListLabelledMeasuredArray obj = <ListLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, LabelledMeasuredArray value):
        cdef _c_api.ListLabelledMeasuredArrayHandle h_ret = _c_api.ListLabelledMeasuredArray_fill_value(count, value.handle)
        if h_ret == <_c_api.ListLabelledMeasuredArrayHandle>0:
            return None
        return _list_labelled_measured_array_from_capi(h_ret)

    def push_back(self, LabelledMeasuredArray value):
        _c_api.ListLabelledMeasuredArray_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListLabelledMeasuredArray_size(self.handle)

    def empty(self, ):
        return _c_api.ListLabelledMeasuredArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListLabelledMeasuredArray_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListLabelledMeasuredArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.LabelledMeasuredArrayHandle h_ret = _c_api.ListLabelledMeasuredArray_at(self.handle, idx)
        if h_ret == <_c_api.LabelledMeasuredArrayHandle>0:
            return None
        return labelled_measured_array._labelled_measured_array_from_capi(h_ret)

    def items(self, LabelledMeasuredArray out_buffer, size_t buffer_size):
        return _c_api.ListLabelledMeasuredArray_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, LabelledMeasuredArray value):
        return _c_api.ListLabelledMeasuredArray_contains(self.handle, value.handle)

    def index(self, LabelledMeasuredArray value):
        return _c_api.ListLabelledMeasuredArray_index(self.handle, value.handle)

    def intersection(self, ListLabelledMeasuredArray other):
        cdef _c_api.ListLabelledMeasuredArrayHandle h_ret = _c_api.ListLabelledMeasuredArray_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListLabelledMeasuredArrayHandle>0:
            return None
        return _list_labelled_measured_array_from_capi(h_ret)

    def equal(self, ListLabelledMeasuredArray b):
        return _c_api.ListLabelledMeasuredArray_equal(self.handle, b.handle)

    def __eq__(self, ListLabelledMeasuredArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListLabelledMeasuredArray b):
        return _c_api.ListLabelledMeasuredArray_not_equal(self.handle, b.handle)

    def __ne__(self, ListLabelledMeasuredArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
