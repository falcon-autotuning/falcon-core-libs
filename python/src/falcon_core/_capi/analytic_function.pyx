cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .f_array_double cimport FArrayDouble, _f_array_double_from_capi
from .list_string cimport ListString, _list_string_from_capi
from .map_string_double cimport MapStringDouble, _map_string_double_from_capi

cdef class AnalyticFunction:
    def __cinit__(self):
        self.handle = <_c_api.AnalyticFunctionHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AnalyticFunctionHandle>0 and self.owned:
            _c_api.AnalyticFunction_destroy(self.handle)
        self.handle = <_c_api.AnalyticFunctionHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AnalyticFunctionHandle h
        try:
            h = _c_api.AnalyticFunction_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListString labels, str expression):
        cdef bytes b_expression = expression.encode("utf-8")
        cdef _c_api.StringHandle s_expression = _c_api.String_create(b_expression, len(b_expression))
        cdef _c_api.AnalyticFunctionHandle h
        try:
            h = _c_api.AnalyticFunction_create(labels.handle if labels is not None else <_c_api.ListStringHandle>0, s_expression)
        finally:
            _c_api.String_destroy(s_expression)
        if h == <_c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_identity(cls, ):
        cdef _c_api.AnalyticFunctionHandle h
        h = _c_api.AnalyticFunction_create_identity()
        if h == <_c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_constant(cls, double value):
        cdef _c_api.AnalyticFunctionHandle h
        h = _c_api.AnalyticFunction_create_constant(value)
        if h == <_c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.AnalyticFunctionHandle h_ret = _c_api.AnalyticFunction_copy(self.handle)
        if h_ret == <_c_api.AnalyticFunctionHandle>0:
            return None
        return _analytic_function_from_capi(h_ret)

    def equal(self, AnalyticFunction other):
        return _c_api.AnalyticFunction_equal(self.handle, other.handle if other is not None else <_c_api.AnalyticFunctionHandle>0)

    def __eq__(self, AnalyticFunction other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, AnalyticFunction other):
        return _c_api.AnalyticFunction_not_equal(self.handle, other.handle if other is not None else <_c_api.AnalyticFunctionHandle>0)

    def __ne__(self, AnalyticFunction other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.AnalyticFunction_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def labels(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.AnalyticFunction_labels(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def evaluate(self, MapStringDouble args, double time):
        return _c_api.AnalyticFunction_evaluate(self.handle, args.handle if args is not None else <_c_api.MapStringDoubleHandle>0, time)

    def evaluate_arraywise(self, MapStringDouble args, double deltaT, double maxTime):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.AnalyticFunction_evaluate_arraywise(self.handle, args.handle if args is not None else <_c_api.MapStringDoubleHandle>0, deltaT, maxTime)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return _f_array_double_from_capi(h_ret)

cdef AnalyticFunction _analytic_function_from_capi(_c_api.AnalyticFunctionHandle h, bint owned=True):
    if h == <_c_api.AnalyticFunctionHandle>0:
        return None
    cdef AnalyticFunction obj = AnalyticFunction.__new__(AnalyticFunction)
    obj.handle = h
    obj.owned = owned
    return obj
