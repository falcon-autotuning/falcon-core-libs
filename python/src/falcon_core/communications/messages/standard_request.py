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
    def StandardRequest_create(cls, message: str) -> StandardRequest:
        return cls(_CStandardRequest.StandardRequest_create(message))

    @classmethod
    def StandardRequest_from_json_string(cls, json: str) -> StandardRequest:
        return cls(_CStandardRequest.StandardRequest_from_json_string(json))

    def message(self, ) -> str:
        ret = self._c.message()
        return ret

    def equal(self, other: StandardRequest) -> None:
        ret = self._c.equal(other._c)
        return ret

    def __eq__(self, other: StandardRequest) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other: StandardRequest) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __ne__(self, other: StandardRequest) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
