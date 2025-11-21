# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .labelled_measured_array cimport LabelledMeasuredArray
from .list_acquisition_context cimport ListAcquisitionContext
from .list_labelled_measured_array cimport ListLabelledMeasuredArray

cdef class LabelledArraysLabelledMeasuredArray:
    cdef c_api.LabelledArraysLabelledMeasuredArrayHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.LabelledArraysLabelledMeasuredArrayHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.LabelledArraysLabelledMeasuredArrayHandle>0 and self.owned:
            c_api.LabelledArraysLabelledMeasuredArray_destroy(self.handle)
        self.handle = <c_api.LabelledArraysLabelledMeasuredArrayHandle>0

    cdef LabelledArraysLabelledMeasuredArray from_capi(cls, c_api.LabelledArraysLabelledMeasuredArrayHandle h):
        cdef LabelledArraysLabelledMeasuredArray obj = <LabelledArraysLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, arrays):
        cdef c_api.LabelledArraysLabelledMeasuredArrayHandle h
        h = c_api.LabelledArraysLabelledMeasuredArray_create(<c_api.ListLabelledMeasuredArrayHandle>arrays.handle)
        if h == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledMeasuredArray")
        cdef LabelledArraysLabelledMeasuredArray obj = <LabelledArraysLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.LabelledArraysLabelledMeasuredArrayHandle h
        try:
            h = c_api.LabelledArraysLabelledMeasuredArray_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledMeasuredArray")
        cdef LabelledArraysLabelledMeasuredArray obj = <LabelledArraysLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def arrays(self):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListLabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledArraysLabelledMeasuredArray_arrays(self.handle)
        if h_ret == <c_api.ListLabelledMeasuredArrayHandle>0:
            return None
        return ListLabelledMeasuredArray.from_capi(ListLabelledMeasuredArray, h_ret)

    def labels(self):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListAcquisitionContextHandle h_ret
        h_ret = c_api.LabelledArraysLabelledMeasuredArray_labels(self.handle)
        if h_ret == <c_api.ListAcquisitionContextHandle>0:
            return None
        return ListAcquisitionContext.from_capi(ListAcquisitionContext, h_ret)

    def isControlArrays(self):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledMeasuredArray_isControlArrays(self.handle)

    def isMeasuredArrays(self):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledMeasuredArray_isMeasuredArrays(self.handle)

    def push_back(self, value):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledArraysLabelledMeasuredArray_push_back(self.handle, <c_api.LabelledMeasuredArrayHandle>value.handle)

    def size(self):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledMeasuredArray_size(self.handle)

    def empty(self):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledMeasuredArray_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledArraysLabelledMeasuredArray_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledArraysLabelledMeasuredArray_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledArraysLabelledMeasuredArray_at(self.handle, idx)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def contains(self, value):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledMeasuredArray_contains(self.handle, <c_api.LabelledMeasuredArrayHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledMeasuredArray_index(self.handle, <c_api.LabelledMeasuredArrayHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledArraysLabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledArraysLabelledMeasuredArray_intersection(self.handle, <c_api.LabelledArraysLabelledMeasuredArrayHandle>other.handle)
        if h_ret == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            return None
        return LabelledArraysLabelledMeasuredArray.from_capi(LabelledArraysLabelledMeasuredArray, h_ret)

    def equal(self, other):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledMeasuredArray_equal(self.handle, <c_api.LabelledArraysLabelledMeasuredArrayHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledMeasuredArray_not_equal(self.handle, <c_api.LabelledArraysLabelledMeasuredArrayHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.LabelledArraysLabelledMeasuredArray_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef LabelledArraysLabelledMeasuredArray _labelledarrayslabelledmeasuredarray_from_capi(c_api.LabelledArraysLabelledMeasuredArrayHandle h):
    cdef LabelledArraysLabelledMeasuredArray obj = <LabelledArraysLabelledMeasuredArray>LabelledArraysLabelledMeasuredArray.__new__(LabelledArraysLabelledMeasuredArray)
    obj.handle = h