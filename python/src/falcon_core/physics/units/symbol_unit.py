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
    def SymbolUnit_create_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_meter())

    @classmethod
    def SymbolUnit_create_kilogram(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_kilogram())

    @classmethod
    def SymbolUnit_create_second(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_second())

    @classmethod
    def SymbolUnit_create_ampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_ampere())

    @classmethod
    def SymbolUnit_create_kelvin(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_kelvin())

    @classmethod
    def SymbolUnit_create_mole(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_mole())

    @classmethod
    def SymbolUnit_create_candela(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_candela())

    @classmethod
    def SymbolUnit_create_hertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_hertz())

    @classmethod
    def SymbolUnit_create_newton(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_newton())

    @classmethod
    def SymbolUnit_create_pascal(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_pascal())

    @classmethod
    def SymbolUnit_create_joule(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_joule())

    @classmethod
    def SymbolUnit_create_watt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_watt())

    @classmethod
    def SymbolUnit_create_coulomb(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_coulomb())

    @classmethod
    def SymbolUnit_create_volt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_volt())

    @classmethod
    def SymbolUnit_create_farad(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_farad())

    @classmethod
    def SymbolUnit_create_ohm(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_ohm())

    @classmethod
    def SymbolUnit_create_siemens(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_siemens())

    @classmethod
    def SymbolUnit_create_weber(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_weber())

    @classmethod
    def SymbolUnit_create_tesla(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_tesla())

    @classmethod
    def SymbolUnit_create_henry(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_henry())

    @classmethod
    def SymbolUnit_create_minute(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_minute())

    @classmethod
    def SymbolUnit_create_hour(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_hour())

    @classmethod
    def SymbolUnit_create_electronvolt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_electronvolt())

    @classmethod
    def SymbolUnit_create_celsius(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_celsius())

    @classmethod
    def SymbolUnit_create_fahrenheit(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_fahrenheit())

    @classmethod
    def SymbolUnit_create_dimensionless(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_dimensionless())

    @classmethod
    def SymbolUnit_create_percent(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_percent())

    @classmethod
    def SymbolUnit_create_radian(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_radian())

    @classmethod
    def SymbolUnit_create_kilometer(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_kilometer())

    @classmethod
    def SymbolUnit_create_millimeter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_millimeter())

    @classmethod
    def SymbolUnit_create_millivolt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_millivolt())

    @classmethod
    def SymbolUnit_create_kilovolt(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_kilovolt())

    @classmethod
    def SymbolUnit_create_milliampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_milliampere())

    @classmethod
    def SymbolUnit_create_microampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_microampere())

    @classmethod
    def SymbolUnit_create_nanoampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_nanoampere())

    @classmethod
    def SymbolUnit_create_picoampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_picoampere())

    @classmethod
    def SymbolUnit_create_millisecond(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_millisecond())

    @classmethod
    def SymbolUnit_create_microsecond(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_microsecond())

    @classmethod
    def SymbolUnit_create_nanosecond(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_nanosecond())

    @classmethod
    def SymbolUnit_create_picosecond(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_picosecond())

    @classmethod
    def SymbolUnit_create_milliohm(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_milliohm())

    @classmethod
    def SymbolUnit_create_kiloohm(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_kiloohm())

    @classmethod
    def SymbolUnit_create_megaohm(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_megaohm())

    @classmethod
    def SymbolUnit_create_millihertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_millihertz())

    @classmethod
    def SymbolUnit_create_kilohertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_kilohertz())

    @classmethod
    def SymbolUnit_create_megahertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_megahertz())

    @classmethod
    def SymbolUnit_create_gigahertz(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_gigahertz())

    @classmethod
    def SymbolUnit_create_meters_per_second(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_meters_per_second())

    @classmethod
    def SymbolUnit_create_meters_per_second_squared(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_meters_per_second_squared())

    @classmethod
    def SymbolUnit_create_newton_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_newton_meter())

    @classmethod
    def SymbolUnit_create_newtons_per_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_newtons_per_meter())

    @classmethod
    def SymbolUnit_create_volts_per_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_volts_per_meter())

    @classmethod
    def SymbolUnit_create_volts_per_second(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_volts_per_second())

    @classmethod
    def SymbolUnit_create_amperes_per_meter(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_amperes_per_meter())

    @classmethod
    def SymbolUnit_create_volts_per_ampere(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_volts_per_ampere())

    @classmethod
    def SymbolUnit_create_watts_per_meter_kelvin(cls, ) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_create_watts_per_meter_kelvin())

    @classmethod
    def SymbolUnit_from_json_string(cls, json: str) -> SymbolUnit:
        return cls(_CSymbolUnit.SymbolUnit_from_json_string(json))

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

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
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
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, SymbolUnit):
            return NotImplemented
        return self.notequality(other)
