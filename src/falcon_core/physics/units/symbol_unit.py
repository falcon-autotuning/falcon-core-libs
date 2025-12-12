from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.symbol_unit import SymbolUnit as _CSymbolUnit

class SymbolUnit:
    """Python wrapper for SymbolUnit."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_meter())

    @classmethod
    def new_kilogram(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_kilogram())

    @classmethod
    def new_second(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_second())

    @classmethod
    def new_ampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_ampere())

    @classmethod
    def new_kelvin(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_kelvin())

    @classmethod
    def new_mole(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_mole())

    @classmethod
    def new_candela(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_candela())

    @classmethod
    def new_hertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_hertz())

    @classmethod
    def new_newton(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_newton())

    @classmethod
    def new_pascal(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_pascal())

    @classmethod
    def new_joule(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_joule())

    @classmethod
    def new_watt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_watt())

    @classmethod
    def new_coulomb(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_coulomb())

    @classmethod
    def new_volt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_volt())

    @classmethod
    def new_farad(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_farad())

    @classmethod
    def new_ohm(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_ohm())

    @classmethod
    def new_siemens(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_siemens())

    @classmethod
    def new_weber(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_weber())

    @classmethod
    def new_tesla(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_tesla())

    @classmethod
    def new_henry(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_henry())

    @classmethod
    def new_minute(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_minute())

    @classmethod
    def new_hour(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_hour())

    @classmethod
    def new_electronvolt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_electronvolt())

    @classmethod
    def new_celsius(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_celsius())

    @classmethod
    def new_fahrenheit(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_fahrenheit())

    @classmethod
    def new_dimensionless(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_dimensionless())

    @classmethod
    def new_percent(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_percent())

    @classmethod
    def new_radian(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_radian())

    @classmethod
    def new_kilometer(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_kilometer())

    @classmethod
    def new_millimeter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_millimeter())

    @classmethod
    def new_millivolt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_millivolt())

    @classmethod
    def new_kilovolt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_kilovolt())

    @classmethod
    def new_milliampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_milliampere())

    @classmethod
    def new_microampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_microampere())

    @classmethod
    def new_nanoampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_nanoampere())

    @classmethod
    def new_picoampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_picoampere())

    @classmethod
    def new_millisecond(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_millisecond())

    @classmethod
    def new_microsecond(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_microsecond())

    @classmethod
    def new_nanosecond(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_nanosecond())

    @classmethod
    def new_picosecond(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_picosecond())

    @classmethod
    def new_milliohm(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_milliohm())

    @classmethod
    def new_kiloohm(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_kiloohm())

    @classmethod
    def new_megaohm(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_megaohm())

    @classmethod
    def new_millihertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_millihertz())

    @classmethod
    def new_kilohertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_kilohertz())

    @classmethod
    def new_megahertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_megahertz())

    @classmethod
    def new_gigahertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_gigahertz())

    @classmethod
    def new_meters_per_second(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_meters_per_second())

    @classmethod
    def new_meters_per_second_squared(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_meters_per_second_squared())

    @classmethod
    def new_newton_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_newton_meter())

    @classmethod
    def new_newtons_per_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_newtons_per_meter())

    @classmethod
    def new_volts_per_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_volts_per_meter())

    @classmethod
    def new_volts_per_second(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_volts_per_second())

    @classmethod
    def new_amperes_per_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_amperes_per_meter())

    @classmethod
    def new_volts_per_ampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_volts_per_ampere())

    @classmethod
    def new_watts_per_meter_kelvin(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.new_watts_per_meter_kelvin())

    @classmethod
    def from_json(cls, json: str) -> SymbolUnit:
        return cls(_CSymbolUnit.from_json(json))

    def symbol(self, ) -> str:
        ret = self._c.symbol()
        return ret

    def name(self, ) -> str:
        ret = self._c.name()
        return ret

    def multiplication(self, other: SymbolUnit) -> SymbolUnit:
        ret = self._c.multiplication(other._c)
        return cls._from_capi(ret)

    def division(self, other: SymbolUnit) -> SymbolUnit:
        ret = self._c.division(other._c)
        return cls._from_capi(ret)

    def power(self, power: Any) -> SymbolUnit:
        ret = self._c.power(power)
        return cls._from_capi(ret)

    def with_prefix(self, prefix: str) -> SymbolUnit:
        ret = self._c.with_prefix(prefix)
        return cls._from_capi(ret)

    def convert_value_to(self, value: Any, target: SymbolUnit) -> None:
        ret = self._c.convert_value_to(value, target._c)
        return ret

    def is_compatible_with(self, other: SymbolUnit) -> None:
        ret = self._c.is_compatible_with(other._c)
        return ret

    def equal(self, other: SymbolUnit) -> None:
        ret = self._c.equal(other._c)
        return ret

    def not_equal(self, other: SymbolUnit) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __mul__(self, other):
        """Operator overload for *"""
        if isinstance(other, (int, float)):
            return self.multiplication(other)
        return NotImplemented

    def __truediv__(self, other):
        """Operator overload for /"""
        if isinstance(other, (int, float)):
            return self.division(other)
        return NotImplemented

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, SymbolUnit):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, SymbolUnit):
            return NotImplemented
        return self.not_equal(other)
