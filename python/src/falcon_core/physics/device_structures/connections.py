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
    def Connections_create_empty(cls, ) -> Connections:
        return cls(_CConnections.Connections_create_empty())

    @classmethod
    def Connections_create(cls, items: List) -> Connections:
        return cls(_CConnections.Connections_create(items._c))

    @classmethod
    def Connections_from_json_string(cls, json: str) -> Connections:
        return cls(_CConnections.Connections_from_json_string(json))

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
        ret = self._c.intersection(other._c)
        return cls._from_capi(ret)

    def push_back(self, value: Connection) -> None:
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

    def const_at(self, idx: Any) -> const Connection:
        ret = self._c.const_at(idx)
        if ret is None: return None
        return const Connection._from_capi(ret)

    def at(self, idx: Any) -> Connection:
        ret = self._c.at(idx)
        if ret is None: return None
        return Connection._from_capi(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def contains(self, value: Connection) -> None:
        ret = self._c.contains(value._c)
        return ret

    def index(self, value: Connection) -> None:
        ret = self._c.index(value._c)
        return ret

    def equal(self, b: Connections) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Connections) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Connections):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Connections):
            return NotImplemented
        return self.notequality(other)
