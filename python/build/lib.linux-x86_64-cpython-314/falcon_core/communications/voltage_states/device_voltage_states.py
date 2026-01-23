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
        obj = cls(_CDeviceVoltageStates.new(items._c if items is not None else None))
        obj._ref_items = items  # Keep reference alive
        return obj

    @classmethod
    def from_json(cls, json: str) -> DeviceVoltageStates:
        return cls(_CDeviceVoltageStates.from_json(json))

    def states(self, ) -> List:
        ret = self._c.states()
        if ret is None: return None
        return List(ret)

    def add_state(self, state: DeviceVoltageState) -> None:
        ret = self._c.add_state(state._c if state is not None else None)
        return ret

    def find_state(self, connection: Connection) -> DeviceVoltageStates:
        ret = self._c.find_state(connection._c if connection is not None else None)
        return DeviceVoltageStates._from_capi(ret)

    def to_point(self, ) -> Point:
        ret = self._c.to_point()
        if ret is None: return None
        return Point._from_capi(ret)

    def intersection(self, other: DeviceVoltageStates) -> DeviceVoltageStates:
        ret = self._c.intersection(other._c if other is not None else None)
        return DeviceVoltageStates._from_capi(ret)

    def push_back(self, value: DeviceVoltageState) -> None:
        ret = self._c.push_back(value._c if value is not None else None)
        return ret

    def empty(self, ) -> bool:
        ret = self._c.empty()
        return ret

    def erase_at(self, idx: Any) -> None:
        ret = self._c.erase_at(idx)
        return ret

    def clear(self, ) -> None:
        ret = self._c.clear()
        return ret

    def at(self, idx: Any) -> DeviceVoltageState:
        ret = self._c.at(idx)
        if ret is None: return None
        return DeviceVoltageState._from_capi(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def contains(self, value: DeviceVoltageState) -> bool:
        ret = self._c.contains(value._c if value is not None else None)
        return ret

    def index(self, value: DeviceVoltageState) -> int:
        ret = self._c.index(value._c if value is not None else None)
        return ret

    def equal(self, b: DeviceVoltageStates) -> bool:
        ret = self._c.equal(b._c if b is not None else None)
        return ret

    def not_equal(self, b: DeviceVoltageStates) -> bool:
        ret = self._c.not_equal(b._c if b is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    @property
    def size(self) -> int:
        ret = self._c.size()
        return ret

    def __len__(self):
        return self.size

    def __getitem__(self, key):
        ret = self.at(key)
        if ret is None:
            raise IndexError(f"{key} not found in {self.__class__.__name__}")
        return ret

    def __iter__(self):
        for i in range(len(self)):
            yield self[i]

    def __contains__(self, key):
        return self.contains(key)

    def append(self, value):
        return self.push_back(value)

    @classmethod
    def from_list(cls, items):
        obj = cls(_CDeviceVoltageStates.from_list(items))
        # If items are wrappers, we might need to keep refs, but List usually copies.
        return obj

    def __repr__(self):
        return f"DeviceVoltageStates({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __add__(self, other):
        """Operator overload for +"""
        if hasattr(other, "_c") and type(other).__name__ == "State":
            return self.add_state(other)
        return NotImplemented

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

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
