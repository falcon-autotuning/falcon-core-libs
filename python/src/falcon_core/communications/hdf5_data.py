from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.hdf5_data import HDF5Data as _CHDF5Data
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
from falcon_core.math.axes import Axes
from falcon_core.communications.voltage_states.device_voltage_states import DeviceVoltageStates
from falcon_core.math.arrays.labelled_arrays import LabelledArrays
from falcon_core.generic.map import Map
from falcon_core.communications.messages.measurement_request import MeasurementRequest
from falcon_core.communications.messages.measurement_response import MeasurementResponse
from falcon_core.generic.pair import Pair

class HDF5Data:
    """Python wrapper for HDF5Data."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> HDF5Data:
        return cls(_CHDF5Data.from_json(json))

    @classmethod
    def new(cls, shape: Axes, unit_domain: Axes, domain_labels: Axes, ranges: LabelledArrays, metadata: Map, measurement_title: str, unique_id: Any, timestamp: Any) -> HDF5Data:
        obj = cls(_CHDF5Data.new(shape._c if shape is not None else None, unit_domain._c if unit_domain is not None else None, domain_labels._c if domain_labels is not None else None, ranges._c if ranges is not None else None, metadata._c if metadata is not None else None, measurement_title, unique_id, timestamp))
        obj._ref_shape = shape  # Keep reference alive
        obj._ref_unit_domain = unit_domain  # Keep reference alive
        obj._ref_domain_labels = domain_labels  # Keep reference alive
        obj._ref_ranges = ranges  # Keep reference alive
        obj._ref_metadata = metadata  # Keep reference alive
        return obj

    @classmethod
    def new_from_file(cls, path: str) -> HDF5Data:
        return cls(_CHDF5Data.new_from_file(path))

    @classmethod
    def new_from_communications(cls, request: MeasurementRequest, response: MeasurementResponse, device_voltage_states: DeviceVoltageStates, session_id: Any, measurement_title: str, unique_id: Any, timestamp: Any) -> HDF5Data:
        obj = cls(_CHDF5Data.new_from_communications(request._c if request is not None else None, response._c if response is not None else None, device_voltage_states._c if device_voltage_states is not None else None, session_id, measurement_title, unique_id, timestamp))
        obj._ref_request = request  # Keep reference alive
        obj._ref_response = response  # Keep reference alive
        obj._ref_device_voltage_states = device_voltage_states  # Keep reference alive
        return obj

    def copy(self, ) -> HDF5Data:
        ret = self._c.copy()
        return HDF5Data._from_capi(ret)

    def equal(self, other: HDF5Data) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: HDF5Data) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def to_file(self, path: str) -> None:
        ret = self._c.to_file(path)
        return ret

    def to_communications(self, ) -> Pair:
        ret = self._c.to_communications()
        if ret is None: return None
        return Pair(ret)

    def shape(self, ) -> Axes:
        ret = self._c.shape()
        if ret is None: return None
        return Axes(ret)

    def unit_domain(self, ) -> Axes:
        ret = self._c.unit_domain()
        if ret is None: return None
        return Axes(ret)

    def domain_labels(self, ) -> Axes:
        ret = self._c.domain_labels()
        if ret is None: return None
        return Axes(ret)

    def ranges(self, ) -> LabelledArrays:
        ret = self._c.ranges()
        if ret is None: return None
        return LabelledArrays(ret)

    def metadata(self, ) -> Map:
        ret = self._c.metadata()
        if ret is None: return None
        return Map(ret)

    def measurement_title(self, ) -> str:
        ret = self._c.measurement_title()
        return ret

    def unique_id(self, ) -> int:
        ret = self._c.unique_id()
        return ret

    def timestamp(self, ) -> int:
        ret = self._c.timestamp()
        return ret

    def __repr__(self):
        return f"HDF5Data({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, HDF5Data):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, HDF5Data):
            return NotImplemented
        return self.not_equal(other)
