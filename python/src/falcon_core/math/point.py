from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.point import Point as _CPoint
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.generic.list import List
from falcon_core.generic.list import List
from falcon_core.generic.list import List
from falcon_core.generic.map import Map
from falcon_core.generic.map import Map
from falcon_core.math.quantity import Quantity
from falcon_core.physics.units.symbol_unit import SymbolUnit

class Point:
    """Python wrapper for Point."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> Point:
        return cls(_CPoint.from_json(json))

    @classmethod
    def new_empty(cls, ) -> Point:
        return cls(_CPoint.new_empty())

    @classmethod
    def new(cls, items: Map, unit: SymbolUnit) -> Point:
        obj = cls(_CPoint.new(items._c if items is not None else None, unit._c if unit is not None else None))
        obj._ref_items = items  # Keep reference alive
        obj._ref_unit = unit  # Keep reference alive
        return obj

    @classmethod
    def new_from_parent(cls, items: Map) -> Point:
        obj = cls(_CPoint.new_from_parent(items._c if items is not None else None))
        obj._ref_items = items  # Keep reference alive
        return obj

    def copy(self, ) -> Point:
        ret = self._c.copy()
        return Point._from_capi(ret)

    def equal(self, other: Point) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Point) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def unit(self, ) -> SymbolUnit:
        ret = self._c.unit()
        if ret is None: return None
        return SymbolUnit._from_capi(ret)

    def insert_or_assign(self, key: Connection, value: Quantity) -> None:
        ret = self._c.insert_or_assign(key._c if key is not None else None, value._c if value is not None else None)
        return ret

    def insert(self, key: Connection, value: Quantity) -> None:
        ret = self._c.insert(key._c if key is not None else None, value._c if value is not None else None)
        return ret

    def at(self, key: Connection) -> Quantity:
        ret = self._c.at(key._c if key is not None else None)
        if ret is None: return None
        return Quantity._from_capi(ret)

    def erase(self, key: Connection) -> None:
        ret = self._c.erase(key._c if key is not None else None)
        return ret

    def empty(self, ) -> bool:
        ret = self._c.empty()
        return ret

    def clear(self, ) -> None:
        ret = self._c.clear()
        return ret

    def contains(self, key: Connection) -> bool:
        ret = self._c.contains(key._c if key is not None else None)
        return ret

    def keys(self, ) -> List:
        ret = self._c.keys()
        if ret is None: return None
        return List(ret)

    def values(self, ) -> List:
        ret = self._c.values()
        if ret is None: return None
        return List(ret)

    def items(self, ) -> List:
        ret = self._c.items()
        if ret is None: return None
        return List(ret)

    def coordinates(self, ) -> Map:
        ret = self._c.coordinates()
        if ret is None: return None
        return Map(ret)

    def connections(self, ) -> List:
        ret = self._c.connections()
        if ret is None: return None
        return List(ret)

    def addition(self, other: Point) -> Point:
        ret = self._c.addition(other._c if other is not None else None)
        return Point._from_capi(ret)

    def subtraction(self, other: Point) -> Point:
        ret = self._c.subtraction(other._c if other is not None else None)
        return Point._from_capi(ret)

    def multiplication(self, scalar: Any) -> Point:
        ret = self._c.multiplication(scalar)
        return Point._from_capi(ret)

    def division(self, scalar: Any) -> Point:
        ret = self._c.division(scalar)
        return Point._from_capi(ret)

    def negation(self, ) -> Point:
        ret = self._c.negation()
        return Point._from_capi(ret)

    @property
    def size(self) -> int:
        ret = self._c.size()
        return ret

    def set_unit(self, unit: SymbolUnit) -> None:
        ret = self._c.set_unit(unit._c if unit is not None else None)
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

    def __setitem__(self, key, value):
        self.insert_or_assign(key, value)

    def __contains__(self, key):
        return self.contains(key)

    def __repr__(self):
        return f"Point({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __add__(self, other):
        """Operator overload for +"""
        if isinstance(other, Point):
            return self.addition(other)
        return NotImplemented

    def __sub__(self, other):
        """Operator overload for -"""
        if isinstance(other, Point):
            return self.subtraction(other)
        return NotImplemented

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

    def __neg__(self):
        """Operator overload for unary -"""
        return self.negation()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Point):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Point):
            return NotImplemented
        return self.not_equal(other)
