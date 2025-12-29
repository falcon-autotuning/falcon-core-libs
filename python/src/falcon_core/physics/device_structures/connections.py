from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.connections import Connections as _CConnections
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.generic.list import List

class Connections:
    """Python wrapper for Connections."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new_empty(cls, ) -> Connections:
        return cls(_CConnections.new_empty())

    @classmethod
    def new(cls, items: List) -> Connections:
        obj = cls(_CConnections.new(items._c if items is not None else None))
        obj._ref_items = items  # Keep reference alive
        return obj

    @classmethod
    def from_json(cls, json: str) -> Connections:
        return cls(_CConnections.from_json(json))

    def is_gates(self, ) -> None:
        ret = self._c.is_gates()
        return ret

    def is_ohmics(self, ) -> None:
        ret = self._c.is_ohmics()
        return ret

    def is_dot_gates(self, ) -> None:
        ret = self._c.is_dot_gates()
        return ret

    def is_plunger_gates(self, ) -> None:
        ret = self._c.is_plunger_gates()
        return ret

    def is_barrier_gates(self, ) -> None:
        ret = self._c.is_barrier_gates()
        return ret

    def is_reservoir_gates(self, ) -> None:
        ret = self._c.is_reservoir_gates()
        return ret

    def is_screening_gates(self, ) -> None:
        ret = self._c.is_screening_gates()
        return ret

    def intersection(self, other: Connections) -> Connections:
        ret = self._c.intersection(other._c if other is not None else None)
        return Connections._from_capi(ret)

    def push_back(self, value: Connection) -> None:
        ret = self._c.push_back(value._c if value is not None else None)
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

    def at(self, idx: Any) -> Connection:
        ret = self._c.at(idx)
        if ret is None: return None
        return Connection._from_capi(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def contains(self, value: Connection) -> None:
        ret = self._c.contains(value._c if value is not None else None)
        return ret

    def index(self, value: Connection) -> None:
        ret = self._c.index(value._c if value is not None else None)
        return ret

    def equal(self, other: Connections) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Connections) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

    def append(self, value):
        return self.push_back(value)

    @classmethod
    def from_list(cls, items):
        return cls(_CConnections.from_list(items))

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Connections):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Connections):
            return NotImplemented
        return self.not_equal(other)
