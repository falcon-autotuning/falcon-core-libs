from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.standard_response import StandardResponse as _CStandardResponse

class StandardResponse:
    """Python wrapper for StandardResponse."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> StandardResponse:
        return cls(_CStandardResponse.from_json(json))

    @classmethod
    def new(cls, message: str) -> StandardResponse:
        return cls(_CStandardResponse.new(message))

    def copy(self, ) -> StandardResponse:
        ret = self._c.copy()
        return StandardResponse._from_capi(ret)

    def equal(self, other: StandardResponse) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: StandardResponse) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def message(self, ) -> str:
        ret = self._c.message()
        return ret

    def __repr__(self):
        return f"StandardResponse({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, StandardResponse):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, StandardResponse):
            return NotImplemented
        return self.not_equal(other)
