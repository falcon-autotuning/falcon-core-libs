from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.discrete_space import DiscreteSpace as _CDiscreteSpace
from falcon_core.math.axes_coupled_labelled_domain import AxesCoupledLabelledDomain
from falcon_core.math.axes_instrument_port import AxesInstrumentPort
from falcon_core.math.axes_int import AxesInt
from falcon_core.math.axes_labelled_control_array import AxesLabelledControlArray
from falcon_core.math.axes_map_string_bool import AxesMapStringBool
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
    def DiscreteSpace_create(cls, space: UnitSpace, axes: AxesCoupledLabelledDomain, increasing: AxesMapStringBool) -> DiscreteSpace:
        return cls(_CDiscreteSpace.DiscreteSpace_create(space._c, axes._c, increasing._c))

    @classmethod
    def DiscreteSpace_create_cartesiandiscretespace(cls, divisions: AxesInt, axes: AxesCoupledLabelledDomain, increasing: AxesMapStringBool, domain: Domain) -> DiscreteSpace:
        return cls(_CDiscreteSpace.DiscreteSpace_create_cartesiandiscretespace(divisions._c, axes._c, increasing._c, domain._c))

    @classmethod
    def DiscreteSpace_create_cartesiandiscretespace1D(cls, division: Any, shared_domain: CoupledLabelledDomain, increasing: Map, domain: Domain) -> DiscreteSpace:
        return cls(_CDiscreteSpace.DiscreteSpace_create_cartesiandiscretespace1D(division, shared_domain._c, increasing._c, domain._c))

    @classmethod
    def DiscreteSpace_from_json_string(cls, json: str) -> DiscreteSpace:
        return cls(_CDiscreteSpace.DiscreteSpace_from_json_string(json))

    def space(self, ) -> UnitSpace:
        ret = self._c.space()
        if ret is None: return None
        return UnitSpace._from_capi(ret)

    def axes(self, ) -> AxesCoupledLabelledDomain:
        ret = self._c.axes()
        if ret is None: return None
        return AxesCoupledLabelledDomain._from_capi(ret)

    def increasing(self, ) -> AxesMapStringBool:
        ret = self._c.increasing()
        if ret is None: return None
        return AxesMapStringBool._from_capi(ret)

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
        ret = self._c.get_axis(knob._c)
        return ret

    def get_domain(self, knob: InstrumentPort) -> Domain:
        ret = self._c.get_domain(knob._c)
        if ret is None: return None
        return Domain._from_capi(ret)

    def get_projection(self, projection: AxesInstrumentPort) -> AxesLabelledControlArray:
        ret = self._c.get_projection(projection._c)
        if ret is None: return None
        return AxesLabelledControlArray._from_capi(ret)

    def equal(self, other: DiscreteSpace) -> None:
        ret = self._c.equal(other._c)
        return ret

    def __eq__(self, other: DiscreteSpace) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other: DiscreteSpace) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __ne__(self, other: DiscreteSpace) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
