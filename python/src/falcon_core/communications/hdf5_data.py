from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.hdf5_data import HDF5Data as _CHDF5Data
from falcon_core.math.axes_control_array import AxesControlArray
from falcon_core.math.axes_coupled_labelled_domain import AxesCoupledLabelledDomain
from falcon_core.math.axes_int import AxesInt
from falcon_core.communications.voltage_states.device_voltage_states import DeviceVoltageStates
from falcon_core.math.arrays.labelled_arrays_labelled_measured_array import LabelledArraysLabelledMeasuredArray
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
    def HDF5Data_create(cls, shape: AxesInt, unit_domain: AxesControlArray, domain_labels: AxesCoupledLabelledDomain, ranges: LabelledArraysLabelledMeasuredArray, metadata: Map, measurement_title: str, unique_id: Any, timestamp: Any) -> HDF5Data:
        return cls(_CHDF5Data.HDF5Data_create(shape._c, unit_domain._c, domain_labels._c, ranges._c, metadata._c, measurement_title, unique_id, timestamp))

    @classmethod
    def HDF5Data_create_from_file(cls, path: str) -> HDF5Data:
        return cls(_CHDF5Data.HDF5Data_create_from_file(path))

    @classmethod
    def HDF5Data_create_from_communications(cls, request: MeasurementRequest, response: MeasurementResponse, device_voltage_states: DeviceVoltageStates, session_id[16]: Any, measurement_title: str, unique_id: Any, timestamp: Any) -> HDF5Data:
        return cls(_CHDF5Data.HDF5Data_create_from_communications(request._c, response._c, device_voltage_states._c, session_id[16], measurement_title, unique_id, timestamp))

    @classmethod
    def HDF5Data_from_json_string(cls, json: str) -> HDF5Data:
        return cls(_CHDF5Data.HDF5Data_from_json_string(json))

    def to_file(self, path: str) -> None:
        ret = self._c.to_file(path)
        return ret

    def to_communications(self, ) -> Pair:
        ret = self._c.to_communications()
        if ret is None: return None
        return Pair(ret)

    def equal(self, other: HDF5Data) -> None:
        ret = self._c.equal(other._c)
        return ret

    def __eq__(self, other: HDF5Data) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other: HDF5Data) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __ne__(self, other: HDF5Data) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
