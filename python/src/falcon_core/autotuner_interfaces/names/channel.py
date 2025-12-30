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
    def from_json(cls, json: str) -> Channel:
        return cls(_CChannel.from_json(json))

    @classmethod
    def new(cls, name: str) -> Channel:
        return cls(_CChannel.new(name))

    def copy(self, ) -> Channel:
        ret = self._c.copy()
        return Channel._from_capi(ret)

    def equal(self, other: Channel) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Channel) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def name(self, ) -> str:
        ret = self._c.name()
        return ret

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Channel):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Channel):
            return NotImplemented
        return self.not_equal(other)
