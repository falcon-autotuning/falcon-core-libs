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
    def from_json(cls, json: str) -> Gname:
        return cls(_CGname.from_json(json))

    @classmethod
    def new_from_num(cls, num: Any) -> Gname:
        return cls(_CGname.new_from_num(num))

    @classmethod
    def new(cls, name: str) -> Gname:
        return cls(_CGname.new(name))

    def copy(self, ) -> Gname:
        ret = self._c.copy()
        return Gname._from_capi(ret)

    def equal(self, other: Gname) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Gname) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def gname(self, ) -> str:
        ret = self._c.gname()
        return ret

    def __repr__(self):
        return f"Gname({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

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
