from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.standard_request import StandardRequest as _CStandardRequest

class StandardRequest:
    """Python wrapper for StandardRequest."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new(cls, message: str) -> StandardRequest:
        return cls(_CStandardRequest.new(message))

    @classmethod
    def from_json(cls, json: str) -> StandardRequest:
        return cls(_CStandardRequest.from_json(json))

    def message(self, ) -> str:
        ret = self._c.message()
        return ret

    def equal(self, other: StandardRequest) -> None:
        ret = self._c.equal(other._c)
        return ret

    def not_equal(self, other: StandardRequest) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, StandardRequest):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, StandardRequest):
            return NotImplemented
        return self.not_equal(other)
