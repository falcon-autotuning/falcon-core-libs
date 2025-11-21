from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.dot_gates_with_neighbors import DotGatesWithNeighbors as _CDotGatesWithNeighbors
from falcon_core.physics.config.geometries.dot_gate_with_neighbors import DotGateWithNeighbors
from falcon_core.generic.list import List

class DotGatesWithNeighbors:
    """Python wrapper for DotGatesWithNeighbors."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def DotGatesWithNeighbors_create_empty(cls, ) -> DotGatesWithNeighbors:
        return cls(_CDotGatesWithNeighbors.DotGatesWithNeighbors_create_empty())

    @classmethod
    def DotGatesWithNeighbors_create(cls, items: List) -> DotGatesWithNeighbors:
        return cls(_CDotGatesWithNeighbors.DotGatesWithNeighbors_create(items._c))

    @classmethod
    def DotGatesWithNeighbors_from_json_string(cls, json: str) -> DotGatesWithNeighbors:
        return cls(_CDotGatesWithNeighbors.DotGatesWithNeighbors_from_json_string(json))

    def is_plunger_gates(self, ) -> None:
        ret = self._c.is_plunger_gates()
        return ret

    def is_barrier_gates(self, ) -> None:
        ret = self._c.is_barrier_gates()
        return ret

    def intersection(self, other: DotGatesWithNeighbors) -> DotGatesWithNeighbors:
        ret = self._c.intersection(other._c)
        return cls._from_capi(ret)

    def push_back(self, value: DotGateWithNeighbors) -> None:
        ret = self._c.push_back(value._c)
        return ret

    def size(self, ) -> None:
        ret = self._c.size()
        return ret

    def empty(self, ) -> None:
        ret = self._c.empty()
        return ret

    def erase_at(self, idx: Any) -> None:
        ret = self._c.erase_at(idx)
        return ret

    def clear(self, ) -> None:
        ret = self._c.clear()
        return ret

    def const_at(self, idx: Any) -> const DotGateWithNeighbors:
        ret = self._c.const_at(idx)
        if ret is None: return None
        return const DotGateWithNeighbors._from_capi(ret)

    def at(self, idx: Any) -> DotGateWithNeighbors:
        ret = self._c.at(idx)
        if ret is None: return None
        return DotGateWithNeighbors._from_capi(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def contains(self, value: DotGateWithNeighbors) -> None:
        ret = self._c.contains(value._c)
        return ret

    def index(self, value: DotGateWithNeighbors) -> None:
        ret = self._c.index(value._c)
        return ret

    def equal(self, b: DotGatesWithNeighbors) -> None:
        ret = self._c.equal(b._c)
        return ret

    def __eq__(self, b: DotGatesWithNeighbors) -> None:
        if not hasattr(b, "_c"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b: DotGatesWithNeighbors) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __ne__(self, b: DotGatesWithNeighbors) -> None:
        if not hasattr(b, "_c"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
