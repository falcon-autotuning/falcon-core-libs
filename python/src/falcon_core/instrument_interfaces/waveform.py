from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.waveform import Waveform as _CWaveform
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
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
    def new(cls, space: DiscreteSpace, transforms: List) -> Waveform:
        obj = cls(_CWaveform.new(space._c if space is not None else None, transforms._c if transforms is not None else None))
        obj._ref_space = space  # Keep reference alive
        obj._ref_transforms = transforms  # Keep reference alive
        return obj

    @classmethod
    def new_cartesian_waveform(cls, divisions: Axes, axes: Axes, increasing: Axes, transforms: List, domain: Domain) -> Waveform:
        obj = cls(_CWaveform.new_cartesian_waveform(divisions._c if divisions is not None else None, axes._c if axes is not None else None, increasing._c if increasing is not None else None, transforms._c if transforms is not None else None, domain._c if domain is not None else None))
        obj._ref_divisions = divisions  # Keep reference alive
        obj._ref_axes = axes  # Keep reference alive
        obj._ref_increasing = increasing  # Keep reference alive
        obj._ref_transforms = transforms  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_cartesian_identity_waveform(cls, divisions: Axes, axes: Axes, increasing: Axes, domain: Domain) -> Waveform:
        obj = cls(_CWaveform.new_cartesian_identity_waveform(divisions._c if divisions is not None else None, axes._c if axes is not None else None, increasing._c if increasing is not None else None, domain._c if domain is not None else None))
        obj._ref_divisions = divisions  # Keep reference alive
        obj._ref_axes = axes  # Keep reference alive
        obj._ref_increasing = increasing  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_cartesian_waveform_2D(cls, divisions: Axes, axes: Axes, increasing: Axes, transforms: List, domain: Domain) -> Waveform:
        obj = cls(_CWaveform.new_cartesian_waveform_2D(divisions._c if divisions is not None else None, axes._c if axes is not None else None, increasing._c if increasing is not None else None, transforms._c if transforms is not None else None, domain._c if domain is not None else None))
        obj._ref_divisions = divisions  # Keep reference alive
        obj._ref_axes = axes  # Keep reference alive
        obj._ref_increasing = increasing  # Keep reference alive
        obj._ref_transforms = transforms  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_cartesian_identity_waveform_2D(cls, divisions: Axes, axes: Axes, increasing: Axes, domain: Domain) -> Waveform:
        obj = cls(_CWaveform.new_cartesian_identity_waveform_2D(divisions._c if divisions is not None else None, axes._c if axes is not None else None, increasing._c if increasing is not None else None, domain._c if domain is not None else None))
        obj._ref_divisions = divisions  # Keep reference alive
        obj._ref_axes = axes  # Keep reference alive
        obj._ref_increasing = increasing  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_cartesian_waveform_1D(cls, division: Any, shared_domain: CoupledLabelledDomain, increasing: Map, transforms: List, domain: Domain) -> Waveform:
        obj = cls(_CWaveform.new_cartesian_waveform_1D(division, shared_domain._c if shared_domain is not None else None, increasing._c if increasing is not None else None, transforms._c if transforms is not None else None, domain._c if domain is not None else None))
        obj._ref_shared_domain = shared_domain  # Keep reference alive
        obj._ref_increasing = increasing  # Keep reference alive
        obj._ref_transforms = transforms  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_cartesian_identity_waveform_1D(cls, division: Any, shared_domain: CoupledLabelledDomain, increasing: Map, domain: Domain) -> Waveform:
        obj = cls(_CWaveform.new_cartesian_identity_waveform_1D(division, shared_domain._c if shared_domain is not None else None, increasing._c if increasing is not None else None, domain._c if domain is not None else None))
        obj._ref_shared_domain = shared_domain  # Keep reference alive
        obj._ref_increasing = increasing  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def from_json(cls, json: str) -> Waveform:
        return cls(_CWaveform.from_json(json))

    def space(self, ) -> DiscreteSpace:
        ret = self._c.space()
        if ret is None: return None
        return DiscreteSpace._from_capi(ret)

    def transforms(self, ) -> List:
        ret = self._c.transforms()
        if ret is None: return None
        return List(ret)

    def push_back(self, value: PortTransform) -> None:
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

    def at(self, idx: Any) -> PortTransform:
        ret = self._c.at(idx)
        if ret is None: return None
        return PortTransform._from_capi(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def contains(self, value: PortTransform) -> None:
        ret = self._c.contains(value._c if value is not None else None)
        return ret

    def index(self, value: PortTransform) -> None:
        ret = self._c.index(value._c if value is not None else None)
        return ret

    def intersection(self, other: Waveform) -> Waveform:
        ret = self._c.intersection(other._c if other is not None else None)
        return Waveform._from_capi(ret)

    def equal(self, other: Waveform) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Waveform) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
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
        return cls(_CWaveform.from_list(items))

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Waveform):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Waveform):
            return NotImplemented
        return self.not_equal(other)
