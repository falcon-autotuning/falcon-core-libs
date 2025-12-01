cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport list_list_size_t

cdef class FArrayDouble:
    def __cinit__(self):
        self.handle = <_c_api.FArrayDoubleHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.FArrayDoubleHandle>0 and self.owned:
            _c_api.FArrayDouble_destroy(self.handle)
        self.handle = <_c_api.FArrayDoubleHandle>0


cdef FArrayDouble _f_array_double_from_capi(_c_api.FArrayDoubleHandle h):
    if h == <_c_api.FArrayDoubleHandle>0:
        return None
    cdef FArrayDouble obj = FArrayDouble.__new__(FArrayDouble)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, size_t shape, size_t ndim):
        cdef _c_api.FArrayDoubleHandle h
        h = _c_api.FArrayDouble_create_empty(shape, ndim)
        if h == <_c_api.FArrayDoubleHandle>0:
            raise MemoryError("Failed to create FArrayDouble")
        cdef FArrayDouble obj = <FArrayDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def zeros(cls, size_t shape, size_t ndim):
        cdef _c_api.FArrayDoubleHandle h
        h = _c_api.FArrayDouble_create_zeros(shape, ndim)
        if h == <_c_api.FArrayDoubleHandle>0:
            raise MemoryError("Failed to create FArrayDouble")
        cdef FArrayDouble obj = <FArrayDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.FArrayDoubleHandle h
        try:
            h = _c_api.FArrayDouble_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.FArrayDoubleHandle>0:
            raise MemoryError("Failed to create FArrayDouble")
        cdef FArrayDouble obj = <FArrayDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def from_shape(size_t shape, size_t ndim):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_from_shape(shape, ndim)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    @staticmethod
    def from_data(double data, size_t shape, size_t ndim):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_from_data(data, shape, ndim)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def size(self, ):
        return _c_api.FArrayDouble_size(self.handle)

    def dimension(self, ):
        return _c_api.FArrayDouble_dimension(self.handle)

    def shape(self, size_t out_buffer, size_t ndim):
        return _c_api.FArrayDouble_shape(self.handle, out_buffer, ndim)

    def data(self, double out_buffer, size_t numdata):
        return _c_api.FArrayDouble_data(self.handle, out_buffer, numdata)

    def plusequals_farray(self, FArrayDouble other):
        _c_api.FArrayDouble_plusequals_farray(self.handle, other.handle)

    def plusequals_double(self, double other):
        _c_api.FArrayDouble_plusequals_double(self.handle, other)

    def plusequals_int(self, int other):
        _c_api.FArrayDouble_plusequals_int(self.handle, other)

    def plus_farray(self, FArrayDouble other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_plus_farray(self.handle, other.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def plus_double(self, double other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_plus_double(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def plus_int(self, int other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_plus_int(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def minusequals_farray(self, FArrayDouble other):
        _c_api.FArrayDouble_minusequals_farray(self.handle, other.handle)

    def minusequals_double(self, double other):
        _c_api.FArrayDouble_minusequals_double(self.handle, other)

    def minusequals_int(self, int other):
        _c_api.FArrayDouble_minusequals_int(self.handle, other)

    def minus_farray(self, FArrayDouble other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_minus_farray(self.handle, other.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def minus_double(self, double other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_minus_double(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def minus_int(self, int other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_minus_int(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def negation(self, ):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_negation(self.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def __neg__(self):
        return self.negation()

    def timesequals_farray(self, FArrayDouble other):
        _c_api.FArrayDouble_timesequals_farray(self.handle, other.handle)

    def timesequals_double(self, double other):
        _c_api.FArrayDouble_timesequals_double(self.handle, other)

    def timesequals_int(self, int other):
        _c_api.FArrayDouble_timesequals_int(self.handle, other)

    def times_farray(self, FArrayDouble other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_times_farray(self.handle, other.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def times_double(self, double other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_times_double(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def times_int(self, int other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_times_int(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def dividesequals_farray(self, FArrayDouble other):
        _c_api.FArrayDouble_dividesequals_farray(self.handle, other.handle)

    def dividesequals_double(self, double other):
        _c_api.FArrayDouble_dividesequals_double(self.handle, other)

    def dividesequals_int(self, int other):
        _c_api.FArrayDouble_dividesequals_int(self.handle, other)

    def divides_farray(self, FArrayDouble other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_divides_farray(self.handle, other.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def divides_double(self, double other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_divides_double(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def divides_int(self, int other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_divides_int(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def pow(self, double other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_pow(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def double_pow(self, double other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_double_pow(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def pow_inplace(self, double other):
        _c_api.FArrayDouble_pow_inplace(self.handle, other)

    def abs(self, ):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_abs(self.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def min(self, ):
        return _c_api.FArrayDouble_min(self.handle)

    def min_arraywise(self, FArrayDouble other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_min_arraywise(self.handle, other.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def max(self, ):
        return _c_api.FArrayDouble_max(self.handle)

    def max_arraywise(self, FArrayDouble other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_max_arraywise(self.handle, other.handle)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def equality(self, FArrayDouble other):
        return _c_api.FArrayDouble_equality(self.handle, other.handle)

    def notequality(self, FArrayDouble other):
        return _c_api.FArrayDouble_notequality(self.handle, other.handle)

    def greaterthan(self, double value):
        return _c_api.FArrayDouble_greaterthan(self.handle, value)

    def lessthan(self, double value):
        return _c_api.FArrayDouble_lessthan(self.handle, value)

    def remove_offset(self, double offset):
        _c_api.FArrayDouble_remove_offset(self.handle, offset)

    def sum(self, ):
        return _c_api.FArrayDouble_sum(self.handle)

    def reshape(self, size_t shape, size_t ndims):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_reshape(self.handle, shape, ndims)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def where(self, double value):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.FArrayDouble_where(self.handle, value)
        if h_ret == <_c_api.ListListSizeTHandle>0:
            return None
        return list_list_size_t._list_list_size_t_from_capi(h_ret)

    def flip(self, size_t axis):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_flip(self.handle, axis)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def full_gradient(self, FArrayDouble out_buffer, size_t buffer_size):
        return _c_api.FArrayDouble_full_gradient(self.handle, out_buffer.handle, buffer_size)

    def gradient(self, size_t axis):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayDouble_gradient(self.handle, axis)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def get_sum_of_squares(self, ):
        return _c_api.FArrayDouble_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, int other):
        return _c_api.FArrayDouble_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, double other):
        return _c_api.FArrayDouble_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, FArrayDouble other):
        return _c_api.FArrayDouble_get_summed_diff_array_of_squares(self.handle, other.handle)
