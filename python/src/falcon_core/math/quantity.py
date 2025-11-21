from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.quantity import Quantity as _CQuantity
from falcon_core.physics.units.symbol_unit import SymbolUnit

class Quantity:
    """Python wrapper for Quantity."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def Quantity_create(cls, value: Any, unit: SymbolUnit) -> Quantity:
        return cls(_CQuantity.Quantity_create(value, unit._c))

    @classmethod
    def Quantity_from_json_string(cls, json: str) -> Quantity:
        return cls(_CQuantity.Quantity_from_json_string(json))

    def value(self, ) -> None:
        ret = self._c.value()
        return ret

    def unit(self, ) -> SymbolUnit:
        ret = self._c.unit()
        if ret is None: return None
        return SymbolUnit._from_capi(ret)

    def convert_to(self, target_unit: SymbolUnit) -> None:
        ret = self._c.convert_to(target_unit._c)
        return ret

    def multiply_int(self, other: Any) -> Quantity:
        ret = self._c.multiply_int(other)
        return cls._from_capi(ret)

    def multiply_double(self, other: Any) -> Quantity:
        ret = self._c.multiply_double(other)
        return cls._from_capi(ret)

    def multiply_quantity(self, other: Quantity) -> Quantity:
        ret = self._c.multiply_quantity(other._c)
        return cls._from_capi(ret)

    def multiply_equals_int(self, other: Any) -> Quantity:
        ret = self._c.multiply_equals_int(other)
        return cls._from_capi(ret)

    def multiply_equals_double(self, other: Any) -> Quantity:
        ret = self._c.multiply_equals_double(other)
        return cls._from_capi(ret)

    def multiply_equals_quantity(self, other: Quantity) -> Quantity:
        ret = self._c.multiply_equals_quantity(other._c)
        return cls._from_capi(ret)

    def divide_int(self, other: Any) -> Quantity:
        ret = self._c.divide_int(other)
        return cls._from_capi(ret)

    def divide_double(self, other: Any) -> Quantity:
        ret = self._c.divide_double(other)
        return cls._from_capi(ret)

    def divide_quantity(self, other: Quantity) -> Quantity:
        ret = self._c.divide_quantity(other._c)
        return cls._from_capi(ret)

    def divide_equals_int(self, other: Any) -> Quantity:
        ret = self._c.divide_equals_int(other)
        return cls._from_capi(ret)

    def divide_equals_double(self, other: Any) -> Quantity:
        ret = self._c.divide_equals_double(other)
        return cls._from_capi(ret)

    def divide_equals_quantity(self, other: Quantity) -> Quantity:
        ret = self._c.divide_equals_quantity(other._c)
        return cls._from_capi(ret)

    def power(self, other: Any) -> Quantity:
        ret = self._c.power(other)
        return cls._from_capi(ret)

    def add_quantity(self, other: Quantity) -> Quantity:
        ret = self._c.add_quantity(other._c)
        return cls._from_capi(ret)

    def add_equals_quantity(self, other: Quantity) -> Quantity:
        ret = self._c.add_equals_quantity(other._c)
        return cls._from_capi(ret)

    def subtract_quantity(self, other: Quantity) -> Quantity:
        ret = self._c.subtract_quantity(other._c)
        return cls._from_capi(ret)

    def subtract_equals_quantity(self, other: Quantity) -> Quantity:
        ret = self._c.subtract_equals_quantity(other._c)
        return cls._from_capi(ret)

    def negate(self, ) -> Quantity:
        ret = self._c.negate()
        return cls._from_capi(ret)

    def abs(self, ) -> Quantity:
        ret = self._c.abs()
        return cls._from_capi(ret)

    def equal(self, b: Quantity) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Quantity) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret

    def __add__(self, other):
        """Operator overload for +"""
        if isinstance(other, Quantity):
            return self.add_quantity(other)
        if hasattr(other, "_c") and type(other).__name__ == "EqualsQuantity":
            return self.add_equals_quantity(other)
        return NotImplemented

    def __sub__(self, other):
        """Operator overload for -"""
        if isinstance(other, Quantity):
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
        if isinstance(other, Quantity):
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
        if isinstance(other, Quantity):
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
        if not isinstance(other, Quantity):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Quantity):
            return NotImplemented
        return self.notequality(other)
