from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.discretizer import Discretizer as _CDiscretizer
from falcon_core.math.domains.domain import Domain

class Discretizer:
    """Python wrapper for Discretizer."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> Discretizer:
        return cls(_CDiscretizer.from_json(json))

    @classmethod
    def new_cartesian_discretizer(cls, delta: Any) -> Discretizer:
        return cls(_CDiscretizer.new_cartesian_discretizer(delta))

    @classmethod
    def new_polar_discretizer(cls, delta: Any) -> Discretizer:
        return cls(_CDiscretizer.new_polar_discretizer(delta))

    def copy(self, ) -> Discretizer:
        ret = self._c.copy()
        return Discretizer._from_capi(ret)

    def equal(self, other: Discretizer) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Discretizer) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def delta(self, ) -> float:
        ret = self._c.delta()
        return ret

    def domain(self, ) -> Domain:
        ret = self._c.domain()
        if ret is None: return None
        return Domain._from_capi(ret)

    def is_cartesian(self, ) -> bool:
        ret = self._c.is_cartesian()
        return ret

    def is_polar(self, ) -> bool:
        ret = self._c.is_polar()
        return ret

    def set_delta(self, delta: Any) -> None:
        ret = self._c.set_delta(delta)
        return ret

    def __repr__(self):
        return f"Discretizer({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Discretizer):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Discretizer):
            return NotImplemented
        return self.not_equal(other)
