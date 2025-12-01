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
    def GateRelations_create_empty(cls, ) -> GateRelations:
        return cls(_CGateRelations.GateRelations_create_empty())

    @classmethod
    def GateRelations_create(cls, items: List) -> GateRelations:
        return cls(_CGateRelations.GateRelations_create(items._c))

    @classmethod
    def GateRelations_from_json_string(cls, json: str) -> GateRelations:
        return cls(_CGateRelations.GateRelations_from_json_string(json))

    def insert_or_assign(self, key: Connection, value: Connections) -> None:
        ret = self._c.insert_or_assign(key._c, value._c)
        return ret

    def insert(self, key: Connection, value: Connections) -> None:
        ret = self._c.insert(key._c, value._c)
        return ret

    def at(self, key: Connection) -> Connections:
        ret = self._c.at(key._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def erase(self, key: Connection) -> None:
        ret = self._c.erase(key._c)
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
        ret = self._c.contains(key._c)
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

    def equal(self, b: GateRelations) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: GateRelations) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, GateRelations):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, GateRelations):
            return NotImplemented
        return self.notequality(other)
