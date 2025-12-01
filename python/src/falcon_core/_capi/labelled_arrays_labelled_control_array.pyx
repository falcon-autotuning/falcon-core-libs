cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport labelled_control_array
from . cimport list_acquisition_context
from . cimport list_labelled_control_array

cdef class LabelledArraysLabelledControlArray:
    def __cinit__(self):
        self.handle = <_c_api.LabelledArraysLabelledControlArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.LabelledArraysLabelledControlArrayHandle>0 and self.owned:
            _c_api.LabelledArraysLabelledControlArray_destroy(self.handle)
        self.handle = <_c_api.LabelledArraysLabelledControlArrayHandle>0


cdef LabelledArraysLabelledControlArray _labelled_arrays_labelled_control_array_from_capi(_c_api.LabelledArraysLabelledControlArrayHandle h):
    if h == <_c_api.LabelledArraysLabelledControlArrayHandle>0:
        return None
    cdef LabelledArraysLabelledControlArray obj = LabelledArraysLabelledControlArray.__new__(LabelledArraysLabelledControlArray)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, ListLabelledControlArray arrays):
        cdef _c_api.LabelledArraysLabelledControlArrayHandle h
        h = _c_api.LabelledArraysLabelledControlArray_create(arrays.handle)
        if h == <_c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledControlArray")
        cdef LabelledArraysLabelledControlArray obj = <LabelledArraysLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.LabelledArraysLabelledControlArrayHandle h
        try:
            h = _c_api.LabelledArraysLabelledControlArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledControlArray")
        cdef LabelledArraysLabelledControlArray obj = <LabelledArraysLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def arrays(self, ):
        cdef _c_api.ListLabelledControlArrayHandle h_ret = _c_api.LabelledArraysLabelledControlArray_arrays(self.handle)
        if h_ret == <_c_api.ListLabelledControlArrayHandle>0:
            return None
        return list_labelled_control_array._list_labelled_control_array_from_capi(h_ret)

    def labels(self, ):
        cdef _c_api.ListAcquisitionContextHandle h_ret = _c_api.LabelledArraysLabelledControlArray_labels(self.handle)
        if h_ret == <_c_api.ListAcquisitionContextHandle>0:
            return None
        return list_acquisition_context._list_acquisition_context_from_capi(h_ret)

    def isControlArrays(self, ):
        return _c_api.LabelledArraysLabelledControlArray_isControlArrays(self.handle)

    def isMeasuredArrays(self, ):
        return _c_api.LabelledArraysLabelledControlArray_isMeasuredArrays(self.handle)

    def push_back(self, LabelledControlArray value):
        _c_api.LabelledArraysLabelledControlArray_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.LabelledArraysLabelledControlArray_size(self.handle)

    def empty(self, ):
        return _c_api.LabelledArraysLabelledControlArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.LabelledArraysLabelledControlArray_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.LabelledArraysLabelledControlArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledArraysLabelledControlArray_at(self.handle, idx)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return labelled_control_array._labelled_control_array_from_capi(h_ret)

    def contains(self, LabelledControlArray value):
        return _c_api.LabelledArraysLabelledControlArray_contains(self.handle, value.handle)

    def index(self, LabelledControlArray value):
        return _c_api.LabelledArraysLabelledControlArray_index(self.handle, value.handle)

    def intersection(self, LabelledArraysLabelledControlArray other):
        cdef _c_api.LabelledArraysLabelledControlArrayHandle h_ret = _c_api.LabelledArraysLabelledControlArray_intersection(self.handle, other.handle)
        if h_ret == <_c_api.LabelledArraysLabelledControlArrayHandle>0:
            return None
        return _labelled_arrays_labelled_control_array_from_capi(h_ret)

    def equal(self, LabelledArraysLabelledControlArray other):
        return _c_api.LabelledArraysLabelledControlArray_equal(self.handle, other.handle)

    def __eq__(self, LabelledArraysLabelledControlArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, LabelledArraysLabelledControlArray other):
        return _c_api.LabelledArraysLabelledControlArray_not_equal(self.handle, other.handle)

    def __ne__(self, LabelledArraysLabelledControlArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
