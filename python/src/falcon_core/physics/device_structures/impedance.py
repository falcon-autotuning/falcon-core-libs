from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.impedance import Impedance as _CImpedance
from falcon_core.physics.device_structures.connection import Connection

class Impedance:
    """Python wrapper for Impedance."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def Impedance_create(cls, connection: Connection, resistance: Any, capacitance: Any) -> Impedance:
        return cls(_CImpedance.Impedance_create(connection._c, resistance, capacitance))

    @classmethod
    def Impedance_from_json_string(cls, json: str) -> Impedance:
        return cls(_CImpedance.Impedance_from_json_string(json))

    def connection(self, ) -> Connection:
        ret = self._c.connection()
        if ret is None: return None
        return Connection._from_capi(ret)

    def resistance(self, ) -> None:
        ret = self._c.resistance()
        return ret

    def capacitance(self, ) -> None:
        ret = self._c.capacitance()
        return ret

    def equal(self, b: Impedance) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Impedance) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Impedance):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Impedance):
            return NotImplemented
        return self.notequality(other)
