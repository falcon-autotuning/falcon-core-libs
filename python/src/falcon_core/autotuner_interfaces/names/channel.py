from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.channel import Channel as _CChannel

class Channel:
    """Python wrapper for Channel."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def Channel_create(cls, name: str) -> Channel:
        return cls(_CChannel.Channel_create(name))

    @classmethod
    def Channel_from_json_string(cls, json: str) -> Channel:
        return cls(_CChannel.Channel_from_json_string(json))

    def name(self, ) -> str:
        ret = self._c.name()
        return ret

    def equal(self, b: Channel) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Channel) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Channel):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Channel):
            return NotImplemented
        return self.notequality(other)
