from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.gate_relations import GateRelations as _CGateRelations
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.generic.list import List
from falcon_core.generic.list import List
from falcon_core.generic.list import List

class GateRelations:
    """Python wrapper for GateRelations."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new_empty(cls, ) -> GateRelations:
        return cls(_CGateRelations.new_empty())

    @classmethod
    def new(cls, items: List) -> GateRelations:
        return cls(_CGateRelations.new(items._c if items is not None else None))

    @classmethod
    def from_json(cls, json: str) -> GateRelations:
        return cls(_CGateRelations.from_json(json))

    def insert_or_assign(self, key: Connection, value: Connections) -> None:
        ret = self._c.insert_or_assign(key._c if key is not None else None, value._c if value is not None else None)
        return ret

    def insert(self, key: Connection, value: Connections) -> None:
        ret = self._c.insert(key._c if key is not None else None, value._c if value is not None else None)
        return ret

    def at(self, key: Connection) -> Connections:
        ret = self._c.at(key._c if key is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def erase(self, key: Connection) -> None:
        ret = self._c.erase(key._c if key is not None else None)
        return ret

    def size(self, ) -> None:
        ret = self._c.size()
        return ret

    def empty(self, ) -> None:
        ret = self._c.empty()
        return ret

    def clear(self, ) -> None:
        ret = self._c.clear()
        return ret

    def contains(self, key: Connection) -> None:
        ret = self._c.contains(key._c if key is not None else None)
        return ret

    def keys(self, ) -> List:
        ret = self._c.keys()
        if ret is None: return None
        return List(ret)

    def values(self, ) -> List:
        ret = self._c.values()
        if ret is None: return None
        return List(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def equal(self, other: GateRelations) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: GateRelations) -> None:
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

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, GateRelations):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, GateRelations):
            return NotImplemented
        return self.not_equal(other)
