cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .axes_measurement_context cimport AxesMeasurementContext, _axes_measurement_context_from_capi
from .list_measurement_context cimport ListMeasurementContext, _list_measurement_context_from_capi
from .measurement_context cimport MeasurementContext, _measurement_context_from_capi
from .symbol_unit cimport SymbolUnit, _symbol_unit_from_capi

cdef class InterpretationContext:
    def __cinit__(self):
        self.handle = <_c_api.InterpretationContextHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.InterpretationContextHandle>0 and self.owned:
            _c_api.InterpretationContext_destroy(self.handle)
        self.handle = <_c_api.InterpretationContextHandle>0


    @classmethod
    def new(cls, AxesMeasurementContext independant_variables, ListMeasurementContext dependant_variables, SymbolUnit unit):
        cdef _c_api.InterpretationContextHandle h
        h = _c_api.InterpretationContext_create(independant_variables.handle if independant_variables is not None else <_c_api.AxesMeasurementContextHandle>0, dependant_variables.handle if dependant_variables is not None else <_c_api.ListMeasurementContextHandle>0, unit.handle if unit is not None else <_c_api.SymbolUnitHandle>0)
        if h == <_c_api.InterpretationContextHandle>0:
            raise MemoryError("Failed to create InterpretationContext")
        cdef InterpretationContext obj = <InterpretationContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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
        return _axes_measurement_context_from_capi(h_ret)

    def dependent_variables(self, ):
        cdef _c_api.ListMeasurementContextHandle h_ret = _c_api.InterpretationContext_dependent_variables(self.handle)
        if h_ret == <_c_api.ListMeasurementContextHandle>0:
            return None
        return _list_measurement_context_from_capi(h_ret)

    def unit(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.InterpretationContext_unit(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def dimension(self, ):
        return _c_api.InterpretationContext_dimension(self.handle)

    def add_dependent_variable(self, MeasurementContext variable):
        _c_api.InterpretationContext_add_dependent_variable(self.handle, variable.handle if variable is not None else <_c_api.MeasurementContextHandle>0)

    def replace_dependent_variable(self, int index, MeasurementContext variable):
        _c_api.InterpretationContext_replace_dependent_variable(self.handle, index, variable.handle if variable is not None else <_c_api.MeasurementContextHandle>0)

    def get_independent_variables(self, int index):
        cdef _c_api.MeasurementContextHandle h_ret = _c_api.InterpretationContext_get_independent_variables(self.handle, index)
        if h_ret == <_c_api.MeasurementContextHandle>0:
            return None
        return _measurement_context_from_capi(h_ret, owned=False)

    def with_unit(self, SymbolUnit unit):
        cdef _c_api.InterpretationContextHandle h_ret = _c_api.InterpretationContext_with_unit(self.handle, unit.handle if unit is not None else <_c_api.SymbolUnitHandle>0)
        if h_ret == <_c_api.InterpretationContextHandle>0:
            return None
        return _interpretation_context_from_capi(h_ret)

    def equal(self, InterpretationContext b):
        return _c_api.InterpretationContext_equal(self.handle, b.handle if b is not None else <_c_api.InterpretationContextHandle>0)

    def __eq__(self, InterpretationContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, InterpretationContext b):
        return _c_api.InterpretationContext_not_equal(self.handle, b.handle if b is not None else <_c_api.InterpretationContextHandle>0)

    def __ne__(self, InterpretationContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.InterpretationContext_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef InterpretationContext _interpretation_context_from_capi(_c_api.InterpretationContextHandle h, bint owned=True):
    if h == <_c_api.InterpretationContextHandle>0:
        return None
    cdef InterpretationContext obj = InterpretationContext.__new__(InterpretationContext)
    obj.handle = h
    obj.owned = owned
    return obj
