# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .labelled_control_array cimport LabelledControlArray
from .list_acquisition_context cimport ListAcquisitionContext
from .list_labelled_control_array cimport ListLabelledControlArray

cdef class LabelledArraysLabelledControlArray:
    cdef c_api.LabelledArraysLabelledControlArrayHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.LabelledArraysLabelledControlArrayHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.LabelledArraysLabelledControlArrayHandle>0 and self.owned:
            c_api.LabelledArraysLabelledControlArray_destroy(self.handle)
        self.handle = <c_api.LabelledArraysLabelledControlArrayHandle>0

    cdef LabelledArraysLabelledControlArray from_capi(cls, c_api.LabelledArraysLabelledControlArrayHandle h):
        cdef LabelledArraysLabelledControlArray obj = <LabelledArraysLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, arrays):
        cdef c_api.LabelledArraysLabelledControlArrayHandle h
        h = c_api.LabelledArraysLabelledControlArray_create(<c_api.ListLabelledControlArrayHandle>arrays.handle)
        if h == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledControlArray")
        cdef LabelledArraysLabelledControlArray obj = <LabelledArraysLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.LabelledArraysLabelledControlArrayHandle h
        try:
            h = c_api.LabelledArraysLabelledControlArray_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledControlArray")
        cdef LabelledArraysLabelledControlArray obj = <LabelledArraysLabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def arrays(self):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListLabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledArraysLabelledControlArray_arrays(self.handle)
        if h_ret == <c_api.ListLabelledControlArrayHandle>0:
            return None
        return ListLabelledControlArray.from_capi(ListLabelledControlArray, h_ret)

    def labels(self):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListAcquisitionContextHandle h_ret
        h_ret = c_api.LabelledArraysLabelledControlArray_labels(self.handle)
        if h_ret == <c_api.ListAcquisitionContextHandle>0:
            return None
        return ListAcquisitionContext.from_capi(ListAcquisitionContext, h_ret)

    def isControlArrays(self):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledControlArray_isControlArrays(self.handle)

    def isMeasuredArrays(self):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledControlArray_isMeasuredArrays(self.handle)

    def push_back(self, value):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledArraysLabelledControlArray_push_back(self.handle, <c_api.LabelledControlArrayHandle>value.handle)

    def size(self):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledControlArray_size(self.handle)

    def empty(self):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledControlArray_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledArraysLabelledControlArray_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledArraysLabelledControlArray_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledArraysLabelledControlArray_at(self.handle, idx)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def contains(self, value):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledControlArray_contains(self.handle, <c_api.LabelledControlArrayHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledControlArray_index(self.handle, <c_api.LabelledControlArrayHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledArraysLabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledArraysLabelledControlArray_intersection(self.handle, <c_api.LabelledArraysLabelledControlArrayHandle>other.handle)
        if h_ret == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            return None
        return LabelledArraysLabelledControlArray.from_capi(LabelledArraysLabelledControlArray, h_ret)

    def equal(self, other):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledControlArray_equal(self.handle, <c_api.LabelledArraysLabelledControlArrayHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledArraysLabelledControlArray_not_equal(self.handle, <c_api.LabelledArraysLabelledControlArrayHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.LabelledArraysLabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.LabelledArraysLabelledControlArray_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef LabelledArraysLabelledControlArray _labelledarrayslabelledcontrolarray_from_capi(c_api.LabelledArraysLabelledControlArrayHandle h):
    cdef LabelledArraysLabelledControlArray obj = <LabelledArraysLabelledControlArray>LabelledArraysLabelledControlArray.__new__(LabelledArraysLabelledControlArray)
    obj.handle = h