from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.impedances import Impedances as _CImpedances
from falcon_core.physics.device_structures.impedance import Impedance
from falcon_core.generic.list import List

class Impedances:
    """Python wrapper for Impedances."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def Impedances_create_empty(cls, ) -> Impedances:
        return cls(_CImpedances.Impedances_create_empty())

    @classmethod
    def Impedances_create(cls, items: List) -> Impedances:
        return cls(_CImpedances.Impedances_create(items._c))

    @classmethod
    def Impedances_from_json_string(cls, json: str) -> Impedances:
        return cls(_CImpedances.Impedances_from_json_string(json))

    def push_back(self, value: Impedance) -> None:
        ret = self._c.push_back(value._c)
        return ret

    def size(self, ) -> None:
        ret = self._c.size()
        return ret

    def empty(self, ) -> None:
        ret = self._c.empty()
        return ret

    def erase_at(self, idx: Any) -> None:
        ret = self._c.erase_at(idx)
        return ret

    def clear(self, ) -> None:
        ret = self._c.clear()
        return ret

    def const_at(self, idx: Any) -> Impedance:
        ret = self._c.const_at(idx)
        if ret is None: return None
        return Impedance._from_capi(ret)

    def at(self, idx: Any) -> Impedance:
        ret = self._c.at(idx)
        if ret is None: return None
        return Impedance._from_capi(ret)

    def items(self, out_buffer: Impedance, buffer_size: Any) -> None:
        ret = self._c.items(out_buffer._c, buffer_size)
        return ret

    def contains(self, value: Impedance) -> None:
        ret = self._c.contains(value._c)
        return ret

    def intersection(self, b: Impedances) -> Impedances:
        ret = self._c.intersection(b._c)
        return cls._from_capi(ret)

    def index(self, value: Impedance) -> None:
        ret = self._c.index(value._c)
        return ret

    def equal(self, b: Impedances) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Impedances) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Impedances):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Impedances):
            return NotImplemented
        return self.notequality(other)
