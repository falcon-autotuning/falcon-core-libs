from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.discrete_space import DiscreteSpace as _CDiscreteSpace
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain
from falcon_core.math.domains.domain import Domain
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.generic.map import Map
from falcon_core.instrument_interfaces.names.ports import Ports
from falcon_core.math.unit_space import UnitSpace

class DiscreteSpace:
    """Python wrapper for DiscreteSpace."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new(cls, space: UnitSpace, axes: Axes, increasing: Axes) -> DiscreteSpace:
        return cls(_CDiscreteSpace.new(space._c if space is not None else None, axes._c if axes is not None else None, increasing._c if increasing is not None else None))

    @classmethod
    def new_cartesian_discrete_space(cls, divisions: Axes, axes: Axes, increasing: Axes, domain: Domain) -> DiscreteSpace:
        return cls(_CDiscreteSpace.new_cartesian_discrete_space(divisions._c if divisions is not None else None, axes._c if axes is not None else None, increasing._c if increasing is not None else None, domain._c if domain is not None else None))

    @classmethod
    def new_cartesian_discrete_space_1D(cls, division: Any, shared_domain: CoupledLabelledDomain, increasing: Map, domain: Domain) -> DiscreteSpace:
        return cls(_CDiscreteSpace.new_cartesian_discrete_space_1D(division, shared_domain._c if shared_domain is not None else None, increasing._c if increasing is not None else None, domain._c if domain is not None else None))

    @classmethod
    def from_json(cls, json: str) -> DiscreteSpace:
        return cls(_CDiscreteSpace.from_json(json))

    def space(self, ) -> UnitSpace:
        ret = self._c.space()
        if ret is None: return None
        return UnitSpace._from_capi(ret)

    def axes(self, ) -> Axes:
        ret = self._c.axes()
        if ret is None: return None
        return Axes(ret)

    def increasing(self, ) -> Axes:
        ret = self._c.increasing()
        if ret is None: return None
        return Axes(ret)

    def knobs(self, ) -> Ports:
        ret = self._c.knobs()
        if ret is None: return None
        return Ports._from_capi(ret)

    def validate_unit_space_dimensionality_matches_knobs(self, ) -> None:
        ret = self._c.validate_unit_space_dimensionality_matches_knobs()
        return ret

    def validate_knob_uniqueness(self, ) -> None:
        ret = self._c.validate_knob_uniqueness()
        return ret

    def get_axis(self, knob: InstrumentPort) -> None:
        ret = self._c.get_axis(knob._c if knob is not None else None)
        return ret

    def get_domain(self, knob: InstrumentPort) -> Domain:
        ret = self._c.get_domain(knob._c if knob is not None else None)
        if ret is None: return None
        return Domain._from_capi(ret)

    def get_projection(self, projection: Axes) -> Axes:
        ret = self._c.get_projection(projection._c if projection is not None else None)
        if ret is None: return None
        return Axes(ret)

    def equal(self, other: DiscreteSpace) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: DiscreteSpace) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, DiscreteSpace):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, DiscreteSpace):
            return NotImplemented
        return self.not_equal(other)
