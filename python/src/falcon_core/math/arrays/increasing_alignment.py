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
    def new_empty(cls, ) -> IncreasingAlignment:
        return cls(_CIncreasingAlignment.new_empty())

    @classmethod
    def new(cls, alignment: Any) -> IncreasingAlignment:
        return cls(_CIncreasingAlignment.new(alignment))

    @classmethod
    def from_json(cls, json: str) -> IncreasingAlignment:
        return cls(_CIncreasingAlignment.from_json(json))

    def alignment(self, ) -> None:
        ret = self._c.alignment()
        return ret

    def equal(self, b: IncreasingAlignment) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: IncreasingAlignment) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, IncreasingAlignment):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, IncreasingAlignment):
            return NotImplemented
        return self.not_equal(other)
