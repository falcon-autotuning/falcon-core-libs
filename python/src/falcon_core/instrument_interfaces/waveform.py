from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.waveform import Waveform as _CWaveform
from falcon_core.math.axes_coupled_labelled_domain import AxesCoupledLabelledDomain
from falcon_core.math.axes_int import AxesInt
from falcon_core.math.axes_map_string_bool import AxesMapStringBool
from falcon_core.math.domains.coupled_labelled_domain import CoupledLabelledDomain
from falcon_core.math.discrete_spaces.discrete_space import DiscreteSpace
from falcon_core.math.domains.domain import Domain
from falcon_core.generic.list import List
from falcon_core.generic.map import Map
from falcon_core.instrument_interfaces.port_transforms.port_transform import PortTransform

class Waveform:
    """Python wrapper for Waveform."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def Waveform_create(cls, space: DiscreteSpace, transforms: List) -> Waveform:
        return cls(_CWaveform.Waveform_create(space._c, transforms._c))

    @classmethod
    def Waveform_create_cartesianwaveform(cls, divisions: AxesInt, axes: AxesCoupledLabelledDomain, increasing: AxesMapStringBool, transforms: List, domain: Domain) -> Waveform:
        return cls(_CWaveform.Waveform_create_cartesianwaveform(divisions._c, axes._c, increasing._c, transforms._c, domain._c))

    @classmethod
    def Waveform_create_cartesianidentitywaveform(cls, divisions: AxesInt, axes: AxesCoupledLabelledDomain, increasing: AxesMapStringBool, domain: Domain) -> Waveform:
        return cls(_CWaveform.Waveform_create_cartesianidentitywaveform(divisions._c, axes._c, increasing._c, domain._c))

    @classmethod
    def Waveform_create_cartesianwaveform2D(cls, divisions: AxesInt, axes: AxesCoupledLabelledDomain, increasing: AxesMapStringBool, transforms: List, domain: Domain) -> Waveform:
        return cls(_CWaveform.Waveform_create_cartesianwaveform2D(divisions._c, axes._c, increasing._c, transforms._c, domain._c))

    @classmethod
    def Waveform_create_cartesianidentitywaveform2D(cls, divisions: AxesInt, axes: AxesCoupledLabelledDomain, increasing: AxesMapStringBool, domain: Domain) -> Waveform:
        return cls(_CWaveform.Waveform_create_cartesianidentitywaveform2D(divisions._c, axes._c, increasing._c, domain._c))

    @classmethod
    def Waveform_create_cartesianwaveform1D(cls, division: Any, shared_domain: CoupledLabelledDomain, increasing: Map, transforms: List, domain: Domain) -> Waveform:
        return cls(_CWaveform.Waveform_create_cartesianwaveform1D(division, shared_domain._c, increasing._c, transforms._c, domain._c))

    @classmethod
    def Waveform_create_cartesianidentitywaveform1D(cls, division: Any, shared_domain: CoupledLabelledDomain, increasing: Map, domain: Domain) -> Waveform:
        return cls(_CWaveform.Waveform_create_cartesianidentitywaveform1D(division, shared_domain._c, increasing._c, domain._c))

    @classmethod
    def Waveform_from_json_string(cls, json: str) -> Waveform:
        return cls(_CWaveform.Waveform_from_json_string(json))

    def space(self, ) -> DiscreteSpace:
        ret = self._c.space()
        if ret is None: return None
        return DiscreteSpace._from_capi(ret)

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

    def intersection(self, other: Waveform) -> Waveform:
        ret = self._c.intersection(other._c)
        return cls._from_capi(ret)

    def equal(self, other: Waveform) -> None:
        ret = self._c.equal(other._c)
        return ret

    def not_equal(self, other: Waveform) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Waveform):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Waveform):
            return NotImplemented
        return self.notequality(other)
