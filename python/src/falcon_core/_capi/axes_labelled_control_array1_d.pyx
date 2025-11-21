# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .labelled_control_array1_d cimport LabelledControlArray1D
from .list_labelled_control_array1_d cimport ListLabelledControlArray1D

cdef class AxesLabelledControlArray1D:
    cdef c_api.AxesLabelledControlArray1DHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.AxesLabelledControlArray1DHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.AxesLabelledControlArray1DHandle>0 and self.owned:
            c_api.AxesLabelledControlArray1D_destroy(self.handle)
        self.handle = <c_api.AxesLabelledControlArray1DHandle>0

    cdef AxesLabelledControlArray1D from_capi(cls, c_api.AxesLabelledControlArray1DHandle h):
        cdef AxesLabelledControlArray1D obj = <AxesLabelledControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.AxesLabelledControlArray1DHandle h
        h = c_api.AxesLabelledControlArray1D_create_empty()
        if h == <c_api.AxesLabelledControlArray1DHandle>0:
            raise MemoryError("Failed to create AxesLabelledControlArray1D")
        cdef AxesLabelledControlArray1D obj = <AxesLabelledControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_raw(cls, data, count):
        cdef c_api.AxesLabelledControlArray1DHandle h
        h = c_api.AxesLabelledControlArray1D_create_raw(<c_api.LabelledControlArray1DHandle>data.handle, count)
        if h == <c_api.AxesLabelledControlArray1DHandle>0:
            raise MemoryError("Failed to create AxesLabelledControlArray1D")
        cdef AxesLabelledControlArray1D obj = <AxesLabelledControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, data):
        cdef c_api.AxesLabelledControlArray1DHandle h
        h = c_api.AxesLabelledControlArray1D_create(<c_api.ListLabelledControlArray1DHandle>data.handle)
        if h == <c_api.AxesLabelledControlArray1DHandle>0:
            raise MemoryError("Failed to create AxesLabelledControlArray1D")
        cdef AxesLabelledControlArray1D obj = <AxesLabelledControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.AxesLabelledControlArray1DHandle h
        try:
            h = c_api.AxesLabelledControlArray1D_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.AxesLabelledControlArray1DHandle>0:
            raise MemoryError("Failed to create AxesLabelledControlArray1D")
        cdef AxesLabelledControlArray1D obj = <AxesLabelledControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def push_back(self, value):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesLabelledControlArray1D_push_back(self.handle, <c_api.LabelledControlArray1DHandle>value.handle)

    def size(self):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesLabelledControlArray1D_size(self.handle)

    def empty(self):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesLabelledControlArray1D_empty(self.handle)

    def erase_at(self, idx):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesLabelledControlArray1D_erase_at(self.handle, idx)

    def clear(self):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.AxesLabelledControlArray1D_clear(self.handle)

    def at(self, idx):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArray1DHandle h_ret
        h_ret = c_api.AxesLabelledControlArray1D_at(self.handle, idx)
        if h_ret == <c_api.LabelledControlArray1DHandle>0:
            return None
        return LabelledControlArray1D.from_capi(LabelledControlArray1D, h_ret)

    def items(self, out_buffer, buffer_size):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesLabelledControlArray1D_items(self.handle, <c_api.LabelledControlArray1DHandle>out_buffer.handle, buffer_size)

    def contains(self, value):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesLabelledControlArray1D_contains(self.handle, <c_api.LabelledControlArray1DHandle>value.handle)

    def index(self, value):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesLabelledControlArray1D_index(self.handle, <c_api.LabelledControlArray1DHandle>value.handle)

    def intersection(self, other):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesLabelledControlArray1DHandle h_ret
        h_ret = c_api.AxesLabelledControlArray1D_intersection(self.handle, <c_api.AxesLabelledControlArray1DHandle>other.handle)
        if h_ret == <c_api.AxesLabelledControlArray1DHandle>0:
            return None
        return AxesLabelledControlArray1D.from_capi(AxesLabelledControlArray1D, h_ret)

    def equal(self, b):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesLabelledControlArray1D_equal(self.handle, <c_api.AxesLabelledControlArray1DHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AxesLabelledControlArray1D_not_equal(self.handle, <c_api.AxesLabelledControlArray1DHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.AxesLabelledControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.AxesLabelledControlArray1D_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef AxesLabelledControlArray1D _axeslabelledcontrolarray1d_from_capi(c_api.AxesLabelledControlArray1DHandle h):
    cdef AxesLabelledControlArray1D obj = <AxesLabelledControlArray1D>AxesLabelledControlArray1D.__new__(AxesLabelledControlArray1D)
    obj.handle = h