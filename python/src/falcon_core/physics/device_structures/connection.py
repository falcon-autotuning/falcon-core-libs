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
    def from_json(cls, json: str) -> Connection:
        return cls(_CConnection.from_json(json))

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

    def copy(self, ) -> Connection:
        ret = self._c.copy()
        return Connection._from_capi(ret)

    def equal(self, other: Connection) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Connection) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def type(self, ) -> str:
        ret = self._c.type()
        return ret

    def is_dot_gate(self, ) -> bool:
        ret = self._c.is_dot_gate()
        return ret

    def is_barrier_gate(self, ) -> bool:
        ret = self._c.is_barrier_gate()
        return ret

    def is_plunger_gate(self, ) -> bool:
        ret = self._c.is_plunger_gate()
        return ret

    def is_reservoir_gate(self, ) -> bool:
        ret = self._c.is_reservoir_gate()
        return ret

    def is_screening_gate(self, ) -> bool:
        ret = self._c.is_screening_gate()
        return ret

    def is_ohmic(self, ) -> bool:
        ret = self._c.is_ohmic()
        return ret

    def is_gate(self, ) -> bool:
        ret = self._c.is_gate()
        return ret

    @property
    def name(self) -> str:
        ret = self._c.name()
        return ret

    def __repr__(self):
        return f"Connection({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

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
