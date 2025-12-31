cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .labelled_control_array1_d cimport LabelledControlArray1D, _labelled_control_array1_d_from_capi
from .list_acquisition_context cimport ListAcquisitionContext, _list_acquisition_context_from_capi
from .list_labelled_control_array1_d cimport ListLabelledControlArray1D, _list_labelled_control_array1_d_from_capi

cdef class LabelledArraysLabelledControlArray1D:
    def __cinit__(self):
        self.handle = <_c_api.LabelledArraysLabelledControlArray1DHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.LabelledArraysLabelledControlArray1DHandle>0 and self.owned:
            _c_api.LabelledArraysLabelledControlArray1D_destroy(self.handle)
        self.handle = <_c_api.LabelledArraysLabelledControlArray1DHandle>0


    @classmethod
    def new(cls, ListLabelledControlArray1D arrays):
        cdef _c_api.LabelledArraysLabelledControlArray1DHandle h
        h = _c_api.LabelledArraysLabelledControlArray1D_create(arrays.handle if arrays is not None else <_c_api.ListLabelledControlArray1DHandle>0)
        if h == <_c_api.LabelledArraysLabelledControlArray1DHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledControlArray1D")
        cdef LabelledArraysLabelledControlArray1D obj = <LabelledArraysLabelledControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.LabelledArraysLabelledControlArray1DHandle h
        try:
            h = _c_api.LabelledArraysLabelledControlArray1D_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.LabelledArraysLabelledControlArray1DHandle>0:
            raise MemoryError("Failed to create LabelledArraysLabelledControlArray1D")
        cdef LabelledArraysLabelledControlArray1D obj = <LabelledArraysLabelledControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.LabelledArraysLabelledControlArray1DHandle h_ret = _c_api.LabelledArraysLabelledControlArray1D_copy(self.handle)
        if h_ret == <_c_api.LabelledArraysLabelledControlArray1DHandle>0:
            return None
        return _labelled_arrays_labelled_control_array1_d_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledArraysLabelledControlArray1DHandle>self.handle))

    def arrays(self, ):
        cdef _c_api.ListLabelledControlArray1DHandle h_ret = _c_api.LabelledArraysLabelledControlArray1D_arrays(self.handle)
        if h_ret == <_c_api.ListLabelledControlArray1DHandle>0:
            return None
        return _list_labelled_control_array1_d_from_capi(h_ret, owned=True)

    def labels(self, ):
        cdef _c_api.ListAcquisitionContextHandle h_ret = _c_api.LabelledArraysLabelledControlArray1D_labels(self.handle)
        if h_ret == <_c_api.ListAcquisitionContextHandle>0:
            return None
        return _list_acquisition_context_from_capi(h_ret, owned=True)

    def is_control_arrays(self, ):
        return _c_api.LabelledArraysLabelledControlArray1D_is_control_arrays(self.handle)

    def is_measured_arrays(self, ):
        return _c_api.LabelledArraysLabelledControlArray1D_is_measured_arrays(self.handle)

    def push_back(self, LabelledControlArray1D value):
        _c_api.LabelledArraysLabelledControlArray1D_push_back(self.handle, value.handle if value is not None else <_c_api.LabelledControlArray1DHandle>0)

    def size(self, ):
        return _c_api.LabelledArraysLabelledControlArray1D_size(self.handle)

    def empty(self, ):
        return _c_api.LabelledArraysLabelledControlArray1D_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.LabelledArraysLabelledControlArray1D_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.LabelledArraysLabelledControlArray1D_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.LabelledControlArray1DHandle h_ret = _c_api.LabelledArraysLabelledControlArray1D_at(self.handle, idx)
        if h_ret == <_c_api.LabelledControlArray1DHandle>0:
            return None
        return _labelled_control_array1_d_from_capi(h_ret, owned=False)

    def contains(self, LabelledControlArray1D value):
        return _c_api.LabelledArraysLabelledControlArray1D_contains(self.handle, value.handle if value is not None else <_c_api.LabelledControlArray1DHandle>0)

    def index(self, LabelledControlArray1D value):
        return _c_api.LabelledArraysLabelledControlArray1D_index(self.handle, value.handle if value is not None else <_c_api.LabelledControlArray1DHandle>0)

    def intersection(self, LabelledArraysLabelledControlArray1D other):
        cdef _c_api.LabelledArraysLabelledControlArray1DHandle h_ret = _c_api.LabelledArraysLabelledControlArray1D_intersection(self.handle, other.handle if other is not None else <_c_api.LabelledArraysLabelledControlArray1DHandle>0)
        if h_ret == <_c_api.LabelledArraysLabelledControlArray1DHandle>0:
            return None
        return _labelled_arrays_labelled_control_array1_d_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledArraysLabelledControlArray1DHandle>self.handle))

    def equal(self, LabelledArraysLabelledControlArray1D other):
        return _c_api.LabelledArraysLabelledControlArray1D_equal(self.handle, other.handle if other is not None else <_c_api.LabelledArraysLabelledControlArray1DHandle>0)

    def __eq__(self, LabelledArraysLabelledControlArray1D other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, LabelledArraysLabelledControlArray1D other):
        return _c_api.LabelledArraysLabelledControlArray1D_not_equal(self.handle, other.handle if other is not None else <_c_api.LabelledArraysLabelledControlArray1DHandle>0)

    def __ne__(self, LabelledArraysLabelledControlArray1D other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.LabelledArraysLabelledControlArray1D_to_json_string(self.handle)
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

cdef LabelledArraysLabelledControlArray1D _labelled_arrays_labelled_control_array1_d_from_capi(_c_api.LabelledArraysLabelledControlArray1DHandle h, bint owned=True):
    if h == <_c_api.LabelledArraysLabelledControlArray1DHandle>0:
        return None
    cdef LabelledArraysLabelledControlArray1D obj = LabelledArraysLabelledControlArray1D.__new__(LabelledArraysLabelledControlArray1D)
    obj.handle = h
    obj.owned = owned
    return obj
