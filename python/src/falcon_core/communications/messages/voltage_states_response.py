from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.voltage_states_response import VoltageStatesResponse as _CVoltageStatesResponse
from falcon_core.communications.voltage_states.device_voltage_states import DeviceVoltageStates

class VoltageStatesResponse:
    """Python wrapper for VoltageStatesResponse."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new(cls, message: str, states: DeviceVoltageStates) -> VoltageStatesResponse:
        return cls(_CVoltageStatesResponse.new(message, states._c))

    @classmethod
    def from_json(cls, json: str) -> VoltageStatesResponse:
        return cls(_CVoltageStatesResponse.from_json(json))

    def message(self, ) -> str:
        ret = self._c.message()
        return ret

    def states(self, ) -> DeviceVoltageStates:
        ret = self._c.states()
        if ret is None: return None
        return DeviceVoltageStates._from_capi(ret)

    def equal(self, other: VoltageStatesResponse) -> None:
        ret = self._c.equal(other._c)
        return ret

    def not_equal(self, other: VoltageStatesResponse) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, VoltageStatesResponse):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, VoltageStatesResponse):
            return NotImplemented
        return self.not_equal(other)
