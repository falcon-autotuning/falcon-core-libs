from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.port_transforms import PortTransforms as _CPortTransforms
from falcon_core.generic.list import List
from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform

class PortTransforms:
    """Python wrapper for PortTransforms."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def PortTransforms_create_empty(cls, ) -> PortTransforms:
        return cls(_CPortTransforms.PortTransforms_create_empty())

    @classmethod
    def PortTransforms_create_raw(cls, data: PortTransform, count: Any) -> PortTransforms:
        return cls(_CPortTransforms.PortTransforms_create_raw(data._c, count))

    @classmethod
    def PortTransforms_create(cls, handle: List) -> PortTransforms:
        return cls(_CPortTransforms.PortTransforms_create(handle._c))

    @classmethod
    def PortTransforms_from_json_string(cls, json: str) -> PortTransforms:
        return cls(_CPortTransforms.PortTransforms_from_json_string(json))

    def transforms(self, ) -> List:
        ret = self._c.transforms()
        if ret is None: return None
        return List(ret)

    def push_back(self, value: PortTransform) -> None:
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

    def at(self, idx: Any) -> PortTransform:
        ret = self._c.at(idx)
        if ret is None: return None
        return PortTransform._from_capi(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def contains(self, value: PortTransform) -> None:
        ret = self._c.contains(value._c)
        return ret

    def index(self, value: PortTransform) -> None:
        ret = self._c.index(value._c)
        return ret

    def intersection(self, other: PortTransforms) -> PortTransforms:
        ret = self._c.intersection(other._c)
        return cls._from_capi(ret)

    def equal(self, b: PortTransforms) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: PortTransforms) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, PortTransforms):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, PortTransforms):
            return NotImplemented
        return self.notequality(other)
