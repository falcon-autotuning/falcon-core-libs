# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .acquisition_context cimport AcquisitionContext
from .connection cimport Connection
from .f_array_double cimport FArrayDouble
from .list_list_size_t cimport ListListSizeT
from .measured_array cimport MeasuredArray
from .symbol_unit cimport SymbolUnit

cdef class LabelledMeasuredArray:
    cdef c_api.LabelledMeasuredArrayHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.LabelledMeasuredArrayHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.LabelledMeasuredArrayHandle>0 and self.owned:
            c_api.LabelledMeasuredArray_destroy(self.handle)
        self.handle = <c_api.LabelledMeasuredArrayHandle>0

    cdef LabelledMeasuredArray from_capi(cls, c_api.LabelledMeasuredArrayHandle h):
        cdef LabelledMeasuredArray obj = <LabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.LabelledMeasuredArrayHandle h
        try:
            h = c_api.LabelledMeasuredArray_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.LabelledMeasuredArrayHandle>0:
            raise MemoryError("Failed to create LabelledMeasuredArray")
        cdef LabelledMeasuredArray obj = <LabelledMeasuredArray>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @staticmethod
    def from_farray(farray, label):
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_from_farray(<c_api.FArrayDoubleHandle>farray.handle, <c_api.AcquisitionContextHandle>label.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    @staticmethod
    def from_measured_array(measuredarray, label):
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_from_measured_array(<c_api.MeasuredArrayHandle>measuredarray.handle, <c_api.AcquisitionContextHandle>label.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def label(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AcquisitionContextHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_label(self.handle)
        if h_ret == <c_api.AcquisitionContextHandle>0:
            return None
        return AcquisitionContext.from_capi(AcquisitionContext, h_ret)

    def connection(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_connection(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def instrument_type(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.LabelledMeasuredArray_instrument_type(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def units(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_units(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def size(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_size(self.handle)

    def dimension(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_dimension(self.handle)

    def shape(self, out_buffer, ndim):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_shape(self.handle, out_buffer, ndim)

    def data(self, out_buffer, numdata):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_data(self.handle, out_buffer, numdata)

    def plusequals_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_plusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def plusequals_double(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_plusequals_double(self.handle, other)

    def plusequals_int(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_plusequals_int(self.handle, other)

    def plus_measured_array(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_plus_measured_array(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def plus_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_plus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def plus_double(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_plus_double(self.handle, other)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def plus_int(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_plus_int(self.handle, other)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def minusequals_measured_array(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_minusequals_measured_array(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)

    def minusequals_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_minusequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)

    def minusequals_double(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_minusequals_double(self.handle, other)

    def minusequals_int(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_minusequals_int(self.handle, other)

    def minus_measured_array(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_minus_measured_array(self.handle, <c_api.MeasuredArrayHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def minus_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_minus_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def minus_double(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_minus_double(self.handle, other)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def minus_int(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_minus_int(self.handle, other)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def negation(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_negation(self.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def __neg__(self):
        return self.negation()

    def timesequals_measured_array(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_timesequals_measured_array(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def timesequals_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_timesequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def timesequals_double(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_timesequals_double(self.handle, other)

    def timesequals_int(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_timesequals_int(self.handle, other)

    def times_measured_array(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_times_measured_array(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def times_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_times_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def times_double(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_times_double(self.handle, other)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def times_int(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_times_int(self.handle, other)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def dividesequals_measured_array(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_dividesequals_measured_array(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def dividesequals_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_dividesequals_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def dividesequals_double(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_dividesequals_double(self.handle, other)

    def dividesequals_int(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_dividesequals_int(self.handle, other)

    def divides_measured_array(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_divides_measured_array(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def divides_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_divides_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def divides_double(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_divides_double(self.handle, other)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def divides_int(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_divides_int(self.handle, other)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def pow(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_pow(self.handle, other)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def abs(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_abs(self.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def min_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_min_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def min_measured_array(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_min_measured_array(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def max_farray(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_max_farray(self.handle, <c_api.FArrayDoubleHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def max_measured_array(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_max_measured_array(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def equality(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_equality(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)

    def notequality(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_notequality(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)

    def greaterthan(self, value):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_greaterthan(self.handle, value)

    def lessthan(self, value):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_lessthan(self.handle, value)

    def remove_offset(self, offset):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        c_api.LabelledMeasuredArray_remove_offset(self.handle, offset)

    def sum(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_sum(self.handle)

    def reshape(self, shape, ndims):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_reshape(self.handle, shape, ndims)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def where(self, value):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListListSizeTHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_where(self.handle, value)
        if h_ret == <c_api.ListListSizeTHandle>0:
            return None
        return ListListSizeT.from_capi(ListListSizeT, h_ret)

    def flip(self, axis):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_flip(self.handle, axis)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def full_gradient(self, out_buffer, buffer_size):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_full_gradient(self.handle, <c_api.LabelledMeasuredArrayHandle>out_buffer.handle, buffer_size)

    def gradient(self, axis):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LabelledMeasuredArrayHandle h_ret
        h_ret = c_api.LabelledMeasuredArray_gradient(self.handle, axis)
        if h_ret == <c_api.LabelledMeasuredArrayHandle>0:
            return None
        return LabelledMeasuredArray.from_capi(LabelledMeasuredArray, h_ret)

    def get_sum_of_squares(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_get_sum_of_squares(self.handle)

    def get_summed_diff_int_of_squares(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_get_summed_diff_int_of_squares(self.handle, other)

    def get_summed_diff_double_of_squares(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_get_summed_diff_double_of_squares(self.handle, other)

    def get_summed_diff_array_of_squares(self, other):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.LabelledMeasuredArray_get_summed_diff_array_of_squares(self.handle, <c_api.LabelledMeasuredArrayHandle>other.handle)

    def to_json_string(self):
        if self.handle == <c_api.LabelledMeasuredArrayHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.LabelledMeasuredArray_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef LabelledMeasuredArray _labelledmeasuredarray_from_capi(c_api.LabelledMeasuredArrayHandle h):
    cdef LabelledMeasuredArray obj = <LabelledMeasuredArray>LabelledMeasuredArray.__new__(LabelledMeasuredArray)
    obj.handle = h