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
    def new(cls, connection: Connection, resistance: Any, capacitance: Any) -> Impedance:
        return cls(_CImpedance.new(connection._c if connection is not None else None, resistance, capacitance))

    @classmethod
    def from_json(cls, json: str) -> Impedance:
        return cls(_CImpedance.from_json(json))

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

    def equal(self, other: Impedance) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Impedance) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Impedance):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Impedance):
            return NotImplemented
        return self.not_equal(other)
