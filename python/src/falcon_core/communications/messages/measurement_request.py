from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.measurement_request import MeasurementRequest as _CMeasurementRequest
from falcon_core.math.domains.labelled_domain import LabelledDomain
from falcon_core.generic.list import List
from falcon_core.generic.map import Map
from falcon_core.instrument_interfaces.names.ports import Ports

class MeasurementRequest:
    """Python wrapper for MeasurementRequest."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> MeasurementRequest:
        return cls(_CMeasurementRequest.from_json(json))

    @classmethod
    def new(cls, message: str, measurement_name: str, waveforms: List, getters: Ports, meter_transforms: Map, time_domain: LabelledDomain) -> MeasurementRequest:
        obj = cls(_CMeasurementRequest.new(message, measurement_name, waveforms._c if waveforms is not None else None, getters._c if getters is not None else None, meter_transforms._c if meter_transforms is not None else None, time_domain._c if time_domain is not None else None))
        obj._ref_waveforms = waveforms  # Keep reference alive
        obj._ref_getters = getters  # Keep reference alive
        obj._ref_meter_transforms = meter_transforms  # Keep reference alive
        obj._ref_time_domain = time_domain  # Keep reference alive
        return obj

    def copy(self, ) -> MeasurementRequest:
        ret = self._c.copy()
        return MeasurementRequest._from_capi(ret)

    def equal(self, other: MeasurementRequest) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: MeasurementRequest) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def measurement_name(self, ) -> str:
        ret = self._c.measurement_name()
        return ret

    def getters(self, ) -> Ports:
        ret = self._c.getters()
        if ret is None: return None
        return Ports._from_capi(ret)

    def waveforms(self, ) -> List:
        ret = self._c.waveforms()
        if ret is None: return None
        return List(ret)

    def meter_transforms(self, ) -> Map:
        ret = self._c.meter_transforms()
        if ret is None: return None
        return Map(ret)

    def time_domain(self, ) -> LabelledDomain:
        ret = self._c.time_domain()
        if ret is None: return None
        return LabelledDomain._from_capi(ret)

    def message(self, ) -> str:
        ret = self._c.message()
        return ret

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, MeasurementRequest):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, MeasurementRequest):
            return NotImplemented
        return self.not_equal(other)
