cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport labelled_measured_array1_d

cdef class ListLabelledMeasuredArray1D:
    def __cinit__(self):
        self.handle = <_c_api.ListLabelledMeasuredArray1DHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ListLabelledMeasuredArray1DHandle>0 and self.owned:
            _c_api.ListLabelledMeasuredArray1D_destroy(self.handle)
        self.handle = <_c_api.ListLabelledMeasuredArray1DHandle>0


cdef ListLabelledMeasuredArray1D _list_labelled_measured_array1_d_from_capi(_c_api.ListLabelledMeasuredArray1DHandle h):
    if h == <_c_api.ListLabelledMeasuredArray1DHandle>0:
        return None
    cdef ListLabelledMeasuredArray1D obj = ListLabelledMeasuredArray1D.__new__(ListLabelledMeasuredArray1D)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.ListLabelledMeasuredArray1DHandle h
        h = _c_api.ListLabelledMeasuredArray1D_create_empty()
        if h == <_c_api.ListLabelledMeasuredArray1DHandle>0:
            raise MemoryError("Failed to create ListLabelledMeasuredArray1D")
        cdef ListLabelledMeasuredArray1D obj = <ListLabelledMeasuredArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, LabelledMeasuredArray1D data, size_t count):
        cdef _c_api.ListLabelledMeasuredArray1DHandle h
        h = _c_api.ListLabelledMeasuredArray1D_create(data.handle, count)
        if h == <_c_api.ListLabelledMeasuredArray1DHandle>0:
            raise MemoryError("Failed to create ListLabelledMeasuredArray1D")
        cdef ListLabelledMeasuredArray1D obj = <ListLabelledMeasuredArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ListLabelledMeasuredArray1DHandle h
        try:
            h = _c_api.ListLabelledMeasuredArray1D_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ListLabelledMeasuredArray1DHandle>0:
            raise MemoryError("Failed to create ListLabelledMeasuredArray1D")
        cdef ListLabelledMeasuredArray1D obj = <ListLabelledMeasuredArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def fill_value(size_t count, LabelledMeasuredArray1D value):
        cdef _c_api.ListLabelledMeasuredArray1DHandle h_ret = _c_api.ListLabelledMeasuredArray1D_fill_value(count, value.handle)
        if h_ret == <_c_api.ListLabelledMeasuredArray1DHandle>0:
            return None
        return _list_labelled_measured_array1_d_from_capi(h_ret)

    def push_back(self, LabelledMeasuredArray1D value):
        _c_api.ListLabelledMeasuredArray1D_push_back(self.handle, value.handle)

    def size(self, ):
        return _c_api.ListLabelledMeasuredArray1D_size(self.handle)

    def empty(self, ):
        return _c_api.ListLabelledMeasuredArray1D_empty(self.handle)

    def erase_at(self, size_t idx):
        _c_api.ListLabelledMeasuredArray1D_erase_at(self.handle, idx)

    def clear(self, ):
        _c_api.ListLabelledMeasuredArray1D_clear(self.handle)

    def at(self, size_t idx):
        cdef _c_api.LabelledMeasuredArray1DHandle h_ret = _c_api.ListLabelledMeasuredArray1D_at(self.handle, idx)
        if h_ret == <_c_api.LabelledMeasuredArray1DHandle>0:
            return None
        return labelled_measured_array1_d._labelled_measured_array1_d_from_capi(h_ret)

    def items(self, LabelledMeasuredArray1D out_buffer, size_t buffer_size):
        return _c_api.ListLabelledMeasuredArray1D_items(self.handle, out_buffer.handle, buffer_size)

    def contains(self, LabelledMeasuredArray1D value):
        return _c_api.ListLabelledMeasuredArray1D_contains(self.handle, value.handle)

    def index(self, LabelledMeasuredArray1D value):
        return _c_api.ListLabelledMeasuredArray1D_index(self.handle, value.handle)

    def intersection(self, ListLabelledMeasuredArray1D other):
        cdef _c_api.ListLabelledMeasuredArray1DHandle h_ret = _c_api.ListLabelledMeasuredArray1D_intersection(self.handle, other.handle)
        if h_ret == <_c_api.ListLabelledMeasuredArray1DHandle>0:
            return None
        return _list_labelled_measured_array1_d_from_capi(h_ret)

    def equal(self, ListLabelledMeasuredArray1D b):
        return _c_api.ListLabelledMeasuredArray1D_equal(self.handle, b.handle)

    def __eq__(self, ListLabelledMeasuredArray1D b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, ListLabelledMeasuredArray1D b):
        return _c_api.ListLabelledMeasuredArray1D_not_equal(self.handle, b.handle)

    def __ne__(self, ListLabelledMeasuredArray1D b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
