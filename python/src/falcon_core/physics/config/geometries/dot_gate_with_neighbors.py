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
    def from_json(cls, json: str) -> DotGateWithNeighbors:
        return cls(_CDotGateWithNeighbors.from_json(json))

    @classmethod
    def new_plunger_gate_with_neighbors(cls, name: str, left_neighbor: Connection, right_neighbor: Connection) -> DotGateWithNeighbors:
        obj = cls(_CDotGateWithNeighbors.new_plunger_gate_with_neighbors(name, left_neighbor._c if left_neighbor is not None else None, right_neighbor._c if right_neighbor is not None else None))
        obj._ref_left_neighbor = left_neighbor  # Keep reference alive
        obj._ref_right_neighbor = right_neighbor  # Keep reference alive
        return obj

    @classmethod
    def new_barrier_gate_with_neighbors(cls, name: str, left_neighbor: Connection, right_neighbor: Connection) -> DotGateWithNeighbors:
        obj = cls(_CDotGateWithNeighbors.new_barrier_gate_with_neighbors(name, left_neighbor._c if left_neighbor is not None else None, right_neighbor._c if right_neighbor is not None else None))
        obj._ref_left_neighbor = left_neighbor  # Keep reference alive
        obj._ref_right_neighbor = right_neighbor  # Keep reference alive
        return obj

    def copy(self, ) -> DotGateWithNeighbors:
        ret = self._c.copy()
        return DotGateWithNeighbors._from_capi(ret)

    def equal(self, other: DotGateWithNeighbors) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: DotGateWithNeighbors) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
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

    def is_barrier_gate(self, ) -> bool:
        ret = self._c.is_barrier_gate()
        return ret

    def is_plunger_gate(self, ) -> bool:
        ret = self._c.is_plunger_gate()
        return ret

    @property
    def name(self) -> str:
        ret = self._c.name()
        return ret

    def __repr__(self):
        return f"DotGateWithNeighbors({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

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
