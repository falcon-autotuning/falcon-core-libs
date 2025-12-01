cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport labelled_measured_array
from . cimport list_acquisition_context
from . cimport list_labelled_measured_array

cdef class LabelledArraysLabelledMeasuredArray:
    def __cinit__(self):
        self.handle = <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0 and self.owned:
            _c_api.LabelledArraysLabelledMeasuredArray_destroy(self.handle)
        self.handle = <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0


cdef LabelledArraysLabelledMeasuredArray _labelled_arrays_labelled_measured_array_from_capi(_c_api.LabelledArraysLabelledMeasuredArrayHandle h):
    if h == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
        return None
    cdef LabelledArraysLabelledMeasuredArray obj = LabelledArraysLabelledMeasuredArray.__new__(LabelledArraysLabelledMeasuredArray)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, ListLabelledMeasuredArray arrays):
        cdef _c_api.LabelledArraysLabelledMeasuredArrayHandle h
        h = _c_api.LabelledArraysLabelledMeasuredArray_create(arrays.handle)
        if h == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledMeasuredArray")
        cdef LabelledArraysLabelledMeasuredArray obj = <LabelledArraysLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.LabelledArraysLabelledMeasuredArrayHandle h
        try:
            h = _c_api.LabelledArraysLabelledMeasuredArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledMeasuredArray")
        cdef LabelledArraysLabelledMeasuredArray obj = <LabelledArraysLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def arrays(self, ):
        cdef _c_api.ListLabelledMeasuredArrayHandle h_ret = _c_api.LabelledArraysLabelledMeasuredArray_arrays(self.handle)
        if h_ret == <_c_api.ListLabelledMeasuredArrayHandle>0:
            return None
        return list_labelled_measured_array._list_labelled_measured_array_from_capi(h_ret)

    def labels(self, ):
        cdef _c_api.ListAcquisitionContextHandle h_ret = _c_api.LabelledArraysLabelledMeasuredArray_labels(self.handle)
        if h_ret == <_c_api.ListAcquisitionContextHandle>0:
            return None
        return list_acquisition_context._list_acquisition_context_from_capi(h_ret)

    def isControlArrays(self, ):
        return _c_api.LabelledArraysLabelledMeasuredArray_isControlArrays(self.handle)

    def isMeasuredArrays(self, ):
        return _c_api.LabelledArraysLabelledMeasuredArray_isMeasuredArrays(self.handle)

    def push_back(self, LabelledMeasuredArray value):
        _c_api.LabelledArraysLabelledMeasuredArray_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.LabelledArraysLabelledMeasuredArray_size(self.handle)

    def empty(self, ):
        return _c_api.LabelledArraysLabelledMeasuredArray_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.LabelledArraysLabelledMeasuredArray_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.LabelledArraysLabelledMeasuredArray_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.LabelledMeasuredArrayHandle h_ret = _c_api.LabelledArraysLabelledMeasuredArray_at(self.handle, idx)
        if h_ret == <_c_api.LabelledMeasuredArrayHandle>0:
            return None
        return labelled_measured_array._labelled_measured_array_from_capi(h_ret)

    def contains(self, LabelledMeasuredArray value):
        return _c_api.LabelledArraysLabelledMeasuredArray_contains(self.handle, value.handle)

    def index(self, LabelledMeasuredArray value):
        return _c_api.LabelledArraysLabelledMeasuredArray_index(self.handle, value.handle)

    def intersection(self, LabelledArraysLabelledMeasuredArray other):
        cdef _c_api.LabelledArraysLabelledMeasuredArrayHandle h_ret = _c_api.LabelledArraysLabelledMeasuredArray_intersection(self.handle, other.handle)
        if h_ret == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            return None
        return _labelled_arrays_labelled_measured_array_from_capi(h_ret)

    def equal(self, LabelledArraysLabelledMeasuredArray other):
        return _c_api.LabelledArraysLabelledMeasuredArray_equal(self.handle, other.handle)

    def __eq__(self, LabelledArraysLabelledMeasuredArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, LabelledArraysLabelledMeasuredArray other):
        return _c_api.LabelledArraysLabelledMeasuredArray_not_equal(self.handle, other.handle)

    def __ne__(self, LabelledArraysLabelledMeasuredArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
