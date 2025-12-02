from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.connection import Connection as _CConnection

class Connection:
    """Python wrapper for Connection."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new_barrier(cls, name: str) -> Connection:
        return cls(_CConnection.new_barrier(name))

    @classmethod
    def new_plunger(cls, name: str) -> Connection:
        return cls(_CConnection.new_plunger(name))

    @classmethod
    def new_reservoir(cls, name: str) -> Connection:
        return cls(_CConnection.new_reservoir(name))

    @classmethod
    def new_screening(cls, name: str) -> Connection:
        return cls(_CConnection.new_screening(name))

    @classmethod
    def new_ohmic(cls, name: str) -> Connection:
        return cls(_CConnection.new_ohmic(name))

    @classmethod
    def from_json(cls, json: str) -> Connection:
        return cls(_CConnection.from_json(json))

    def name(self, ) -> str:
        ret = self._c.name()
        return ret

    def type(self, ) -> str:
        ret = self._c.type()
        return ret

    def is_dot_gate(self, ) -> None:
        ret = self._c.is_dot_gate()
        return ret

    def is_barrier_gate(self, ) -> None:
        ret = self._c.is_barrier_gate()
        return ret

    def is_plunger_gate(self, ) -> None:
        ret = self._c.is_plunger_gate()
        return ret

    def is_reservoir_gate(self, ) -> None:
        ret = self._c.is_reservoir_gate()
        return ret

    def is_screening_gate(self, ) -> None:
        ret = self._c.is_screening_gate()
        return ret

    def is_ohmic(self, ) -> None:
        ret = self._c.is_ohmic()
        return ret

    def is_gate(self, ) -> None:
        ret = self._c.is_gate()
        return ret

    def equal(self, b: Connection) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Connection) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Connection):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Connection):
            return NotImplemented
        return self.not_equal(other)
