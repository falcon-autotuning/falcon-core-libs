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
    def Time_create_now(cls, ) -> Time:
        return cls(_CTime.Time_create_now())

    @classmethod
    def Time_create_at(cls, micro_seconds_since_epoch: Any) -> Time:
        return cls(_CTime.Time_create_at(micro_seconds_since_epoch))

    @classmethod
    def Time_from_json_string(cls, json: str) -> Time:
        return cls(_CTime.Time_from_json_string(json))

    def micro_seconds_since_epoch(self, ) -> None:
        ret = self._c.micro_seconds_since_epoch()
        return ret

    def time(self, ) -> None:
        ret = self._c.time()
        return ret

    def to_string(self, ) -> str:
        ret = self._c.to_string()
        return ret

    def equal(self, b: Time) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Time) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Time):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Time):
            return NotImplemented
        return self.notequality(other)
