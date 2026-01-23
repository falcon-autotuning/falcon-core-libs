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
    def from_json(cls, json: str) -> AnalyticFunction:
        return cls(_CAnalyticFunction.from_json(json))

    @classmethod
    def new(cls, labels: List, expression: str) -> AnalyticFunction:
        obj = cls(_CAnalyticFunction.new(labels._c if labels is not None else None, expression))
        obj._ref_labels = labels  # Keep reference alive
        return obj

    @classmethod
    def new_identity(cls, ) -> AnalyticFunction:
        return cls(_CAnalyticFunction.new_identity())

    @classmethod
    def new_constant(cls, value: Any) -> AnalyticFunction:
        return cls(_CAnalyticFunction.new_constant(value))

    def copy(self, ) -> AnalyticFunction:
        ret = self._c.copy()
        return AnalyticFunction._from_capi(ret)

    def equal(self, other: AnalyticFunction) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: AnalyticFunction) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def labels(self, ) -> List:
        ret = self._c.labels()
        if ret is None: return None
        return List(ret)

    def evaluate(self, args: Map, time: Any) -> float:
        ret = self._c.evaluate(args._c if args is not None else None, time)
        return ret

    def evaluate_arraywise(self, args: Map, deltaT: Any, maxTime: Any) -> FArray:
        ret = self._c.evaluate_arraywise(args._c if args is not None else None, deltaT, maxTime)
        if ret is None: return None
        return FArray(ret)

    def __repr__(self):
        return f"AnalyticFunction({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, AnalyticFunction):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, AnalyticFunction):
            return NotImplemented
        return self.not_equal(other)
