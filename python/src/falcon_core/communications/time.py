from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.time import Time as _CTime

class Time:
    """Python wrapper for Time."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> Time:
        return cls(_CTime.from_json(json))

    @classmethod
    def new_now(cls, ) -> Time:
        return cls(_CTime.new_now())

    @classmethod
    def new_at(cls, micro_seconds_since_epoch: Any) -> Time:
        return cls(_CTime.new_at(micro_seconds_since_epoch))

    def copy(self, ) -> Time:
        ret = self._c.copy()
        return Time._from_capi(ret)

    def equal(self, other: Time) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Time) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def micro_seconds_since_epoch(self, ) -> Any:
        ret = self._c.micro_seconds_since_epoch()
        return ret

    def time(self, ) -> Any:
        ret = self._c.time()
        return ret

    def to_string(self, ) -> str:
        ret = self._c.to_string()
        return ret

    def __repr__(self):
        return f"Time({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Time):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Time):
            return NotImplemented
        return self.not_equal(other)
