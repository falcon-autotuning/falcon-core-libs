from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.right_reservoir_with_implanted_ohmic import RightReservoirWithImplantedOhmic as _CRightReservoirWithImplantedOhmic
from falcon_core.physics.device_structures.connection import Connection

class RightReservoirWithImplantedOhmic:
    """Python wrapper for RightReservoirWithImplantedOhmic."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new(cls, name: str, left_neighbor: Connection, ohmic: Connection) -> RightReservoirWithImplantedOhmic:
        return cls(_CRightReservoirWithImplantedOhmic.new(name, left_neighbor._c, ohmic._c))

    @classmethod
    def from_json(cls, json: str) -> RightReservoirWithImplantedOhmic:
        return cls(_CRightReservoirWithImplantedOhmic.from_json(json))

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

    def left_neighbor(self, ) -> Connection:
        ret = self._c.left_neighbor()
        if ret is None: return None
        return Connection._from_capi(ret)

    def equal(self, b: RightReservoirWithImplantedOhmic) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: RightReservoirWithImplantedOhmic) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, RightReservoirWithImplantedOhmic):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, RightReservoirWithImplantedOhmic):
            return NotImplemented
        return self.not_equal(other)
