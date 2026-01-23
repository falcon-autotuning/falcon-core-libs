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
    def from_json(cls, json: str) -> IncreasingAlignment:
        return cls(_CIncreasingAlignment.from_json(json))

    @classmethod
    def new_empty(cls, ) -> IncreasingAlignment:
        return cls(_CIncreasingAlignment.new_empty())

    @classmethod
    def new(cls, alignment: Any) -> IncreasingAlignment:
        return cls(_CIncreasingAlignment.new(alignment))

    def copy(self, ) -> IncreasingAlignment:
        ret = self._c.copy()
        return IncreasingAlignment._from_capi(ret)

    def equal(self, other: IncreasingAlignment) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: IncreasingAlignment) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def alignment(self, ) -> int:
        ret = self._c.alignment()
        return ret

    def __repr__(self):
        return f"IncreasingAlignment({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

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
