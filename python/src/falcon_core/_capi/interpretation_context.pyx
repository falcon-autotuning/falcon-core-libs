cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport axes_measurement_context
from . cimport list_measurement_context
from . cimport measurement_context
from . cimport symbol_unit

cdef class InterpretationContext:
    def __cinit__(self):
        self.handle = <_c_api.InterpretationContextHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.InterpretationContextHandle>0 and self.owned:
            _c_api.InterpretationContext_destroy(self.handle)
        self.handle = <_c_api.InterpretationContextHandle>0


cdef InterpretationContext _interpretation_context_from_capi(_c_api.InterpretationContextHandle h):
    if h == <_c_api.InterpretationContextHandle>0:
        return None
    cdef InterpretationContext obj = InterpretationContext.__new__(InterpretationContext)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, AxesMeasurementContext independant_variables, ListMeasurementContext dependant_variables, SymbolUnit unit):
        cdef _c_api.InterpretationContextHandle h
        h = _c_api.InterpretationContext_create(independant_variables.handle, dependant_variables.handle, unit.handle)
        if h == <_c_api.InterpretationContextHandle>0:
            raise MemoryError("Failed to create InterpretationContext")
        cdef InterpretationContext obj = <InterpretationContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.InterpretationContextHandle h
        try:
            h = _c_api.InterpretationContext_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.InterpretationContextHandle>0:
            raise MemoryError("Failed to create InterpretationContext")
        cdef InterpretationContext obj = <InterpretationContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def independent_variables(self, ):
        cdef _c_api.AxesMeasurementContextHandle h_ret = _c_api.InterpretationContext_independent_variables(self.handle)
        if h_ret == <_c_api.AxesMeasurementContextHandle>0:
            return None
        return axes_measurement_context._axes_measurement_context_from_capi(h_ret)

    def dependent_variables(self, ):
        cdef _c_api.ListMeasurementContextHandle h_ret = _c_api.InterpretationContext_dependent_variables(self.handle)
        if h_ret == <_c_api.ListMeasurementContextHandle>0:
            return None
        return list_measurement_context._list_measurement_context_from_capi(h_ret)

    def unit(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.InterpretationContext_unit(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return symbol_unit._symbol_unit_from_capi(h_ret)

    def dimension(self, ):
        return _c_api.InterpretationContext_dimension(self.handle)

    def dependent_variable(self, MeasurementContext variable):
        _c_api.InterpretationContext_dependent_variable(self.handle, variable.handle)

    def replace_dependent_variable(self, int index, MeasurementContext variable):
        _c_api.InterpretationContext_replace_dependent_variable(self.handle, index, variable.handle)

    def get_independent_variables(self, int index):
        cdef _c_api.MeasurementContextHandle h_ret = _c_api.InterpretationContext_get_independent_variables(self.handle, index)
        if h_ret == <_c_api.MeasurementContextHandle>0:
            return None
        return measurement_context._measurement_context_from_capi(h_ret)

    def with_unit(self, SymbolUnit unit):
        cdef _c_api.InterpretationContextHandle h_ret = _c_api.InterpretationContext_with_unit(self.handle, unit.handle)
        if h_ret == <_c_api.InterpretationContextHandle>0:
            return None
        return _interpretation_context_from_capi(h_ret)

    def equal(self, InterpretationContext b):
        return _c_api.InterpretationContext_equal(self.handle, b.handle)

    def __eq__(self, InterpretationContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, InterpretationContext b):
        return _c_api.InterpretationContext_not_equal(self.handle, b.handle)

    def __ne__(self, InterpretationContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
