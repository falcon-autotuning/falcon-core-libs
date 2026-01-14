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
    def from_json(cls, json: str) -> DotGatesWithNeighbors:
        return cls(_CDotGatesWithNeighbors.from_json(json))

    @classmethod
    def new_empty(cls, ) -> DotGatesWithNeighbors:
        return cls(_CDotGatesWithNeighbors.new_empty())

    @classmethod
    def new(cls, items: List) -> DotGatesWithNeighbors:
        obj = cls(_CDotGatesWithNeighbors.new(items._c if items is not None else None))
        obj._ref_items = items  # Keep reference alive
        return obj

    def copy(self, ) -> DotGatesWithNeighbors:
        ret = self._c.copy()
        return DotGatesWithNeighbors._from_capi(ret)

    def equal(self, other: DotGatesWithNeighbors) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: DotGatesWithNeighbors) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def is_plunger_gates(self, ) -> bool:
        ret = self._c.is_plunger_gates()
        return ret

    def is_barrier_gates(self, ) -> bool:
        ret = self._c.is_barrier_gates()
        return ret

    def intersection(self, other: DotGatesWithNeighbors) -> DotGatesWithNeighbors:
        ret = self._c.intersection(other._c if other is not None else None)
        return DotGatesWithNeighbors._from_capi(ret)

    def push_back(self, value: DotGateWithNeighbors) -> None:
        ret = self._c.push_back(value._c if value is not None else None)
        return ret

    def empty(self, ) -> bool:
        ret = self._c.empty()
        return ret

    def erase_at(self, idx: Any) -> None:
        ret = self._c.erase_at(idx)
        return ret

    def clear(self, ) -> None:
        ret = self._c.clear()
        return ret

    def at(self, idx: Any) -> DotGateWithNeighbors:
        ret = self._c.at(idx)
        if ret is None: return None
        return DotGateWithNeighbors._from_capi(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def contains(self, value: DotGateWithNeighbors) -> bool:
        ret = self._c.contains(value._c if value is not None else None)
        return ret

    def index(self, value: DotGateWithNeighbors) -> int:
        ret = self._c.index(value._c if value is not None else None)
        return ret

    @property
    def size(self) -> int:
        ret = self._c.size()
        return ret

    def __len__(self):
        return self.size

    def __getitem__(self, key):
        ret = self.at(key)
        if ret is None:
            raise IndexError(f"{key} not found in {self.__class__.__name__}")
        return ret

    def __iter__(self):
        for i in range(len(self)):
            yield self[i]

    def __contains__(self, key):
        return self.contains(key)

    def append(self, value):
        return self.push_back(value)

    @classmethod
    def from_list(cls, items):
        obj = cls(_CDotGatesWithNeighbors.from_list(items))
        # If items are wrappers, we might need to keep refs, but List usually copies.
        return obj

    def __repr__(self):
        return f"DotGatesWithNeighbors({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, DotGatesWithNeighbors):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, DotGatesWithNeighbors):
            return NotImplemented
        return self.not_equal(other)
