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
    def StandardResponse_create(cls, message: str) -> StandardResponse:
        return cls(_CStandardResponse.StandardResponse_create(message))

    @classmethod
    def StandardResponse_from_json_string(cls, json: str) -> StandardResponse:
        return cls(_CStandardResponse.StandardResponse_from_json_string(json))

    def message(self, ) -> str:
        ret = self._c.message()
        return ret

    def equal(self, other: StandardResponse) -> None:
        ret = self._c.equal(other._c)
        return ret

    def __eq__(self, other: StandardResponse) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other: StandardResponse) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __ne__(self, other: StandardResponse) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
