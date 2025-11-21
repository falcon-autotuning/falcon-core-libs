from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.increasing_alignment import IncreasingAlignment as _CIncreasingAlignment

class IncreasingAlignment:
    """Python wrapper for IncreasingAlignment."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def IncreasingAlignment_create_empty(cls, ) -> IncreasingAlignment:
        return cls(_CIncreasingAlignment.IncreasingAlignment_create_empty())

    @classmethod
    def IncreasingAlignment_create(cls, alignment: Any) -> IncreasingAlignment:
        return cls(_CIncreasingAlignment.IncreasingAlignment_create(alignment))

    @classmethod
    def IncreasingAlignment_from_json_string(cls, json: str) -> IncreasingAlignment:
        return cls(_CIncreasingAlignment.IncreasingAlignment_from_json_string(json))

    def alignment(self, ) -> None:
        ret = self._c.alignment()
        return ret

    def equal(self, b: IncreasingAlignment) -> None:
        ret = self._c.equal(b._c)
        return ret

    def __eq__(self, b: IncreasingAlignment) -> None:
        if not hasattr(b, "_c"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b: IncreasingAlignment) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __ne__(self, b: IncreasingAlignment) -> None:
        if not hasattr(b, "_c"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
