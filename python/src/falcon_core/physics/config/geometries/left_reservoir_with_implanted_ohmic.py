from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.left_reservoir_with_implanted_ohmic import LeftReservoirWithImplantedOhmic as _CLeftReservoirWithImplantedOhmic
from falcon_core.physics.device_structures.connection import Connection

class LeftReservoirWithImplantedOhmic:
    """Python wrapper for LeftReservoirWithImplantedOhmic."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new(cls, name: str, right_neighbor: Connection, ohmic: Connection) -> LeftReservoirWithImplantedOhmic:
        return cls(_CLeftReservoirWithImplantedOhmic.new(name, right_neighbor._c if right_neighbor is not None else None, ohmic._c if ohmic is not None else None))

    @classmethod
    def from_json(cls, json: str) -> LeftReservoirWithImplantedOhmic:
        return cls(_CLeftReservoirWithImplantedOhmic.from_json(json))

    def name(self, ) -> str:
        ret = self._c.name()
        return ret

    def type(self, ) -> str:
        ret = self._c.type()
        return ret

    def ohmic(self, ) -> Connection:
        ret = self._c.ohmic()
        if ret is None: return None
        return Connection._from_capi(ret)

    def right_neighbor(self, ) -> Connection:
        ret = self._c.right_neighbor()
        if ret is None: return None
        return Connection._from_capi(ret)

    def equal(self, other: LeftReservoirWithImplantedOhmic) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: LeftReservoirWithImplantedOhmic) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, LeftReservoirWithImplantedOhmic):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, LeftReservoirWithImplantedOhmic):
            return NotImplemented
        return self.not_equal(other)
