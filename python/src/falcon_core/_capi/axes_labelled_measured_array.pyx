cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport labelled_measured_array
from . cimport list_labelled_measured_array

cdef class AxesLabelledMeasuredArray:
    def __cinit__(self):
        self.handle = <_c_api.AxesLabelledMeasuredArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AxesLabelledMeasuredArrayHandle>0 and self.owned:
            _c_api.AxesLabelledMeasuredArray_destroy(self.handle)
        self.handle = <_c_api.AxesLabelledMeasuredArrayHandle>0


cdef AxesLabelledMeasuredArray _axes_labelled_measured_array_from_capi(_c_api.AxesLabelledMeasuredArrayHandle h):
    if h == <_c_api.AxesLabelledMeasuredArrayHandle>0:
        return None
    cdef AxesLabelledMeasuredArray obj = AxesLabelledMeasuredArray.__new__(AxesLabelledMeasuredArray)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.AxesLabelledMeasuredArrayHandle h
        h = _c_api.AxesLabelledMeasuredArray_create_empty()
        if h == <_c_api.AxesLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create AxesLabelledMeasuredArray")
        cdef AxesLabelledMeasuredArray obj = <AxesLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, LabelledMeasuredArray data, size_t count):
        cdef _c_api.AxesLabelledMeasuredArrayHandle h
        h = _c_api.AxesLabelledMeasuredArray_create_raw(data.handle, count)
        if h == <_c_api.AxesLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create AxesLabelledMeasuredArray")
        cdef AxesLabelledMeasuredArray obj = <AxesLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListLabelledMeasuredArray data):
        cdef _c_api.AxesLabelledMeasuredArrayHandle h
        h = _c_api.AxesLabelledMeasuredArray_create(data.handle)
        if h == <_c_api.AxesLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create AxesLabelledMeasuredArray")
        cdef AxesLabelledMeasuredArray obj = <AxesLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AxesLabelledMeasuredArrayHandle h
        try:
            h = _c_api.AxesLabelledMeasuredArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AxesLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create AxesLabelledMeasuredArray")
        cdef AxesLabelledMeasuredArray obj = <AxesLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, LabelledMeasuredArray value):
        _c_api.AxesLabelledMeasuredArray_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.AxesLabelledMeasuredArray_size(self.handle)

    def empty(self, ):
        return _c_api.AxesLabelledMeasuredArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.AxesLabelledMeasuredArray_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.AxesLabelledMeasuredArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.LabelledMeasuredArrayHandle h_ret = _c_api.AxesLabelledMeasuredArray_at(self.handle, idx)
        if h_ret == <_c_api.LabelledMeasuredArrayHandle>0:
            return None
        return labelled_measured_array._labelled_measured_array_from_capi(h_ret)

    def items(self, LabelledMeasuredArray out_buffer, size_t buffer_size):
        return _c_api.AxesLabelledMeasuredArray_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, LabelledMeasuredArray value):
        return _c_api.AxesLabelledMeasuredArray_contains(self.handle, value.handle)

    def index(self, LabelledMeasuredArray value):
        return _c_api.AxesLabelledMeasuredArray_index(self.handle, value.handle)

    def intersection(self, AxesLabelledMeasuredArray other):
        cdef _c_api.AxesLabelledMeasuredArrayHandle h_ret = _c_api.AxesLabelledMeasuredArray_intersection(self.handle, other.handle)
        if h_ret == <_c_api.AxesLabelledMeasuredArrayHandle>0:
            return None
        return _axes_labelled_measured_array_from_capi(h_ret)

    def equal(self, AxesLabelledMeasuredArray b):
        return _c_api.AxesLabelledMeasuredArray_equal(self.handle, b.handle)

    def __eq__(self, AxesLabelledMeasuredArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AxesLabelledMeasuredArray b):
        return _c_api.AxesLabelledMeasuredArray_not_equal(self.handle, b.handle)

    def __ne__(self, AxesLabelledMeasuredArray b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
