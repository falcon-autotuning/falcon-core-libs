from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.device_voltage_states import DeviceVoltageStates as _CDeviceVoltageStates
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.communications.voltage_states.device_voltage_state import DeviceVoltageState
from falcon_core.generic.list import List
from falcon_core.math.point import Point

class DeviceVoltageStates:
    """Python wrapper for DeviceVoltageStates."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new_empty(cls, ) -> DeviceVoltageStates:
        return cls(_CDeviceVoltageStates.new_empty())

    @classmethod
    def new(cls, items: List) -> DeviceVoltageStates:
        return cls(_CDeviceVoltageStates.new(items._c))

    @classmethod
    def from_json(cls, json: str) -> DeviceVoltageStates:
        return cls(_CDeviceVoltageStates.from_json(json))

    def states(self, ) -> List:
        ret = self._c.states()
        if ret is None: return None
        return List(ret)

    def add_state(self, state: DeviceVoltageState) -> None:
        ret = self._c.add_state(state._c)
        return ret

    def find_state(self, connection: Connection) -> DeviceVoltageStates:
        ret = self._c.find_state(connection._c)
        return cls._from_capi(ret)

    def to_point(self, ) -> Point:
        ret = self._c.to_point()
        if ret is None: return None
        return Point._from_capi(ret)

    def intersection(self, other: DeviceVoltageStates) -> DeviceVoltageStates:
        ret = self._c.intersection(other._c)
        return cls._from_capi(ret)

    def push_back(self, value: DeviceVoltageState) -> None:
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

    def const_at(self, idx: Any) -> DeviceVoltageState:
        ret = self._c.const_at(idx)
        if ret is None: return None
        return DeviceVoltageState._from_capi(ret)

    def at(self, idx: Any) -> DeviceVoltageState:
        ret = self._c.at(idx)
        if ret is None: return None
        return DeviceVoltageState._from_capi(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def contains(self, value: DeviceVoltageState) -> None:
        ret = self._c.contains(value._c)
        return ret

    def index(self, value: DeviceVoltageState) -> None:
        ret = self._c.index(value._c)
        return ret

    def equal(self, b: DeviceVoltageStates) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: DeviceVoltageStates) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __add__(self, other):
        """Operator overload for +"""
        if hasattr(other, "_c") and type(other).__name__ == "State":
            return self.add_state(other)
        return NotImplemented

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, DeviceVoltageStates):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, DeviceVoltageStates):
            return NotImplemented
        return self.not_equal(other)
