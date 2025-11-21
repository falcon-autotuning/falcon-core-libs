from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.interpretation_context import InterpretationContext as _CInterpretationContext
from falcon_core.math.axes_measurement_context import AxesMeasurementContext
from falcon_core.generic.list import List
from falcon_core.autotuner_interfaces.contexts.measurement_context import MeasurementContext
from falcon_core.physics.units.symbol_unit import SymbolUnit

class InterpretationContext:
    """Python wrapper for InterpretationContext."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def InterpretationContext_create(cls, independant_variables: AxesMeasurementContext, dependant_variables: List, unit: SymbolUnit) -> InterpretationContext:
        return cls(_CInterpretationContext.InterpretationContext_create(independant_variables._c, dependant_variables._c, unit._c))

    @classmethod
    def InterpretationContext_from_json_string(cls, json: str) -> InterpretationContext:
        return cls(_CInterpretationContext.InterpretationContext_from_json_string(json))

    def independent_variables(self, ) -> AxesMeasurementContext:
        ret = self._c.independent_variables()
        if ret is None: return None
        return AxesMeasurementContext._from_capi(ret)

    def dependent_variables(self, ) -> List:
        ret = self._c.dependent_variables()
        if ret is None: return None
        return List(ret)

    def unit(self, ) -> SymbolUnit:
        ret = self._c.unit()
        if ret is None: return None
        return SymbolUnit._from_capi(ret)

    def dimension(self, ) -> None:
        ret = self._c.dimension()
        return ret

    def dependent_variable(self, variable: MeasurementContext) -> None:
        ret = self._c.dependent_variable(variable._c)
        return ret

    def replace_dependent_variable(self, index: Any, variable: MeasurementContext) -> None:
        ret = self._c.replace_dependent_variable(index, variable._c)
        return ret

    def get_independent_variables(self, index: Any) -> MeasurementContext:
        ret = self._c.get_independent_variables(index)
        if ret is None: return None
        return MeasurementContext._from_capi(ret)

    def with_unit(self, unit: SymbolUnit) -> InterpretationContext:
        ret = self._c.with_unit(unit._c)
        return cls._from_capi(ret)

    def equal(self, b: InterpretationContext) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: InterpretationContext) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, InterpretationContext):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, InterpretationContext):
            return NotImplemented
        return self.notequality(other)
