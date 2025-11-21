# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .axes_measurement_context cimport AxesMeasurementContext
from .list_measurement_context cimport ListMeasurementContext
from .measurement_context cimport MeasurementContext
from .symbol_unit cimport SymbolUnit

cdef class InterpretationContext:
    cdef c_api.InterpretationContextHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.InterpretationContextHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.InterpretationContextHandle>0 and self.owned:
            c_api.InterpretationContext_destroy(self.handle)
        self.handle = <c_api.InterpretationContextHandle>0

    cdef InterpretationContext from_capi(cls, c_api.InterpretationContextHandle h):
        cdef InterpretationContext obj = <InterpretationContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, independant_variables, dependant_variables, unit):
        cdef c_api.InterpretationContextHandle h
        h = c_api.InterpretationContext_create(<c_api.AxesMeasurementContextHandle>independant_variables.handle, <c_api.ListMeasurementContextHandle>dependant_variables.handle, <c_api.SymbolUnitHandle>unit.handle)
        if h == <c_api.InterpretationContextHandle>0:
            raise MemoryError("Failed to create InterpretationContext")
        cdef InterpretationContext obj = <InterpretationContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.InterpretationContextHandle h
        try:
            h = c_api.InterpretationContext_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.InterpretationContextHandle>0:
            raise MemoryError("Failed to create InterpretationContext")
        cdef InterpretationContext obj = <InterpretationContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def independent_variables(self):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AxesMeasurementContextHandle h_ret
        h_ret = c_api.InterpretationContext_independent_variables(self.handle)
        if h_ret == <c_api.AxesMeasurementContextHandle>0:
            return None
        return AxesMeasurementContext.from_capi(AxesMeasurementContext, h_ret)

    def dependent_variables(self):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListMeasurementContextHandle h_ret
        h_ret = c_api.InterpretationContext_dependent_variables(self.handle)
        if h_ret == <c_api.ListMeasurementContextHandle>0:
            return None
        return ListMeasurementContext.from_capi(ListMeasurementContext, h_ret)

    def unit(self):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.InterpretationContext_unit(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def dimension(self):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContext_dimension(self.handle)

    def dependent_variable(self, variable):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        c_api.InterpretationContext_dependent_variable(self.handle, <c_api.MeasurementContextHandle>variable.handle)

    def replace_dependent_variable(self, index, variable):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        c_api.InterpretationContext_replace_dependent_variable(self.handle, index, <c_api.MeasurementContextHandle>variable.handle)

    def get_independent_variables(self, index):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.MeasurementContextHandle h_ret
        h_ret = c_api.InterpretationContext_get_independent_variables(self.handle, index)
        if h_ret == <c_api.MeasurementContextHandle>0:
            return None
        return MeasurementContext.from_capi(MeasurementContext, h_ret)

    def with_unit(self, unit):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.InterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContext_with_unit(self.handle, <c_api.SymbolUnitHandle>unit.handle)
        if h_ret == <c_api.InterpretationContextHandle>0:
            return None
        return InterpretationContext.from_capi(InterpretationContext, h_ret)

    def equal(self, b):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContext_equal(self.handle, <c_api.InterpretationContextHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContext_not_equal(self.handle, <c_api.InterpretationContextHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.InterpretationContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.InterpretationContext_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef InterpretationContext _interpretationcontext_from_capi(c_api.InterpretationContextHandle h):
    cdef InterpretationContext obj = <InterpretationContext>InterpretationContext.__new__(InterpretationContext)
    obj.handle = h