# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .acquisition_context cimport AcquisitionContext
from .connection cimport Connection
from .control_array cimport ControlArray
from .f_array_double cimport FArrayDouble
from .list_list_size_t cimport ListListSizeT
from .symbol_unit cimport SymbolUnit

cdef class LabelledControlArray:
    cdef c_api.LabelledControlArrayHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.LabelledControlArrayHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.LabelledControlArrayHandle>0 and self.owned:
            c_api.LabelledControlArray_destroy(self.handle)
        self.handle = <c_api.LabelledControlArrayHandle>0

    cdef LabelledControlArray from_capi(cls, c_api.LabelledControlArrayHandle h):
        cdef LabelledControlArray obj = <LabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.LabelledControlArrayHandle h
        try:
            h = c_api.LabelledControlArray_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.LabelledControlArrayHandle>0:
            raise MemoryError("Failed to create LabelledControlArray")
        cdef LabelledControlArray obj = <LabelledControlArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def from_farray(farray, label):
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_from_farray(<c_api.FArrayDoubleHandle>farray.handle, <c_api.AcquisitionContextHandle>label.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    @staticmethod
    def from_control_array(controlarray, label):
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_from_control_array(<c_api.ControlArrayHandle>controlarray.handle, <c_api.AcquisitionContextHandle>label.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def label(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AcquisitionContextHandle h_ret
        h_ret = c_api.LabelledControlArray_label(self.handle)
        if h_ret == <c_api.AcquisitionContextHandle>0:
            return None
        return AcquisitionContext.from_capi(AcquisitionContext, h_ret)

    def connection(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.LabelledControlArray_connection(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def instrument_type(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.LabelledControlArray_instrument_type(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def units(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.LabelledControlArray_units(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def size(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_size(self.handle)

    def dimension(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_dimension(self.handle)

    def shape(self, out_buffer, ndim):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_shape(self.handle, out_buffer, ndim)

    def data(self, out_buffer, numdata):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_data(self.handle, out_buffer, numdata)

    def plusequals_farray(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_plusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def plusequals_double(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_plusequals_double(self.handle, other)

    def plusequals_int(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_plusequals_int(self.handle, other)

    def plus_control_array(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_plus_control_array(self.handle, <c_api.LabelledControlArrayHandle>other.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def plus_farray(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_plus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def plus_double(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_plus_double(self.handle, other)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def plus_int(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_plus_int(self.handle, other)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def minusequals_control_array(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_minusequals_control_array(self.handle, <c_api.LabelledControlArrayHandle>other.handle)

    def minusequals_farray(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_minusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def minusequals_double(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_minusequals_double(self.handle, other)

    def minusequals_int(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_minusequals_int(self.handle, other)

    def minus_control_array(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_minus_control_array(self.handle, <c_api.LabelledControlArrayHandle>other.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def minus_farray(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_minus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def minus_double(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_minus_double(self.handle, other)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def minus_int(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_minus_int(self.handle, other)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def negation(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_negation(self.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def __neg__(self):
        return self.negation()

    def timesequals_double(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_timesequals_double(self.handle, other)

    def timesequals_int(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_timesequals_int(self.handle, other)

    def times_double(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_times_double(self.handle, other)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def times_int(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_times_int(self.handle, other)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def dividesequals_double(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_dividesequals_double(self.handle, other)

    def dividesequals_int(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_dividesequals_int(self.handle, other)

    def divides_double(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_divides_double(self.handle, other)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def divides_int(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_divides_int(self.handle, other)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def pow(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_pow(self.handle, other)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def abs(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_abs(self.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def min(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_min(self.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def min_farray(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_min_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def min_control_array(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_min_control_array(self.handle, <c_api.LabelledControlArrayHandle>other.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def max(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_max(self.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def max_farray(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_max_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def max_control_array(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_max_control_array(self.handle, <c_api.LabelledControlArrayHandle>other.handle)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def equality(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_equality(self.handle, <c_api.LabelledControlArrayHandle>other.handle)

    def notequality(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_notequality(self.handle, <c_api.LabelledControlArrayHandle>other.handle)

    def greaterthan(self, value):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_greaterthan(self.handle, value)

    def lessthan(self, value):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_lessthan(self.handle, value)

    def remove_offset(self, offset):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledControlArray_remove_offset(self.handle, offset)

    def sum(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_sum(self.handle)

    def reshape(self, shape, ndims):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_reshape(self.handle, shape, ndims)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def where(self, value):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListListSizeTHandle h_ret
        h_ret = c_api.LabelledControlArray_where(self.handle, value)
        if h_ret == <c_api.ListListSizeTHandle>0:
            return None
        return ListListSizeT.from_capi(ListListSizeT, h_ret)

    def flip(self, axis):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledControlArrayHandle h_ret
        h_ret = c_api.LabelledControlArray_flip(self.handle, axis)
        if h_ret == <c_api.LabelledControlArrayHandle>0:
            return None
        return LabelledControlArray.from_capi(LabelledControlArray, h_ret)

    def full_gradient(self, out_buffer, buffer_size):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_full_gradient(self.handle, <c_api.FArrayDoubleHandle>out_buffer.handle, buffer_size)

    def gradient(self, axis):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.FArrayDoubleHandle h_ret
        h_ret = c_api.LabelledControlArray_gradient(self.handle, axis)
        if h_ret == <c_api.FArrayDoubleHandle>0:
            return None
        return FArrayDouble.from_capi(FArrayDouble, h_ret)

    def get_sum_of_squares(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, other):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledControlArray_get_summed_diff_array_of_squares(self.handle, <c_api.LabelledControlArrayHandle>other.handle)

    def to_json_string(self):
        if self.handle == <c_api.LabelledControlArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.LabelledControlArray_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef LabelledControlArray _labelledcontrolarray_from_capi(c_api.LabelledControlArrayHandle h):
    cdef LabelledControlArray obj = <LabelledControlArray>LabelledControlArray.__new__(LabelledControlArray)
    obj.handle = h