cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport acquisition_context
from . cimport connection
from . cimport control_array
from . cimport f_array_double
from . cimport list_list_size_t
from . cimport symbol_unit

cdef class LabelledControlArray:
    def __cinit__(self):
        self.handle = <_c_api.LabelledControlArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.LabelledControlArrayHandle>0 and self.owned:
            _c_api.LabelledControlArray_destroy(self.handle)
        self.handle = <_c_api.LabelledControlArrayHandle>0


cdef LabelledControlArray _labelled_control_array_from_capi(_c_api.LabelledControlArrayHandle h):
    if h == <_c_api.LabelledControlArrayHandle>0:
        return None
    cdef LabelledControlArray obj = LabelledControlArray.__new__(LabelledControlArray)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.LabelledControlArrayHandle h
        try:
            h = _c_api.LabelledControlArray_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.LabelledControlArrayHandle>0:
            raise MemoryError("Failed to create LabelledControlArray")
        cdef LabelledControlArray obj = <LabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def from_farray(FArrayDouble farray, AcquisitionContext label):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_from_farray(farray.handle, label.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    @staticmethod
    def from_control_array(ControlArray controlarray, AcquisitionContext label):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_from_control_array(controlarray.handle, label.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def label(self, ):
        cdef _c_api.AcquisitionContextHandle h_ret = _c_api.LabelledControlArray_label(self.handle)
        if h_ret == <_c_api.AcquisitionContextHandle>0:
            return None
        return acquisition_context._acquisition_context_from_capi(h_ret)

    def connection(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.LabelledControlArray_connection(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def instrument_type(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.LabelledControlArray_instrument_type(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def units(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.LabelledControlArray_units(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return symbol_unit._symbol_unit_from_capi(h_ret)

    def size(self, ):
        return _c_api.LabelledControlArray_size(self.handle)

    def dimension(self, ):
        return _c_api.LabelledControlArray_dimension(self.handle)

    def shape(self, size_t out_buffer, size_t ndim):
        return _c_api.LabelledControlArray_shape(self.handle, out_buffer, ndim)

    def data(self, double out_buffer, size_t numdata):
        return _c_api.LabelledControlArray_data(self.handle, out_buffer, numdata)

    def plusequals_farray(self, FArrayDouble other):
        _c_api.LabelledControlArray_plusequals_farray(self.handle, other.handle)

    def plusequals_double(self, double other):
        _c_api.LabelledControlArray_plusequals_double(self.handle, other)

    def plusequals_int(self, int other):
        _c_api.LabelledControlArray_plusequals_int(self.handle, other)

    def plus_control_array(self, LabelledControlArray other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_plus_control_array(self.handle, other.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def plus_farray(self, FArrayDouble other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_plus_farray(self.handle, other.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def plus_double(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_plus_double(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def plus_int(self, int other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_plus_int(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def minusequals_control_array(self, LabelledControlArray other):
        _c_api.LabelledControlArray_minusequals_control_array(self.handle, other.handle)

    def minusequals_farray(self, FArrayDouble other):
        _c_api.LabelledControlArray_minusequals_farray(self.handle, other.handle)

    def minusequals_double(self, double other):
        _c_api.LabelledControlArray_minusequals_double(self.handle, other)

    def minusequals_int(self, int other):
        _c_api.LabelledControlArray_minusequals_int(self.handle, other)

    def minus_control_array(self, LabelledControlArray other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_minus_control_array(self.handle, other.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def minus_farray(self, FArrayDouble other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_minus_farray(self.handle, other.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def minus_double(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_minus_double(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def minus_int(self, int other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_minus_int(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def negation(self, ):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_negation(self.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def __neg__(self):
        return self.negation()

    def timesequals_double(self, double other):
        _c_api.LabelledControlArray_timesequals_double(self.handle, other)

    def timesequals_int(self, int other):
        _c_api.LabelledControlArray_timesequals_int(self.handle, other)

    def times_double(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_times_double(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def times_int(self, int other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_times_int(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def dividesequals_double(self, double other):
        _c_api.LabelledControlArray_dividesequals_double(self.handle, other)

    def dividesequals_int(self, int other):
        _c_api.LabelledControlArray_dividesequals_int(self.handle, other)

    def divides_double(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_divides_double(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def divides_int(self, int other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_divides_int(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def pow(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_pow(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def abs(self, ):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_abs(self.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def min(self, ):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_min(self.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def min_farray(self, FArrayDouble other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_min_farray(self.handle, other.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def min_control_array(self, LabelledControlArray other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_min_control_array(self.handle, other.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def max(self, ):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_max(self.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def max_farray(self, FArrayDouble other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_max_farray(self.handle, other.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def max_control_array(self, LabelledControlArray other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_max_control_array(self.handle, other.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def equality(self, LabelledControlArray other):
        return _c_api.LabelledControlArray_equality(self.handle, other.handle)

    def notequality(self, LabelledControlArray other):
        return _c_api.LabelledControlArray_notequality(self.handle, other.handle)

    def greaterthan(self, double value):
        return _c_api.LabelledControlArray_greaterthan(self.handle, value)

    def lessthan(self, double value):
        return _c_api.LabelledControlArray_lessthan(self.handle, value)

    def remove_offset(self, double offset):
        _c_api.LabelledControlArray_remove_offset(self.handle, offset)

    def sum(self, ):
        return _c_api.LabelledControlArray_sum(self.handle)

    def reshape(self, size_t shape, size_t ndims):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_reshape(self.handle, shape, ndims)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def where(self, double value):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.LabelledControlArray_where(self.handle, value)
        if h_ret == <_c_api.ListListSizeTHandle>0:
            return None
        return list_list_size_t._list_list_size_t_from_capi(h_ret)

    def flip(self, size_t axis):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_flip(self.handle, axis)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def full_gradient(self, FArrayDouble out_buffer, size_t buffer_size):
        return _c_api.LabelledControlArray_full_gradient(self.handle, out_buffer.handle, buffer_size)

    def gradient(self, size_t axis):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.LabelledControlArray_gradient(self.handle, axis)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def get_sum_of_squares(self, ):
        return _c_api.LabelledControlArray_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, int other):
        return _c_api.LabelledControlArray_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, double other):
        return _c_api.LabelledControlArray_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, LabelledControlArray other):
        return _c_api.LabelledControlArray_get_summed_diff_array_of_squares(self.handle, other.handle)
