# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .f_array_double cimport FArrayDouble
from .list_list_size_t cimport ListListSizeT

cdef class MeasuredArray:
    cdef c_api.MeasuredArrayHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MeasuredArrayHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MeasuredArrayHandle>0 and self.owned:
            c_api.MeasuredArray_destroy(self.handle)
        self.handle = <c_api.MeasuredArrayHandle>0

    cdef MeasuredArray from_capi(cls, c_api.MeasuredArrayHandle h):
        cdef MeasuredArray obj = <MeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MeasuredArrayHandle h
        try:
            h = c_api.MeasuredArray_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MeasuredArrayHandle>0:
            raise MemoryError("Failed to create MeasuredArray")
        cdef MeasuredArray obj = <MeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def from_data(data, shape, ndim):
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_from_data(data, shape, ndim)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    @staticmethod
    def from_farray(farray):
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_from_farray(<c_api.FArrayDoubleHandle>farray.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def size(self):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_size(self.handle)

    def dimension(self):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_dimension(self.handle)

    def shape(self, out_buffer, ndim):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_shape(self.handle, out_buffer, ndim)

    def data(self, out_buffer, numdata):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_data(self.handle, out_buffer, numdata)

    def plusequals_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_plusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def plusequals_double(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_plusequals_double(self.handle, other)

    def plusequals_int(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_plusequals_int(self.handle, other)

    def plus_measured_array(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_plus_measured_array(self.handle, <c_api.MeasuredArrayHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def plus_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_plus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def plus_double(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_plus_double(self.handle, other)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def plus_int(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_plus_int(self.handle, other)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def minusequals_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_minusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def minusequals_double(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_minusequals_double(self.handle, other)

    def minusequals_int(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_minusequals_int(self.handle, other)

    def minus_measured_array(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_minus_measured_array(self.handle, <c_api.MeasuredArrayHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def minus_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_minus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def minus_double(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_minus_double(self.handle, other)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def minus_int(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_minus_int(self.handle, other)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def negation(self):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_negation(self.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def __neg__(self):
        return self.negation()

    def timesequals_measured_array(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_timesequals_measured_array(self.handle, <c_api.MeasuredArrayHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def timesequals_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_timesequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def timesequals_double(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_timesequals_double(self.handle, other)

    def timesequals_int(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_timesequals_int(self.handle, other)

    def times_measured_array(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_times_measured_array(self.handle, <c_api.MeasuredArrayHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def times_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_times_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def times_double(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_times_double(self.handle, other)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def times_int(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_times_int(self.handle, other)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def dividesequals_measured_array(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_dividesequals_measured_array(self.handle, <c_api.MeasuredArrayHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def dividesequals_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_dividesequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def dividesequals_double(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_dividesequals_double(self.handle, other)

    def dividesequals_int(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_dividesequals_int(self.handle, other)

    def divides_measured_array(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_divides_measured_array(self.handle, <c_api.MeasuredArrayHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def divides_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_divides_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def divides_double(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_divides_double(self.handle, other)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def divides_int(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_divides_int(self.handle, other)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def pow(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_pow(self.handle, other)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def abs(self):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_abs(self.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def min_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_min_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def min_measured_array(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_min_measured_array(self.handle, <c_api.MeasuredArrayHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def max_farray(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_max_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def max_measured_array(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_max_measured_array(self.handle, <c_api.MeasuredArrayHandle>other.handle)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def equality(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_equality(self.handle, <c_api.MeasuredArrayHandle>other.handle)

    def notequality(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_notequality(self.handle, <c_api.MeasuredArrayHandle>other.handle)

    def greaterthan(self, value):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_greaterthan(self.handle, value)

    def lessthan(self, value):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_lessthan(self.handle, value)

    def remove_offset(self, offset):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.MeasuredArray_remove_offset(self.handle, offset)

    def sum(self):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_sum(self.handle)

    def reshape(self, shape, ndims):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_reshape(self.handle, shape, ndims)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def where(self, value):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListListSizeTHandle h_ret
        h_ret = c_api.MeasuredArray_where(self.handle, value)
        if h_ret == <c_api.ListListSizeTHandle>0:
            return None
        return ListListSizeT.from_capi(ListListSizeT, h_ret)

    def flip(self, axis):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_flip(self.handle, axis)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def full_gradient(self, out_buffer, buffer_size):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_full_gradient(self.handle, <c_api.MeasuredArrayHandle>out_buffer.handle, buffer_size)

    def gradient(self, axis):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasuredArrayHandle h_ret
        h_ret = c_api.MeasuredArray_gradient(self.handle, axis)
        if h_ret == <c_api.MeasuredArrayHandle>0:
            return None
        return MeasuredArray.from_capi(MeasuredArray, h_ret)

    def get_sum_of_squares(self):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, other):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasuredArray_get_summed_diff_array_of_squares(self.handle, <c_api.MeasuredArrayHandle>other.handle)

    def to_json_string(self):
        if self.handle == <c_api.MeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MeasuredArray_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MeasuredArray _measuredarray_from_capi(c_api.MeasuredArrayHandle h):
    cdef MeasuredArray obj = <MeasuredArray>MeasuredArray.__new__(MeasuredArray)
    obj.handle = h