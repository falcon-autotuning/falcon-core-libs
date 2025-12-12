from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.dot_gate_with_neighbors import DotGateWithNeighbors as _CDotGateWithNeighbors
from falcon_core.physics.device_structures.connection import Connection

class DotGateWithNeighbors:
    """Python wrapper for DotGateWithNeighbors."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new_plungergatewithneighbors(cls, name: str, left_neighbor: Connection, right_neighbor: Connection) -> DotGateWithNeighbors:
        return cls(_CDotGateWithNeighbors.new_plungergatewithneighbors(name, left_neighbor._c, right_neighbor._c))

    @classmethod
    def new_barriergatewithneighbors(cls, name: str, left_neighbor: Connection, right_neighbor: Connection) -> DotGateWithNeighbors:
        return cls(_CDotGateWithNeighbors.new_barriergatewithneighbors(name, left_neighbor._c, right_neighbor._c))

    @classmethod
    def from_json(cls, json: str) -> DotGateWithNeighbors:
        return cls(_CDotGateWithNeighbors.from_json(json))

    def equal(self, other: DotGateWithNeighbors) -> None:
        ret = self._c.equal(other._c)
        return ret

    def not_equal(self, other: DotGateWithNeighbors) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def name(self, ) -> str:
        ret = self._c.name()
        return ret

    def type(self, ) -> str:
        ret = self._c.type()
        return ret

    def left_neighbor(self, ) -> Connection:
        ret = self._c.left_neighbor()
        if ret is None: return None
        return Connection._from_capi(ret)

    def right_neighbor(self, ) -> Connection:
        ret = self._c.right_neighbor()
        if ret is None: return None
        return Connection._from_capi(ret)

    def is_barrier_gate(self, ) -> None:
        ret = self._c.is_barrier_gate()
        return ret

    def is_plunger_gate(self, ) -> None:
        ret = self._c.is_plunger_gate()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, DotGateWithNeighbors):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, DotGateWithNeighbors):
            return NotImplemented
        return self.not_equal(other)
