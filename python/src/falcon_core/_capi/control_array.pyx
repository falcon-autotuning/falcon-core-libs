# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .f_array_double cimport FArrayDouble
from .list_list_size_t cimport ListListSizeT

cdef class ControlArray:
    cdef c_api.ControlArrayHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ControlArrayHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ControlArrayHandle>0 and self.owned:
            c_api.ControlArray_destroy(self.handle)
        self.handle = <c_api.ControlArrayHandle>0

    cdef ControlArray from_capi(cls, c_api.ControlArrayHandle h):
        cdef ControlArray obj = <ControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ControlArrayHandle h
        try:
            h = c_api.ControlArray_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ControlArrayHandle>0:
            raise MemoryError("Failed to create ControlArray")
        cdef ControlArray obj = <ControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def from_data(data, shape, ndim):
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_from_data(data, shape, ndim)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    @staticmethod
    def from_farray(farray):
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_from_farray(<c_api.FArrayDoubleHandle>farray.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def size(self):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_size(self.handle)

    def dimension(self):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_dimension(self.handle)

    def shape(self, out_buffer, ndim):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_shape(self.handle, out_buffer, ndim)

    def data(self, out_buffer, numdata):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_data(self.handle, out_buffer, numdata)

    def plusequals_farray(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_plusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def plusequals_double(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_plusequals_double(self.handle, other)

    def plusequals_int(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_plusequals_int(self.handle, other)

    def plus_control_array(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_plus_control_array(self.handle, <c_api.ControlArrayHandle>other.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def plus_farray(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_plus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def plus_double(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_plus_double(self.handle, other)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def plus_int(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_plus_int(self.handle, other)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def minusequals_farray(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_minusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def minusequals_double(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_minusequals_double(self.handle, other)

    def minusequals_int(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_minusequals_int(self.handle, other)

    def minus_control_array(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_minus_control_array(self.handle, <c_api.ControlArrayHandle>other.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def minus_farray(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_minus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def minus_double(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_minus_double(self.handle, other)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def minus_int(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_minus_int(self.handle, other)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def negation(self):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_negation(self.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def __neg__(self):
        return self.negation()

    def timesequals_double(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_timesequals_double(self.handle, other)

    def timesequals_int(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_timesequals_int(self.handle, other)

    def times_double(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_times_double(self.handle, other)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def times_int(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_times_int(self.handle, other)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def dividesequals_double(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_dividesequals_double(self.handle, other)

    def dividesequals_int(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_dividesequals_int(self.handle, other)

    def divides_double(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_divides_double(self.handle, other)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def divides_int(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_divides_int(self.handle, other)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def pow(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_pow(self.handle, other)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def abs(self):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_abs(self.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def min_farray(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_min_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def min_control_array(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_min_control_array(self.handle, <c_api.ControlArrayHandle>other.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def max_farray(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_max_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def max_control_array(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_max_control_array(self.handle, <c_api.ControlArrayHandle>other.handle)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def equality(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_equality(self.handle, <c_api.ControlArrayHandle>other.handle)

    def notequality(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_notequality(self.handle, <c_api.ControlArrayHandle>other.handle)

    def greaterthan(self, value):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_greaterthan(self.handle, value)

    def lessthan(self, value):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_lessthan(self.handle, value)

    def remove_offset(self, offset):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray_remove_offset(self.handle, offset)

    def sum(self):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_sum(self.handle)

    def where(self, value):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListListSizeTHandle h_ret
        h_ret = c_api.ControlArray_where(self.handle, value)
        if h_ret == <c_api.ListListSizeTHandle>0:
            return None
        return ListListSizeT.from_capi(ListListSizeT, h_ret)

    def flip(self, axis):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArrayHandle h_ret
        h_ret = c_api.ControlArray_flip(self.handle, axis)
        if h_ret == <c_api.ControlArrayHandle>0:
            return None
        return ControlArray.from_capi(ControlArray, h_ret)

    def full_gradient(self, out_buffer, buffer_size):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_full_gradient(self.handle, <c_api.FArrayDoubleHandle>out_buffer.handle, buffer_size)

    def gradient(self, axis):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.FArrayDoubleHandle h_ret
        h_ret = c_api.ControlArray_gradient(self.handle, axis)
        if h_ret == <c_api.FArrayDoubleHandle>0:
            return None
        return FArrayDouble.from_capi(FArrayDouble, h_ret)

    def get_sum_of_squares(self):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, other):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray_get_summed_diff_array_of_squares(self.handle, <c_api.ControlArrayHandle>other.handle)

    def to_json_string(self):
        if self.handle == <c_api.ControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ControlArray_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ControlArray _controlarray_from_capi(c_api.ControlArrayHandle h):
    cdef ControlArray obj = <ControlArray>ControlArray.__new__(ControlArray)
    obj.handle = h