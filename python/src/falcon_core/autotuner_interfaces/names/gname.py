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
    def Gname_create_from_num(cls, num: Any) -> Gname:
        return cls(_CGname.Gname_create_from_num(num))

    @classmethod
    def Gname_create(cls, name: str) -> Gname:
        return cls(_CGname.Gname_create(name))

    @classmethod
    def Gname_from_json_string(cls, json: str) -> Gname:
        return cls(_CGname.Gname_from_json_string(json))

    def gname(self, ) -> str:
        ret = self._c.gname()
        return ret

    def equal(self, b: Gname) -> None:
        ret = self._c.equal(b._c)
        return ret

    def __eq__(self, b: Gname) -> None:
        if not hasattr(b, "_c"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b: Gname) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __ne__(self, b: Gname) -> None:
        if not hasattr(b, "_c"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
