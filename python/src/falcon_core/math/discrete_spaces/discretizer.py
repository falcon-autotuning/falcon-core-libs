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
    def new_cartesian_discretizer(cls, delta: Any) -> Discretizer:
        return cls(_CDiscretizer.new_cartesian_discretizer(delta))

    @classmethod
    def new_polar_discretizer(cls, delta: Any) -> Discretizer:
        return cls(_CDiscretizer.new_polar_discretizer(delta))

    @classmethod
    def from_json(cls, json: str) -> Discretizer:
        return cls(_CDiscretizer.from_json(json))

    def delta(self, ) -> None:
        ret = self._c.delta()
        return ret

    def set_delta(self, delta: Any) -> None:
        ret = self._c.set_delta(delta)
        return ret

    def domain(self, ) -> Domain:
        ret = self._c.domain()
        if ret is None: return None
        return Domain._from_capi(ret)

    def is_cartesian(self, ) -> None:
        ret = self._c.is_cartesian()
        return ret

    def is_polar(self, ) -> None:
        ret = self._c.is_polar()
        return ret

    def equal(self, b: Discretizer) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Discretizer) -> None:
        ret = self._c.not_equal(b._c)
        return ret

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
