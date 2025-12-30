from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.voltage_constraints import VoltageConstraints as _CVoltageConstraints
from falcon_core.physics.config.core.adjacency import Adjacency
from falcon_core.generic.f_array import FArray
from falcon_core.generic.pair import Pair

class VoltageConstraints:
    """Python wrapper for VoltageConstraints."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> VoltageConstraints:
        return cls(_CVoltageConstraints.from_json(json))

    @classmethod
    def new(cls, adjacency: Adjacency, max_safe_diff: Any, bounds: Pair) -> VoltageConstraints:
        obj = cls(_CVoltageConstraints.new(adjacency._c if adjacency is not None else None, max_safe_diff, bounds._c if bounds is not None else None))
        obj._ref_adjacency = adjacency  # Keep reference alive
        obj._ref_bounds = bounds  # Keep reference alive
        return obj

    def copy(self, ) -> VoltageConstraints:
        ret = self._c.copy()
        return VoltageConstraints._from_capi(ret)

    def equal(self, other: VoltageConstraints) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: VoltageConstraints) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def matrix(self, ) -> FArray:
        ret = self._c.matrix()
        if ret is None: return None
        return FArray(ret)

    def adjacency(self, ) -> Adjacency:
        ret = self._c.adjacency()
        if ret is None: return None
        return Adjacency._from_capi(ret)

    def limits(self, ) -> FArray:
        ret = self._c.limits()
        if ret is None: return None
        return FArray(ret)

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, VoltageConstraints):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, VoltageConstraints):
            return NotImplemented
        return self.not_equal(other)
