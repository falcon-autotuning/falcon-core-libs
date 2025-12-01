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
    def LeftReservoirWithImplantedOhmic_create(cls, name: str, right_neighbor: Connection, ohmic: Connection) -> LeftReservoirWithImplantedOhmic:
        return cls(_CLeftReservoirWithImplantedOhmic.LeftReservoirWithImplantedOhmic_create(name, right_neighbor._c, ohmic._c))

    @classmethod
    def LeftReservoirWithImplantedOhmic_from_json_string(cls, json: str) -> LeftReservoirWithImplantedOhmic:
        return cls(_CLeftReservoirWithImplantedOhmic.LeftReservoirWithImplantedOhmic_from_json_string(json))

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

    def equal(self, b: LeftReservoirWithImplantedOhmic) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: LeftReservoirWithImplantedOhmic) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, LeftReservoirWithImplantedOhmic):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, LeftReservoirWithImplantedOhmic):
            return NotImplemented
        return self.notequality(other)
