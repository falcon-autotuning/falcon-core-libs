# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .f_array_double cimport FArrayDouble
from .list_string cimport ListString
from .map_string_double cimport MapStringDouble

cdef class AnalyticFunction:
    cdef c_api.AnalyticFunctionHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.AnalyticFunctionHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.AnalyticFunctionHandle>0 and self.owned:
            c_api.AnalyticFunction_destroy(self.handle)
        self.handle = <c_api.AnalyticFunctionHandle>0

    cdef AnalyticFunction from_capi(cls, c_api.AnalyticFunctionHandle h):
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, labels, expression):
        expression_bytes = expression.encode("utf-8")
        cdef const char* raw_expression = expression_bytes
        cdef size_t len_expression = len(expression_bytes)
        cdef c_api.StringHandle s_expression = c_api.String_create(raw_expression, len_expression)
        cdef c_api.AnalyticFunctionHandle h
        try:
            h = c_api.AnalyticFunction_create(<c_api.ListStringHandle>labels.handle, s_expression)
        finally:
            c_api.String_destroy(s_expression)
        if h == <c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_identity(cls, ):
        cdef c_api.AnalyticFunctionHandle h
        h = c_api.AnalyticFunction_create_identity()
        if h == <c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_constant(cls, value):
        cdef c_api.AnalyticFunctionHandle h
        h = c_api.AnalyticFunction_create_constant(value)
        if h == <c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.AnalyticFunctionHandle h
        try:
            h = c_api.AnalyticFunction_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def labels(self):
        if self.handle == <c_api.AnalyticFunctionHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.AnalyticFunction_labels(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def evaluate(self, args, time):
        if self.handle == <c_api.AnalyticFunctionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AnalyticFunction_evaluate(self.handle, <c_api.MapStringDoubleHandle>args.handle, time)

    def evaluate_arraywise(self, args, deltaT, maxTime):
        if self.handle == <c_api.AnalyticFunctionHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.FArrayDoubleHandle h_ret
        h_ret = c_api.AnalyticFunction_evaluate_arraywise(self.handle, <c_api.MapStringDoubleHandle>args.handle, deltaT, maxTime)
        if h_ret == <c_api.FArrayDoubleHandle>0:
            return None
        return FArrayDouble.from_capi(FArrayDouble, h_ret)

    def equal(self, b):
        if self.handle == <c_api.AnalyticFunctionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AnalyticFunction_equal(self.handle, <c_api.AnalyticFunctionHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.AnalyticFunctionHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AnalyticFunction_not_equal(self.handle, <c_api.AnalyticFunctionHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.AnalyticFunctionHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.AnalyticFunction_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef AnalyticFunction _analyticfunction_from_capi(c_api.AnalyticFunctionHandle h):
    cdef AnalyticFunction obj = <AnalyticFunction>AnalyticFunction.__new__(AnalyticFunction)
    obj.handle = h