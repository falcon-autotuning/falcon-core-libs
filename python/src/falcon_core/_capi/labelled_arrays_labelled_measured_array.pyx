cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .labelled_measured_array cimport LabelledMeasuredArray, _labelled_measured_array_from_capi
from .list_acquisition_context cimport ListAcquisitionContext, _list_acquisition_context_from_capi
from .list_labelled_measured_array cimport ListLabelledMeasuredArray, _list_labelled_measured_array_from_capi

cdef class LabelledArraysLabelledMeasuredArray:
    def __cinit__(self):
        self.handle = <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0 and self.owned:
            _c_api.LabelledArraysLabelledMeasuredArray_destroy(self.handle)
        self.handle = <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0


    @classmethod
    def new(cls, ListLabelledMeasuredArray arrays):
        cdef _c_api.LabelledArraysLabelledMeasuredArrayHandle h
        h = _c_api.LabelledArraysLabelledMeasuredArray_create(arrays.handle if arrays is not None else <_c_api.ListLabelledMeasuredArrayHandle>0)
        if h == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledMeasuredArray")
        cdef LabelledArraysLabelledMeasuredArray obj = <LabelledArraysLabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def copy(self, ):
        cdef _c_api.LabelledArraysLabelledMeasuredArrayHandle h_ret = _c_api.LabelledArraysLabelledMeasuredArray_copy(self.handle)
        if h_ret == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            return None
        return _labelled_arrays_labelled_measured_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledArraysLabelledMeasuredArrayHandle>self.handle))

    def arrays(self, ):
        cdef _c_api.ListLabelledMeasuredArrayHandle h_ret = _c_api.LabelledArraysLabelledMeasuredArray_arrays(self.handle)
        if h_ret == <_c_api.ListLabelledMeasuredArrayHandle>0:
            return None
        return _list_labelled_measured_array_from_capi(h_ret, owned=True)

    def labels(self, ):
        cdef _c_api.ListAcquisitionContextHandle h_ret = _c_api.LabelledArraysLabelledMeasuredArray_labels(self.handle)
        if h_ret == <_c_api.ListAcquisitionContextHandle>0:
            return None
        return _list_acquisition_context_from_capi(h_ret, owned=True)

    def is_control_arrays(self, ):
        return _c_api.LabelledArraysLabelledMeasuredArray_is_control_arrays(self.handle)

    def is_measured_arrays(self, ):
        return _c_api.LabelledArraysLabelledMeasuredArray_is_measured_arrays(self.handle)

    def push_back(self, LabelledMeasuredArray value):
        _c_api.LabelledArraysLabelledMeasuredArray_push_back(self.handle, value.handle if value is not None else <_c_api.LabelledMeasuredArrayHandle>0)

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
        return _labelled_measured_array_from_capi(h_ret, owned=False)

    def contains(self, LabelledMeasuredArray value):
        return _c_api.LabelledArraysLabelledMeasuredArray_contains(self.handle, value.handle if value is not None else <_c_api.LabelledMeasuredArrayHandle>0)

    def index(self, LabelledMeasuredArray value):
        return _c_api.LabelledArraysLabelledMeasuredArray_index(self.handle, value.handle if value is not None else <_c_api.LabelledMeasuredArrayHandle>0)

    def intersection(self, LabelledArraysLabelledMeasuredArray other):
        cdef _c_api.LabelledArraysLabelledMeasuredArrayHandle h_ret = _c_api.LabelledArraysLabelledMeasuredArray_intersection(self.handle, other.handle if other is not None else <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0)
        if h_ret == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
            return None
        return _labelled_arrays_labelled_measured_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledArraysLabelledMeasuredArrayHandle>self.handle))

    def equal(self, LabelledArraysLabelledMeasuredArray other):
        return _c_api.LabelledArraysLabelledMeasuredArray_equal(self.handle, other.handle if other is not None else <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0)

    def __eq__(self, LabelledArraysLabelledMeasuredArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, LabelledArraysLabelledMeasuredArray other):
        return _c_api.LabelledArraysLabelledMeasuredArray_not_equal(self.handle, other.handle if other is not None else <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0)

    def __ne__(self, LabelledArraysLabelledMeasuredArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.LabelledArraysLabelledMeasuredArray_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

    def append(self, value):
        self.push_back(value)

cdef LabelledArraysLabelledMeasuredArray _labelled_arrays_labelled_measured_array_from_capi(_c_api.LabelledArraysLabelledMeasuredArrayHandle h, bint owned=True):
    if h == <_c_api.LabelledArraysLabelledMeasuredArrayHandle>0:
        return None
    cdef LabelledArraysLabelledMeasuredArray obj = LabelledArraysLabelledMeasuredArray.__new__(LabelledArraysLabelledMeasuredArray)
    obj.handle = h
    obj.owned = owned
    return obj
