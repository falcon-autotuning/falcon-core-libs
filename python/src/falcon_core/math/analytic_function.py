from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.analytic_function import AnalyticFunction as _CAnalyticFunction
from falcon_core.generic.f_array import FArray
from falcon_core.generic.list import List
from falcon_core.generic.map import Map

class AnalyticFunction:
    """Python wrapper for AnalyticFunction."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def AnalyticFunction_create(cls, labels: List, expression: str) -> AnalyticFunction:
        return cls(_CAnalyticFunction.AnalyticFunction_create(labels._c, expression))

    @classmethod
    def AnalyticFunction_create_identity(cls, ) -> AnalyticFunction:
        return cls(_CAnalyticFunction.AnalyticFunction_create_identity())

    @classmethod
    def AnalyticFunction_create_constant(cls, value: Any) -> AnalyticFunction:
        return cls(_CAnalyticFunction.AnalyticFunction_create_constant(value))

    @classmethod
    def AnalyticFunction_from_json_string(cls, json: str) -> AnalyticFunction:
        return cls(_CAnalyticFunction.AnalyticFunction_from_json_string(json))

    def labels(self, ) -> List:
        ret = self._c.labels()
        if ret is None: return None
        return List(ret)

    def evaluate(self, args: Map, time: Any) -> None:
        ret = self._c.evaluate(args._c, time)
        return ret

    def evaluate_arraywise(self, args: Map, deltaT: Any, maxTime: Any) -> FArray:
        ret = self._c.evaluate_arraywise(args._c, deltaT, maxTime)
        if ret is None: return None
        return FArray(ret)

    def equal(self, b: AnalyticFunction) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: AnalyticFunction) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, AnalyticFunction):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, AnalyticFunction):
            return NotImplemented
        return self.notequality(other)
