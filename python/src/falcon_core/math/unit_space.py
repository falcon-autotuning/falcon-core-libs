from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.unit_space import UnitSpace as _CUnitSpace
from falcon_core.math.axes_discretizer import AxesDiscretizer
from falcon_core.math.axes_double import AxesDouble
from falcon_core.math.axes_int import AxesInt
from falcon_core.math.discrete_spaces.discretizer import Discretizer
from falcon_core.math.domains.domain import Domain
from falcon_core.generic.f_array_double import FArrayDouble
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
    def UnitSpace_create(cls, axes: AxesDiscretizer, domain: Domain) -> UnitSpace:
        return cls(_CUnitSpace.UnitSpace_create(axes._c, domain._c))

    @classmethod
    def UnitSpace_create_rayspace(cls, dr: Any, dtheta: Any, domain: Domain) -> UnitSpace:
        return cls(_CUnitSpace.UnitSpace_create_rayspace(dr, dtheta, domain._c))

    @classmethod
    def UnitSpace_create_cartesianspace(cls, deltas: AxesDouble, domain: Domain) -> UnitSpace:
        return cls(_CUnitSpace.UnitSpace_create_cartesianspace(deltas._c, domain._c))

    @classmethod
    def UnitSpace_create_cartesian1Dspace(cls, delta: Any, domain: Domain) -> UnitSpace:
        return cls(_CUnitSpace.UnitSpace_create_cartesian1Dspace(delta, domain._c))

    @classmethod
    def UnitSpace_create_cartesian2Dspace(cls, deltas: AxesDouble, domain: Domain) -> UnitSpace:
        return cls(_CUnitSpace.UnitSpace_create_cartesian2Dspace(deltas._c, domain._c))

    @classmethod
    def UnitSpace_create_array(cls, handle: UnitSpace, axes: AxesInt) -> UnitSpace:
        return cls(_CUnitSpace.UnitSpace_create_array(handle._c, axes._c))

    @classmethod
    def UnitSpace_from_json_string(cls, json: str) -> UnitSpace:
        return cls(_CUnitSpace.UnitSpace_from_json_string(json))

    def axes(self, ) -> AxesDiscretizer:
        ret = self._c.axes()
        if ret is None: return None
        return AxesDiscretizer._from_capi(ret)

    def domain(self, ) -> Domain:
        ret = self._c.domain()
        if ret is None: return None
        return Domain._from_capi(ret)

    def space(self, ) -> FArrayDouble:
        ret = self._c.space()
        if ret is None: return None
        return FArrayDouble._from_capi(ret)

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

    def at(self, idx: Any) -> Discretizer:
        ret = self._c.at(idx)
        if ret is None: return None
        return Discretizer._from_capi(ret)

    def items(self, out_buffer: Discretizer, buffer_size: Any) -> None:
        ret = self._c.items(out_buffer._c, buffer_size)
        return ret

    def contains(self, value: Discretizer) -> None:
        ret = self._c.contains(value._c)
        return ret

    def index(self, value: Discretizer) -> None:
        ret = self._c.index(value._c)
        return ret

    def intersection(self, other: UnitSpace) -> UnitSpace:
        ret = self._c.intersection(other._c)
        return cls._from_capi(ret)

    def equal(self, b: UnitSpace) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: UnitSpace) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, UnitSpace):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, UnitSpace):
            return NotImplemented
        return self.notequality(other)
