from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.channels import Channels as _CChannels
from falcon_core.autotuner_interfaces.names.channel import Channel
from falcon_core.generic.list import List
from falcon_core.generic.list import List

class Channels:
    """Python wrapper for Channels."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new_empty(cls, ) -> Channels:
        return cls(_CChannels.new_empty())

    @classmethod
    def new(cls, items: List) -> Channels:
        return cls(_CChannels.new(items._c if items is not None else None))

    @classmethod
    def from_json(cls, json: str) -> Channels:
        return cls(_CChannels.from_json(json))

    def intersection(self, other: Channels) -> Channels:
        ret = self._c.intersection(other._c if other is not None else None)
        return Channels._from_capi(ret)

    def push_back(self, value: Channel) -> None:
        ret = self._c.push_back(value._c if value is not None else None)
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

    def at(self, idx: Any) -> Channel:
        ret = self._c.at(idx)
        if ret is None: return None
        return Channel._from_capi(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def contains(self, value: Channel) -> None:
        ret = self._c.contains(value._c if value is not None else None)
        return ret

    def index(self, value: Channel) -> None:
        ret = self._c.index(value._c if value is not None else None)
        return ret

    def equal(self, b: Channels) -> None:
        ret = self._c.equal(b._c if b is not None else None)
        return ret

    def not_equal(self, b: Channels) -> None:
        ret = self._c.not_equal(b._c if b is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

    def append(self, value):
        return self.push_back(value)

    @classmethod
    def from_list(cls, items):
        return cls(_CChannels.from_list(items))

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Channels):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Channels):
            return NotImplemented
        return self.not_equal(other)
