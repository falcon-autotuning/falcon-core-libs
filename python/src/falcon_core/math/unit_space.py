from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.unit_space import UnitSpace as _CUnitSpace
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
from falcon_core.math.discrete_spaces.discretizer import Discretizer
from falcon_core.math.domains.domain import Domain
from falcon_core.generic.f_array import FArray
from falcon_core.generic.list import List

class UnitSpace:
    """Python wrapper for UnitSpace."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> UnitSpace:
        return cls(_CUnitSpace.from_json(json))

    @classmethod
    def new(cls, axes: Axes, domain: Domain) -> UnitSpace:
        obj = cls(_CUnitSpace.new(axes._c if axes is not None else None, domain._c if domain is not None else None))
        obj._ref_axes = axes  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_ray_space(cls, dr: Any, dtheta: Any, domain: Domain) -> UnitSpace:
        obj = cls(_CUnitSpace.new_ray_space(dr, dtheta, domain._c if domain is not None else None))
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_cartesian_space(cls, deltas: Axes, domain: Domain) -> UnitSpace:
        obj = cls(_CUnitSpace.new_cartesian_space(deltas._c if deltas is not None else None, domain._c if domain is not None else None))
        obj._ref_deltas = deltas  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_cartesian_1D_space(cls, delta: Any, domain: Domain) -> UnitSpace:
        obj = cls(_CUnitSpace.new_cartesian_1D_space(delta, domain._c if domain is not None else None))
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_cartesian_2D_space(cls, deltas: Axes, domain: Domain) -> UnitSpace:
        obj = cls(_CUnitSpace.new_cartesian_2D_space(deltas._c if deltas is not None else None, domain._c if domain is not None else None))
        obj._ref_deltas = deltas  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_array(cls, handle: UnitSpace, axes: Axes) -> UnitSpace:
        obj = cls(_CUnitSpace.new_array(handle._c if handle is not None else None, axes._c if axes is not None else None))
        obj._ref_handle = handle  # Keep reference alive
        obj._ref_axes = axes  # Keep reference alive
        return obj

    def copy(self, ) -> UnitSpace:
        ret = self._c.copy()
        return UnitSpace._from_capi(ret)

    def equal(self, other: UnitSpace) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: UnitSpace) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def axes(self, ) -> Axes:
        ret = self._c.axes()
        if ret is None: return None
        return Axes(ret)

    def domain(self, ) -> Domain:
        ret = self._c.domain()
        if ret is None: return None
        return Domain._from_capi(ret)

    def space(self, ) -> FArray:
        ret = self._c.space()
        if ret is None: return None
        return FArray(ret)

    def shape(self, ) -> List:
        ret = self._c.shape()
        if ret is None: return None
        return List(ret)

    def dimension(self, ) -> None:
        ret = self._c.dimension()
        return ret

    def compile(self, ) -> None:
        ret = self._c.compile()
        return ret

    def push_back(self, value: Discretizer) -> None:
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

    def at(self, idx: Any) -> Discretizer:
        ret = self._c.at(idx)
        if ret is None: return None
        return Discretizer._from_capi(ret)

    def items(self, out_buffer: Discretizer, buffer_size: Any) -> None:
        ret = self._c.items(out_buffer._c if out_buffer is not None else None, buffer_size)
        return ret

    def contains(self, value: Discretizer) -> None:
        ret = self._c.contains(value._c if value is not None else None)
        return ret

    def index(self, value: Discretizer) -> None:
        ret = self._c.index(value._c if value is not None else None)
        return ret

    def intersection(self, other: UnitSpace) -> UnitSpace:
        ret = self._c.intersection(other._c if other is not None else None)
        return UnitSpace._from_capi(ret)

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
        return cls(_CUnitSpace.from_list(items))

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, UnitSpace):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, UnitSpace):
            return NotImplemented
        return self.not_equal(other)
