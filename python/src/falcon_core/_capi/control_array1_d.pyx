# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .f_array_double cimport FArrayDouble
from .list_f_array_double cimport ListFArrayDouble
from .list_list_size_t cimport ListListSizeT

cdef class ControlArray1D:
    cdef c_api.ControlArray1DHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.ControlArray1DHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.ControlArray1DHandle>0 and self.owned:
            c_api.ControlArray1D_destroy(self.handle)
        self.handle = <c_api.ControlArray1DHandle>0

    cdef ControlArray1D from_capi(cls, c_api.ControlArray1DHandle h):
        cdef ControlArray1D obj = <ControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.ControlArray1DHandle h
        try:
            h = c_api.ControlArray1D_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.ControlArray1DHandle>0:
            raise MemoryError("Failed to create ControlArray1D")
        cdef ControlArray1D obj = <ControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def from_data(data, shape, ndim):
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_from_data(data, shape, ndim)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    @staticmethod
    def from_farray(farray):
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_from_farray(<c_api.FArrayDoubleHandle>farray.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def is_1D(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_is_1D(self.handle)

    def as_1D(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.FArrayDoubleHandle h_ret
        h_ret = c_api.ControlArray1D_as_1D(self.handle)
        if h_ret == <c_api.FArrayDoubleHandle>0:
            return None
        return FArrayDouble.from_capi(FArrayDouble, h_ret)

    def get_start(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_start(self.handle)

    def get_end(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_end(self.handle)

    def is_decreasing(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_is_decreasing(self.handle)

    def is_increasing(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_is_increasing(self.handle)

    def get_distance(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_distance(self.handle)

    def get_mean(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_mean(self.handle)

    def get_std(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_std(self.handle)

    def reverse(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_reverse(self.handle)

    def get_closest_index(self, value):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_closest_index(self.handle, value)

    def even_divisions(self, divisions):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListFArrayDoubleHandle h_ret
        h_ret = c_api.ControlArray1D_even_divisions(self.handle, divisions)
        if h_ret == <c_api.ListFArrayDoubleHandle>0:
            return None
        return ListFArrayDouble.from_capi(ListFArrayDouble, h_ret)

    def size(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_size(self.handle)

    def dimension(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_dimension(self.handle)

    def shape(self, out_buffer, ndim):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_shape(self.handle, out_buffer, ndim)

    def data(self, out_buffer, numdata):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_data(self.handle, out_buffer, numdata)

    def plusequals_farray(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_plusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def plusequals_double(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_plusequals_double(self.handle, other)

    def plusequals_int(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_plusequals_int(self.handle, other)

    def plus_control_array(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_plus_control_array(self.handle, <c_api.ControlArray1DHandle>other.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def plus_farray(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_plus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def plus_double(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_plus_double(self.handle, other)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def plus_int(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_plus_int(self.handle, other)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def minusequals_farray(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_minusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def minusequals_double(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_minusequals_double(self.handle, other)

    def minusequals_int(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_minusequals_int(self.handle, other)

    def minus_control_array(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_minus_control_array(self.handle, <c_api.ControlArray1DHandle>other.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def minus_farray(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_minus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def minus_double(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_minus_double(self.handle, other)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def minus_int(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_minus_int(self.handle, other)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def negation(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_negation(self.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def __neg__(self):
        return self.negation()

    def timesequals_double(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_timesequals_double(self.handle, other)

    def timesequals_int(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_timesequals_int(self.handle, other)

    def times_double(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_times_double(self.handle, other)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def times_int(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_times_int(self.handle, other)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def dividesequals_double(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_dividesequals_double(self.handle, other)

    def dividesequals_int(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_dividesequals_int(self.handle, other)

    def divides_double(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_divides_double(self.handle, other)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def divides_int(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_divides_int(self.handle, other)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def pow(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_pow(self.handle, other)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def abs(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_abs(self.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def min_farray(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_min_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def min_control_array(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_min_control_array(self.handle, <c_api.ControlArray1DHandle>other.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def max_farray(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_max_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def max_control_array(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_max_control_array(self.handle, <c_api.ControlArray1DHandle>other.handle)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def equality(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_equality(self.handle, <c_api.ControlArray1DHandle>other.handle)

    def notequality(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_notequality(self.handle, <c_api.ControlArray1DHandle>other.handle)

    def greaterthan(self, value):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_greaterthan(self.handle, value)

    def lessthan(self, value):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_lessthan(self.handle, value)

    def remove_offset(self, offset):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.ControlArray1D_remove_offset(self.handle, offset)

    def sum(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_sum(self.handle)

    def where(self, value):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListListSizeTHandle h_ret
        h_ret = c_api.ControlArray1D_where(self.handle, value)
        if h_ret == <c_api.ListListSizeTHandle>0:
            return None
        return ListListSizeT.from_capi(ListListSizeT, h_ret)

    def flip(self, axis):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ControlArray1DHandle h_ret
        h_ret = c_api.ControlArray1D_flip(self.handle, axis)
        if h_ret == <c_api.ControlArray1DHandle>0:
            return None
        return ControlArray1D.from_capi(ControlArray1D, h_ret)

    def full_gradient(self, out_buffer, buffer_size):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_full_gradient(self.handle, <c_api.FArrayDoubleHandle>out_buffer.handle, buffer_size)

    def gradient(self, axis):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.FArrayDoubleHandle h_ret
        h_ret = c_api.ControlArray1D_gradient(self.handle, axis)
        if h_ret == <c_api.FArrayDoubleHandle>0:
            return None
        return FArrayDouble.from_capi(FArrayDouble, h_ret)

    def get_sum_of_squares(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, other):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.ControlArray1D_get_summed_diff_array_of_squares(self.handle, <c_api.ControlArray1DHandle>other.handle)

    def to_json_string(self):
        if self.handle == <c_api.ControlArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.ControlArray1D_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef ControlArray1D _controlarray1d_from_capi(c_api.ControlArray1DHandle h):
    cdef ControlArray1D obj = <ControlArray1D>ControlArray1D.__new__(ControlArray1D)
    obj.handle = h