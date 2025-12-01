cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport f_array_double
from . cimport list_list_size_t

cdef class FArrayInt:
    def __cinit__(self):
        self.handle = <_c_api.FArrayIntHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.FArrayIntHandle>0 and self.owned:
            _c_api.FArrayInt_destroy(self.handle)
        self.handle = <_c_api.FArrayIntHandle>0


cdef FArrayInt _f_array_int_from_capi(_c_api.FArrayIntHandle h):
    if h == <_c_api.FArrayIntHandle>0:
        return None
    cdef FArrayInt obj = FArrayInt.__new__(FArrayInt)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, size_t shape, size_t ndim):
        cdef _c_api.FArrayIntHandle h
        h = _c_api.FArrayInt_create_empty(shape, ndim)
        if h == <_c_api.FArrayIntHandle>0:
            raise MemoryError("Failed to create FArrayInt")
        cdef FArrayInt obj = <FArrayInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def zeros(cls, size_t shape, size_t ndim):
        cdef _c_api.FArrayIntHandle h
        h = _c_api.FArrayInt_create_zeros(shape, ndim)
        if h == <_c_api.FArrayIntHandle>0:
            raise MemoryError("Failed to create FArrayInt")
        cdef FArrayInt obj = <FArrayInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.FArrayIntHandle h
        try:
            h = _c_api.FArrayInt_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.FArrayIntHandle>0:
            raise MemoryError("Failed to create FArrayInt")
        cdef FArrayInt obj = <FArrayInt>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def from_shape(size_t shape, size_t ndim):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_from_shape(shape, ndim)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    @staticmethod
    def from_data(int data, size_t shape, size_t ndim):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_from_data(data, shape, ndim)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def size(self, ):
        return _c_api.FArrayInt_size(self.handle)

    def dimension(self, ):
        return _c_api.FArrayInt_dimension(self.handle)

    def shape(self, size_t out_buffer, size_t ndim):
        return _c_api.FArrayInt_shape(self.handle, out_buffer, ndim)

    def data(self, int out_buffer, size_t numdata):
        return _c_api.FArrayInt_data(self.handle, out_buffer, numdata)

    def plusequals_farray(self, FArrayInt other):
        _c_api.FArrayInt_plusequals_farray(self.handle, other.handle)

    def plusequals_double(self, double other):
        _c_api.FArrayInt_plusequals_double(self.handle, other)

    def plusequals_int(self, int other):
        _c_api.FArrayInt_plusequals_int(self.handle, other)

    def plus_farray(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_plus_farray(self.handle, other.handle)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def plus_double(self, double other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_plus_double(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def plus_int(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_plus_int(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def minusequals_farray(self, FArrayInt other):
        _c_api.FArrayInt_minusequals_farray(self.handle, other.handle)

    def minusequals_double(self, double other):
        _c_api.FArrayInt_minusequals_double(self.handle, other)

    def minusequals_int(self, int other):
        _c_api.FArrayInt_minusequals_int(self.handle, other)

    def minus_farray(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_minus_farray(self.handle, other.handle)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def minus_double(self, double other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_minus_double(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def minus_int(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_minus_int(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def negation(self, ):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_negation(self.handle)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def __neg__(self):
        return self.negation()

    def timesequals_farray(self, FArrayInt other):
        _c_api.FArrayInt_timesequals_farray(self.handle, other.handle)

    def timesequals_double(self, double other):
        _c_api.FArrayInt_timesequals_double(self.handle, other)

    def timesequals_int(self, int other):
        _c_api.FArrayInt_timesequals_int(self.handle, other)

    def times_farray(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_times_farray(self.handle, other.handle)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def times_double(self, double other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_times_double(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def times_int(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_times_int(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def dividesequals_farray(self, FArrayInt other):
        _c_api.FArrayInt_dividesequals_farray(self.handle, other.handle)

    def dividesequals_double(self, double other):
        _c_api.FArrayInt_dividesequals_double(self.handle, other)

    def dividesequals_int(self, int other):
        _c_api.FArrayInt_dividesequals_int(self.handle, other)

    def divides_farray(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_divides_farray(self.handle, other.handle)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def divides_double(self, double other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_divides_double(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def divides_int(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_divides_int(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def pow(self, int other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_pow(self.handle, other)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def double_pow(self, double other):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.FArrayInt_double_pow(self.handle, other)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def pow_inplace(self, int other):
        _c_api.FArrayInt_pow_inplace(self.handle, other)

    def abs(self, ):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_abs(self.handle)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def min(self, ):
        return _c_api.FArrayInt_min(self.handle)

    def min_arraywise(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_min_arraywise(self.handle, other.handle)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def max(self, ):
        return _c_api.FArrayInt_max(self.handle)

    def max_arraywise(self, FArrayInt other):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_max_arraywise(self.handle, other.handle)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def equality(self, FArrayInt other):
        return _c_api.FArrayInt_equality(self.handle, other.handle)

    def notequality(self, FArrayInt other):
        return _c_api.FArrayInt_notequality(self.handle, other.handle)

    def greaterthan(self, int value):
        return _c_api.FArrayInt_greaterthan(self.handle, value)

    def lessthan(self, int value):
        return _c_api.FArrayInt_lessthan(self.handle, value)

    def remove_offset(self, int offset):
        _c_api.FArrayInt_remove_offset(self.handle, offset)

    def sum(self, ):
        return _c_api.FArrayInt_sum(self.handle)

    def reshape(self, size_t shape, size_t ndims):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_reshape(self.handle, shape, ndims)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def where(self, int value):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.FArrayInt_where(self.handle, value)
        if h_ret == <_c_api.ListListSizeTHandle>0:
            return None
        return list_list_size_t._list_list_size_t_from_capi(h_ret)

    def flip(self, size_t axis):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_flip(self.handle, axis)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def full_gradient(self, FArrayInt out_buffer, size_t buffer_size):
        return _c_api.FArrayInt_full_gradient(self.handle, out_buffer.handle, buffer_size)

    def gradient(self, size_t axis):
        cdef _c_api.FArrayIntHandle h_ret = _c_api.FArrayInt_gradient(self.handle, axis)
        if h_ret == <_c_api.FArrayIntHandle>0:
            return None
        return _f_array_int_from_capi(h_ret)

    def get_sum_of_squares(self, ):
        return _c_api.FArrayInt_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, int other):
        return _c_api.FArrayInt_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, double other):
        return _c_api.FArrayInt_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, FArrayInt other):
        return _c_api.FArrayInt_get_summed_diff_array_of_squares(self.handle, other.handle)
