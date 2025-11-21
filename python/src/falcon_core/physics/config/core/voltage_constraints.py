from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.voltage_constraints import VoltageConstraints as _CVoltageConstraints
from falcon_core.physics.config.core.adjacency import Adjacency
from falcon_core.generic.f_array_double import FArrayDouble
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
    def VoltageConstraints_create(cls, adjacency: Adjacency, max_safe_diff: Any, bounds: Pair) -> VoltageConstraints:
        return cls(_CVoltageConstraints.VoltageConstraints_create(adjacency._c, max_safe_diff, bounds._c))

    @classmethod
    def VoltageConstraints_from_json_string(cls, json: str) -> VoltageConstraints:
        return cls(_CVoltageConstraints.VoltageConstraints_from_json_string(json))

    def matrix(self, ) -> FArrayDouble:
        ret = self._c.matrix()
        if ret is None: return None
        return FArrayDouble._from_capi(ret)

    def adjacency(self, ) -> Adjacency:
        ret = self._c.adjacency()
        if ret is None: return None
        return Adjacency._from_capi(ret)

    def limits(self, ) -> FArrayDouble:
        ret = self._c.limits()
        if ret is None: return None
        return FArrayDouble._from_capi(ret)

    def equal(self, b: VoltageConstraints) -> None:
        ret = self._c.equal(b._c)
        return ret

    def __eq__(self, b: VoltageConstraints) -> None:
        if not hasattr(b, "_c"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b: VoltageConstraints) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __ne__(self, b: VoltageConstraints) -> None:
        if not hasattr(b, "_c"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
