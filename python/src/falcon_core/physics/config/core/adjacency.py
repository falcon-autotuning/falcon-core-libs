from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.adjacency import Adjacency as _CAdjacency
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.generic.f_array import FArray
from falcon_core.generic.list import List
from falcon_core.generic.list import List

class Adjacency:
    """Python wrapper for Adjacency."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new(cls, data: Any, shape: Any, ndim: Any, indexes: Connections) -> Adjacency:
        return cls(_CAdjacency.new(data, shape, ndim, indexes._c if indexes is not None else None))

    @classmethod
    def from_json(cls, json: str) -> Adjacency:
        return cls(_CAdjacency.from_json(json))

    def indexes(self, ) -> Connections:
        ret = self._c.indexes()
        if ret is None: return None
        return Connections._from_capi(ret)

    def indexes(self, ) -> Connections:
        ret = self._c.indexes()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_true_pairs(self, ) -> List:
        ret = self._c.get_true_pairs()
        if ret is None: return None
        return List(ret)

    def size(self, ) -> None:
        ret = self._c.size()
        return ret

    def dimension(self, ) -> None:
        ret = self._c.dimension()
        return ret

    def shape(self, out_buffer: Any, ndim: Any) -> None:
        ret = self._c.shape(out_buffer, ndim)
        return ret

    def data(self, out_buffer: Any, numdata: Any) -> None:
        ret = self._c.data(out_buffer, numdata)
        return ret

    def times_equals_farray(self, other: FArray) -> None:
        ret = self._c.times_equals_farray(other._c if other is not None else None)
        return ret

    def times_farray(self, other: FArray) -> Adjacency:
        ret = self._c.times_farray(other._c if other is not None else None)
        return Adjacency._from_capi(ret)

    def equal(self, other: Adjacency) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Adjacency) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def sum(self, ) -> None:
        ret = self._c.sum()
        return ret

    def where(self, value: Any) -> List:
        ret = self._c.where(value)
        if ret is None: return None
        return List(ret)

    def flip(self, axis: Any) -> Adjacency:
        ret = self._c.flip(axis)
        return Adjacency._from_capi(ret)

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __len__(self):
        return self.size()

    def __mul__(self, other):
        """Operator overload for *"""
        if hasattr(other, "_c") and type(other).__name__ == "EqualsFarray":
            return self.times_equals_farray(other)
        if hasattr(other, "_c") and type(other).__name__ in ["FArrayDouble", "FArrayInt", "FArray"]:
            return self.times_farray(other)
        return NotImplemented

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Adjacency):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Adjacency):
            return NotImplemented
        return self.not_equal(other)
