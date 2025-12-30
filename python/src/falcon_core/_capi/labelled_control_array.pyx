cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .acquisition_context cimport AcquisitionContext, _acquisition_context_from_capi
from .connection cimport Connection, _connection_from_capi
from .control_array cimport ControlArray, _control_array_from_capi
from .f_array_double cimport FArrayDouble, _f_array_double_from_capi
from .list_list_size_t cimport ListListSizeT, _list_list_size_t_from_capi
from .symbol_unit cimport SymbolUnit, _symbol_unit_from_capi

cdef class LabelledControlArray:
    def __cinit__(self):
        self.handle = <_c_api.LabelledControlArrayHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.LabelledControlArrayHandle>0 and self.owned:
            _c_api.LabelledControlArray_destroy(self.handle)
        self.handle = <_c_api.LabelledControlArrayHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def copy(self, ):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_copy(self.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def equal(self, LabelledControlArray other):
        return _c_api.LabelledControlArray_equal(self.handle, other.handle if other is not None else <_c_api.LabelledControlArrayHandle>0)

    def __eq__(self, LabelledControlArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, LabelledControlArray other):
        return _c_api.LabelledControlArray_not_equal(self.handle, other.handle if other is not None else <_c_api.LabelledControlArrayHandle>0)

    def __ne__(self, LabelledControlArray other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.LabelledControlArray_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    @staticmethod
    def from_farray(FArrayDouble farray, AcquisitionContext label):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_from_farray(farray.handle if farray is not None else <_c_api.FArrayDoubleHandle>0, label.handle if label is not None else <_c_api.AcquisitionContextHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    @staticmethod
    def from_control_array(ControlArray controlarray, AcquisitionContext label):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_from_control_array(controlarray.handle if controlarray is not None else <_c_api.ControlArrayHandle>0, label.handle if label is not None else <_c_api.AcquisitionContextHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret)

    def label(self, ):
        cdef _c_api.AcquisitionContextHandle h_ret = _c_api.LabelledControlArray_label(self.handle)
        if h_ret == <_c_api.AcquisitionContextHandle>0:
            return None
        return _acquisition_context_from_capi(h_ret)

    def connection(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.LabelledControlArray_connection(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def instrument_type(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.LabelledControlArray_instrument_type(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def units(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.LabelledControlArray_units(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def size(self, ):
        return _c_api.LabelledControlArray_size(self.handle)

    def dimension(self, ):
        return _c_api.LabelledControlArray_dimension(self.handle)

    def shape(self, size_t[:] out_buffer, size_t ndim):
        return _c_api.LabelledControlArray_shape(self.handle, &out_buffer[0], ndim)

    def data(self, double[:] out_buffer, size_t numdata):
        return _c_api.LabelledControlArray_data(self.handle, &out_buffer[0], numdata)

    def plus_equals_farray(self, FArrayDouble other):
        _c_api.LabelledControlArray_plus_equals_farray(self.handle, other.handle if other is not None else <_c_api.FArrayDoubleHandle>0)

    def plus_equals_double(self, double other):
        _c_api.LabelledControlArray_plus_equals_double(self.handle, other)

    def plus_equals_int(self, int other):
        _c_api.LabelledControlArray_plus_equals_int(self.handle, other)

    def plus_control_array(self, LabelledControlArray other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_plus_control_array(self.handle, other.handle if other is not None else <_c_api.LabelledControlArrayHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def plus_farray(self, FArrayDouble other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_plus_farray(self.handle, other.handle if other is not None else <_c_api.FArrayDoubleHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def plus_double(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_plus_double(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def plus_int(self, int other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_plus_int(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def minus_equals_control_array(self, LabelledControlArray other):
        _c_api.LabelledControlArray_minus_equals_control_array(self.handle, other.handle if other is not None else <_c_api.LabelledControlArrayHandle>0)

    def minus_equals_farray(self, FArrayDouble other):
        _c_api.LabelledControlArray_minus_equals_farray(self.handle, other.handle if other is not None else <_c_api.FArrayDoubleHandle>0)

    def minus_equals_double(self, double other):
        _c_api.LabelledControlArray_minus_equals_double(self.handle, other)

    def minus_equals_int(self, int other):
        _c_api.LabelledControlArray_minus_equals_int(self.handle, other)

    def minus_control_array(self, LabelledControlArray other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_minus_control_array(self.handle, other.handle if other is not None else <_c_api.LabelledControlArrayHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def minus_farray(self, FArrayDouble other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_minus_farray(self.handle, other.handle if other is not None else <_c_api.FArrayDoubleHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def minus_double(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_minus_double(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def minus_int(self, int other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_minus_int(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def negation(self, ):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_negation(self.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def __neg__(self):
        return self.negation()

    def times_equals_double(self, double other):
        _c_api.LabelledControlArray_times_equals_double(self.handle, other)

    def times_equals_int(self, int other):
        _c_api.LabelledControlArray_times_equals_int(self.handle, other)

    def times_double(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_times_double(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def times_int(self, int other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_times_int(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def divides_equals_double(self, double other):
        _c_api.LabelledControlArray_divides_equals_double(self.handle, other)

    def divides_equals_int(self, int other):
        _c_api.LabelledControlArray_divides_equals_int(self.handle, other)

    def divides_double(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_divides_double(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def divides_int(self, int other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_divides_int(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def pow(self, double other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_pow(self.handle, other)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def abs(self, ):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_abs(self.handle)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def min(self, ):
        return _c_api.LabelledControlArray_min(self.handle)

    def min_farray(self, FArrayDouble other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_min_farray(self.handle, other.handle if other is not None else <_c_api.FArrayDoubleHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def min_control_array(self, LabelledControlArray other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_min_control_array(self.handle, other.handle if other is not None else <_c_api.LabelledControlArrayHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def max(self, ):
        return _c_api.LabelledControlArray_max(self.handle)

    def max_farray(self, FArrayDouble other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_max_farray(self.handle, other.handle if other is not None else <_c_api.FArrayDoubleHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def max_control_array(self, LabelledControlArray other):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_max_control_array(self.handle, other.handle if other is not None else <_c_api.LabelledControlArrayHandle>0)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def greater_than(self, double value):
        return _c_api.LabelledControlArray_greater_than(self.handle, value)

    def __gt__(self, double value):
        return self.greater_than(value)

    def less_than(self, double value):
        return _c_api.LabelledControlArray_less_than(self.handle, value)

    def __lt__(self, double value):
        return self.less_than(value)

    def remove_offset(self, double offset):
        _c_api.LabelledControlArray_remove_offset(self.handle, offset)

    def sum(self, ):
        return _c_api.LabelledControlArray_sum(self.handle)

    def where(self, double value):
        cdef _c_api.ListListSizeTHandle h_ret = _c_api.LabelledControlArray_where(self.handle, value)
        if h_ret == <_c_api.ListListSizeTHandle>0:
            return None
        return _list_list_size_t_from_capi(h_ret)

    def flip(self, size_t axis):
        cdef _c_api.LabelledControlArrayHandle h_ret = _c_api.LabelledControlArray_flip(self.handle, axis)
        if h_ret == <_c_api.LabelledControlArrayHandle>0:
            return None
        return _labelled_control_array_from_capi(h_ret, owned=(h_ret != <_c_api.LabelledControlArrayHandle>self.handle))

    def full_gradient(self, size_t[:] out_buffer, size_t buffer_size):
        return _c_api.LabelledControlArray_full_gradient(self.handle, <_c_api.FArrayDoubleHandle*>&out_buffer[0], buffer_size)

    def gradient(self, size_t axis):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.LabelledControlArray_gradient(self.handle, axis)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

    def get_sum_of_squares(self, ):
        return _c_api.LabelledControlArray_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, int other):
        return _c_api.LabelledControlArray_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, double other):
        return _c_api.LabelledControlArray_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, LabelledControlArray other):
        return _c_api.LabelledControlArray_get_summed_diff_array_of_squares(self.handle, other.handle if other is not None else <_c_api.LabelledControlArrayHandle>0)

    def __len__(self):
        return self.size()

cdef LabelledControlArray _labelled_control_array_from_capi(_c_api.LabelledControlArrayHandle h, bint owned=True):
    if h == <_c_api.LabelledControlArrayHandle>0:
        return None
    cdef LabelledControlArray obj = LabelledControlArray.__new__(LabelledControlArray)
    obj.handle = h
    obj.owned = owned
    return obj
