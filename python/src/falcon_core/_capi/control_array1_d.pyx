cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport f_array_double
from . cimport list_f_array_double
from . cimport list_list_size_t

cdef class ControlArray1D:
    def __cinit__(self):
        self.handle = <_c_api.ControlArray1DHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ControlArray1DHandle>0 and self.owned:
            _c_api.ControlArray1D_destroy(self.handle)
        self.handle = <_c_api.ControlArray1DHandle>0


cdef ControlArray1D _control_array1_d_from_capi(_c_api.ControlArray1DHandle h):
    if h == <_c_api.ControlArray1DHandle>0:
        return None
    cdef ControlArray1D obj = ControlArray1D.__new__(ControlArray1D)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ControlArray1DHandle h
        try:
            h = _c_api.ControlArray1D_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ControlArray1DHandle>0:
            raise MemoryError("Failed to create ControlArray1D")
        cdef ControlArray1D obj = <ControlArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def from_data(double data, size_t shape, size_t ndim):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_from_data(data, shape, ndim)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    @staticmethod
    def from_farray(FArrayDouble farray):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_from_farray(farray.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def is_1D(self, ):
        return _c_api.ControlArray1D_is_1D(self.handle)

    def as_1D(self, ):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.ControlArray1D_as_1D(self.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def get_start(self, ):
        return _c_api.ControlArray1D_get_start(self.handle)

    def get_end(self, ):
        return _c_api.ControlArray1D_get_end(self.handle)

    def is_decreasing(self, ):
        return _c_api.ControlArray1D_is_decreasing(self.handle)

    def is_increasing(self, ):
        return _c_api.ControlArray1D_is_increasing(self.handle)

    def get_distance(self, ):
        return _c_api.ControlArray1D_get_distance(self.handle)

    def get_mean(self, ):
        return _c_api.ControlArray1D_get_mean(self.handle)

    def get_std(self, ):
        return _c_api.ControlArray1D_get_std(self.handle)

    def reverse(self, ):
        _c_api.ControlArray1D_reverse(self.handle)

    def get_closest_index(self, double value):
        return _c_api.ControlArray1D_get_closest_index(self.handle, value)

    def even_divisions(self, size_t divisions):
        cdef _c_api.ListFArrayDoubleHandle h_ret = _c_api.ControlArray1D_even_divisions(self.handle, divisions)
        if h_ret == <_c_api.ListFArrayDoubleHandle>0:
            return None
        return list_f_array_double._list_f_array_double_from_capi(h_ret)

    def size(self, ):
        return _c_api.ControlArray1D_size(self.handle)

    def dimension(self, ):
        return _c_api.ControlArray1D_dimension(self.handle)

    def shape(self, size_t out_buffer, size_t ndim):
        return _c_api.ControlArray1D_shape(self.handle, out_buffer, ndim)

    def data(self, double out_buffer, size_t numdata):
        return _c_api.ControlArray1D_data(self.handle, out_buffer, numdata)

    def plusequals_farray(self, FArrayDouble other):
        _c_api.ControlArray1D_plusequals_farray(self.handle, other.handle)

    def plusequals_double(self, double other):
        _c_api.ControlArray1D_plusequals_double(self.handle, other)

    def plusequals_int(self, int other):
        _c_api.ControlArray1D_plusequals_int(self.handle, other)

    def plus_control_array(self, ControlArray1D other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_plus_control_array(self.handle, other.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def plus_farray(self, FArrayDouble other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_plus_farray(self.handle, other.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def plus_double(self, double other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_plus_double(self.handle, other)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def plus_int(self, int other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_plus_int(self.handle, other)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def minusequals_farray(self, FArrayDouble other):
        _c_api.ControlArray1D_minusequals_farray(self.handle, other.handle)

    def minusequals_double(self, double other):
        _c_api.ControlArray1D_minusequals_double(self.handle, other)

    def minusequals_int(self, int other):
        _c_api.ControlArray1D_minusequals_int(self.handle, other)

    def minus_control_array(self, ControlArray1D other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_minus_control_array(self.handle, other.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def minus_farray(self, FArrayDouble other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_minus_farray(self.handle, other.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def minus_double(self, double other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_minus_double(self.handle, other)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def minus_int(self, int other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_minus_int(self.handle, other)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def negation(self, ):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_negation(self.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def __neg__(self):
        return self.negation()

    def timesequals_double(self, double other):
        _c_api.ControlArray1D_timesequals_double(self.handle, other)

    def timesequals_int(self, int other):
        _c_api.ControlArray1D_timesequals_int(self.handle, other)

    def times_double(self, double other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_times_double(self.handle, other)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def times_int(self, int other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_times_int(self.handle, other)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def dividesequals_double(self, double other):
        _c_api.ControlArray1D_dividesequals_double(self.handle, other)

    def dividesequals_int(self, int other):
        _c_api.ControlArray1D_dividesequals_int(self.handle, other)

    def divides_double(self, double other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_divides_double(self.handle, other)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def divides_int(self, int other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_divides_int(self.handle, other)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def pow(self, double other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_pow(self.handle, other)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def abs(self, ):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_abs(self.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def min_farray(self, FArrayDouble other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_min_farray(self.handle, other.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def min_control_array(self, ControlArray1D other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_min_control_array(self.handle, other.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def max_farray(self, FArrayDouble other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_max_farray(self.handle, other.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def max_control_array(self, ControlArray1D other):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_max_control_array(self.handle, other.handle)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def equality(self, ControlArray1D other):
        return _c_api.ControlArray1D_equality(self.handle, other.handle)

    def notequality(self, ControlArray1D other):
        return _c_api.ControlArray1D_notequality(self.handle, other.handle)

    def greaterthan(self, double value):
        return _c_api.ControlArray1D_greaterthan(self.handle, value)

    def lessthan(self, double value):
        return _c_api.ControlArray1D_lessthan(self.handle, value)

    def remove_offset(self, double offset):
        _c_api.ControlArray1D_remove_offset(self.handle, offset)

    def sum(self, ):
        return _c_api.ControlArray1D_sum(self.handle)

    def where(self, double value):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.ControlArray1D_where(self.handle, value)
        if h_ret == <_c_api.ListListSizeTHandle>0:
            return None
        return list_list_size_t._list_list_size_t_from_capi(h_ret)

    def flip(self, size_t axis):
        cdef _c_api.ControlArray1DHandle h_ret = _c_api.ControlArray1D_flip(self.handle, axis)
        if h_ret == <_c_api.ControlArray1DHandle>0:
            return None
        return _control_array1_d_from_capi(h_ret)

    def full_gradient(self, FArrayDouble out_buffer, size_t buffer_size):
        return _c_api.ControlArray1D_full_gradient(self.handle, out_buffer.handle, buffer_size)

    def gradient(self, size_t axis):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.ControlArray1D_gradient(self.handle, axis)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def get_sum_of_squares(self, ):
        return _c_api.ControlArray1D_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, int other):
        return _c_api.ControlArray1D_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, double other):
        return _c_api.ControlArray1D_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, ControlArray1D other):
        return _c_api.ControlArray1D_get_summed_diff_array_of_squares(self.handle, other.handle)
