cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport f_array_double
from . cimport list_string
from . cimport map_string_double

cdef class AnalyticFunction:
    def __cinit__(self):
        self.handle = <_c_api.AnalyticFunctionHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AnalyticFunctionHandle>0 and self.owned:
            _c_api.AnalyticFunction_destroy(self.handle)
        self.handle = <_c_api.AnalyticFunctionHandle>0


cdef AnalyticFunction _analytic_function_from_capi(_c_api.AnalyticFunctionHandle h):
    if h == <_c_api.AnalyticFunctionHandle>0:
        return None
    cdef AnalyticFunction obj = AnalyticFunction.__new__(AnalyticFunction)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, ListString labels, str expression):
        cdef bytes b_expression = expression.encode("utf-8")
        cdef StringHandle s_expression = _c_api.String_create(b_expression, len(b_expression))
        cdef _c_api.AnalyticFunctionHandle h
        try:
            h = _c_api.AnalyticFunction_create(labels.handle, s_expression)
        finally:
            _c_api.String_destroy(s_expression)
        if h == <_c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def identity(cls, ):
        cdef _c_api.AnalyticFunctionHandle h
        h = _c_api.AnalyticFunction_create_identity()
        if h == <_c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def constant(cls, double value):
        cdef _c_api.AnalyticFunctionHandle h
        h = _c_api.AnalyticFunction_create_constant(value)
        if h == <_c_api.AnalyticFunctionHandle>0:
            raise MemoryError("Failed to create AnalyticFunction")
        cdef AnalyticFunction obj = <AnalyticFunction>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def labels(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.AnalyticFunction_labels(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return list_string._list_string_from_capi(h_ret)

    def evaluate(self, MapStringDouble args, double time):
        return _c_api.AnalyticFunction_evaluate(self.handle, args.handle, time)

    def evaluate_arraywise(self, MapStringDouble args, double deltaT, double maxTime):
        cdef _c_api.FArrayDoubleHandle h_ret = _c_api.AnalyticFunction_evaluate_arraywise(self.handle, args.handle, deltaT, maxTime)
        if h_ret == <_c_api.FArrayDoubleHandle>0:
            return None
        return f_array_double._f_array_double_from_capi(h_ret)

    def equal(self, AnalyticFunction b):
        return _c_api.AnalyticFunction_equal(self.handle, b.handle)

    def __eq__(self, AnalyticFunction b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AnalyticFunction b):
        return _c_api.AnalyticFunction_not_equal(self.handle, b.handle)

    def __ne__(self, AnalyticFunction b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
