from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.gname import Gname as _CGname

class Gname:
    """Python wrapper for Gname."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new_from_num(cls, num: Any) -> Gname:
        return cls(_CGname.new_from_num(num))

    @classmethod
    def new(cls, name: str) -> Gname:
        return cls(_CGname.new(name))

    @classmethod
    def from_json(cls, json: str) -> Gname:
        return cls(_CGname.from_json(json))

    def gname(self, ) -> str:
        ret = self._c.gname()
        return ret

    def equal(self, b: Gname) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Gname) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Gname):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Gname):
            return NotImplemented
        return self.not_equal(other)
