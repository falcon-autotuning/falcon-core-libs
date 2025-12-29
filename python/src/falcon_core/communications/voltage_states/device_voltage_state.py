from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.device_voltage_state import DeviceVoltageState as _CDeviceVoltageState
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.units.symbol_unit import SymbolUnit

class DeviceVoltageState:
    """Python wrapper for DeviceVoltageState."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new(cls, connection: Connection, voltage: Any, unit: SymbolUnit) -> DeviceVoltageState:
        obj = cls(_CDeviceVoltageState.new(connection._c if connection is not None else None, voltage, unit._c if unit is not None else None))
        obj._ref_connection = connection  # Keep reference alive
        obj._ref_unit = unit  # Keep reference alive
        return obj

    @classmethod
    def from_json(cls, json: str) -> DeviceVoltageState:
        return cls(_CDeviceVoltageState.from_json(json))

    def connection(self, ) -> Connection:
        ret = self._c.connection()
        if ret is None: return None
        return Connection._from_capi(ret)

    def voltage(self, ) -> None:
        ret = self._c.voltage()
        return ret

    def value(self, ) -> None:
        ret = self._c.value()
        return ret

    def unit(self, ) -> SymbolUnit:
        ret = self._c.unit()
        if ret is None: return None
        return SymbolUnit._from_capi(ret)

    def convert_to(self, target_unit: SymbolUnit) -> None:
        ret = self._c.convert_to(target_unit._c if target_unit is not None else None)
        return ret

    def multiply_int(self, other: Any) -> DeviceVoltageState:
        ret = self._c.multiply_int(other)
        return DeviceVoltageState._from_capi(ret)

    def multiply_double(self, other: Any) -> DeviceVoltageState:
        ret = self._c.multiply_double(other)
        return DeviceVoltageState._from_capi(ret)

    def multiply_quantity(self, other: DeviceVoltageState) -> DeviceVoltageState:
        ret = self._c.multiply_quantity(other._c if other is not None else None)
        return DeviceVoltageState._from_capi(ret)

    def multiply_equals_int(self, other: Any) -> DeviceVoltageState:
        ret = self._c.multiply_equals_int(other)
        return DeviceVoltageState._from_capi(ret)

    def multiply_equals_double(self, other: Any) -> DeviceVoltageState:
        ret = self._c.multiply_equals_double(other)
        return DeviceVoltageState._from_capi(ret)

    def multiply_equals_quantity(self, other: DeviceVoltageState) -> DeviceVoltageState:
        ret = self._c.multiply_equals_quantity(other._c if other is not None else None)
        return DeviceVoltageState._from_capi(ret)

    def divide_int(self, other: Any) -> DeviceVoltageState:
        ret = self._c.divide_int(other)
        return DeviceVoltageState._from_capi(ret)

    def divide_double(self, other: Any) -> DeviceVoltageState:
        ret = self._c.divide_double(other)
        return DeviceVoltageState._from_capi(ret)

    def divide_quantity(self, other: DeviceVoltageState) -> DeviceVoltageState:
        ret = self._c.divide_quantity(other._c if other is not None else None)
        return DeviceVoltageState._from_capi(ret)

    def divide_equals_int(self, other: Any) -> DeviceVoltageState:
        ret = self._c.divide_equals_int(other)
        return DeviceVoltageState._from_capi(ret)

    def divide_equals_double(self, other: Any) -> DeviceVoltageState:
        ret = self._c.divide_equals_double(other)
        return DeviceVoltageState._from_capi(ret)

    def divide_equals_quantity(self, other: DeviceVoltageState) -> DeviceVoltageState:
        ret = self._c.divide_equals_quantity(other._c if other is not None else None)
        return DeviceVoltageState._from_capi(ret)

    def power(self, other: Any) -> DeviceVoltageState:
        ret = self._c.power(other)
        return DeviceVoltageState._from_capi(ret)

    def add_quantity(self, other: DeviceVoltageState) -> DeviceVoltageState:
        ret = self._c.add_quantity(other._c if other is not None else None)
        return DeviceVoltageState._from_capi(ret)

    def add_equals_quantity(self, other: DeviceVoltageState) -> DeviceVoltageState:
        ret = self._c.add_equals_quantity(other._c if other is not None else None)
        return DeviceVoltageState._from_capi(ret)

    def subtract_quantity(self, other: DeviceVoltageState) -> DeviceVoltageState:
        ret = self._c.subtract_quantity(other._c if other is not None else None)
        return DeviceVoltageState._from_capi(ret)

    def subtract_equals_quantity(self, other: DeviceVoltageState) -> DeviceVoltageState:
        ret = self._c.subtract_equals_quantity(other._c if other is not None else None)
        return DeviceVoltageState._from_capi(ret)

    def negate(self, ) -> DeviceVoltageState:
        ret = self._c.negate()
        return DeviceVoltageState._from_capi(ret)

    def abs(self, ) -> DeviceVoltageState:
        ret = self._c.abs()
        return DeviceVoltageState._from_capi(ret)

    def equal(self, b: DeviceVoltageState) -> None:
        ret = self._c.equal(b._c if b is not None else None)
        return ret

    def not_equal(self, b: DeviceVoltageState) -> None:
        ret = self._c.not_equal(b._c if b is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __add__(self, other):
        """Operator overload for +"""
        if hasattr(other, "_c") and type(other).__name__ == "Quantity":
            return self.add_quantity(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsQuantity":
            return self.add_equals_quantity(other)
        return NotImplemented

    def __sub__(self, other):
        """Operator overload for -"""
        if hasattr(other, "_c") and type(other).__name__ == "Quantity":
            return self.subtract_quantity(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsQuantity":
            return self.subtract_equals_quantity(other)
        return NotImplemented

    def __mul__(self, other):
        """Operator overload for *"""
        if isinstance(other, int):
            return self.multiply_int(other)
        if isinstance(other, float):
            return self.multiply_double(other)
        if hasattr(other, "_c") and type(other).__name__ == "Quantity":
            return self.multiply_quantity(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsInt":
            return self.multiply_equals_int(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsDouble":
            return self.multiply_equals_double(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsQuantity":
            return self.multiply_equals_quantity(other)
        return NotImplemented

    def __truediv__(self, other):
        """Operator overload for /"""
        if isinstance(other, int):
            return self.divide_int(other)
        if isinstance(other, float):
            return self.divide_double(other)
        if hasattr(other, "_c") and type(other).__name__ == "Quantity":
            return self.divide_quantity(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsInt":
            return self.divide_equals_int(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsDouble":
            return self.divide_equals_double(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsQuantity":
            return self.divide_equals_quantity(other)
        return NotImplemented

    def __neg__(self):
        """Operator overload for unary -"""
        return self.negation()

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, DeviceVoltageState):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, DeviceVoltageState):
            return NotImplemented
        return self.not_equal(other)
