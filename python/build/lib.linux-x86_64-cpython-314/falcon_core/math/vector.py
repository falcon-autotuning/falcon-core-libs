from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.vector import Vector as _CVector
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.communications.voltage_states.device_voltage_states import DeviceVoltageStates
from falcon_core.generic.list import List
from falcon_core.generic.list import List
from falcon_core.generic.list import List
from falcon_core.generic.map import Map
from falcon_core.generic.map import Map
from falcon_core.generic.pair import Pair
from falcon_core.math.point import Point
from falcon_core.physics.units.symbol_unit import SymbolUnit

class Vector:
    """Python wrapper for Vector."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> Vector:
        return cls(_CVector.from_json(json))

    @classmethod
    def new(cls, start: Point, end: Point) -> Vector:
        obj = cls(_CVector.new(start._c if start is not None else None, end._c if end is not None else None))
        obj._ref_start = start  # Keep reference alive
        obj._ref_end = end  # Keep reference alive
        return obj

    @classmethod
    def new_from_end(cls, end: Point) -> Vector:
        obj = cls(_CVector.new_from_end(end._c if end is not None else None))
        obj._ref_end = end  # Keep reference alive
        return obj

    @classmethod
    def new_from_quantities(cls, start: Map, end: Map) -> Vector:
        obj = cls(_CVector.new_from_quantities(start._c if start is not None else None, end._c if end is not None else None))
        obj._ref_start = start  # Keep reference alive
        obj._ref_end = end  # Keep reference alive
        return obj

    @classmethod
    def new_from_end_quantities(cls, end: Map) -> Vector:
        obj = cls(_CVector.new_from_end_quantities(end._c if end is not None else None))
        obj._ref_end = end  # Keep reference alive
        return obj

    @classmethod
    def new_from_doubles(cls, start: Map, end: Map, unit: SymbolUnit) -> Vector:
        obj = cls(_CVector.new_from_doubles(start._c if start is not None else None, end._c if end is not None else None, unit._c if unit is not None else None))
        obj._ref_start = start  # Keep reference alive
        obj._ref_end = end  # Keep reference alive
        obj._ref_unit = unit  # Keep reference alive
        return obj

    @classmethod
    def new_from_end_doubles(cls, end: Map, unit: SymbolUnit) -> Vector:
        obj = cls(_CVector.new_from_end_doubles(end._c if end is not None else None, unit._c if unit is not None else None))
        obj._ref_end = end  # Keep reference alive
        obj._ref_unit = unit  # Keep reference alive
        return obj

    @classmethod
    def new_from_parent(cls, items: Map) -> Vector:
        obj = cls(_CVector.new_from_parent(items._c if items is not None else None))
        obj._ref_items = items  # Keep reference alive
        return obj

    def copy(self, ) -> Vector:
        ret = self._c.copy()
        return Vector._from_capi(ret)

    def equal(self, other: Vector) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Vector) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def end_point(self, ) -> Point:
        ret = self._c.end_point()
        if ret is None: return None
        return Point._from_capi(ret)

    def start_point(self, ) -> Point:
        ret = self._c.start_point()
        if ret is None: return None
        return Point._from_capi(ret)

    def end_quantities(self, ) -> Map:
        ret = self._c.end_quantities()
        if ret is None: return None
        return Map(ret)

    def start_quantities(self, ) -> Map:
        ret = self._c.start_quantities()
        if ret is None: return None
        return Map(ret)

    def end_map(self, ) -> Map:
        ret = self._c.end_map()
        if ret is None: return None
        return Map(ret)

    def start_map(self, ) -> Map:
        ret = self._c.start_map()
        if ret is None: return None
        return Map(ret)

    def connections(self, ) -> List:
        ret = self._c.connections()
        if ret is None: return None
        return List(ret)

    def unit(self, ) -> SymbolUnit:
        ret = self._c.unit()
        if ret is None: return None
        return SymbolUnit._from_capi(ret)

    def principle_connection(self, ) -> Connection:
        ret = self._c.principle_connection()
        if ret is None: return None
        return Connection._from_capi(ret)

    def magnitude(self, ) -> float:
        ret = self._c.magnitude()
        return ret

    def insert_or_assign(self, key: Connection, value: Pair) -> None:
        ret = self._c.insert_or_assign(key._c if key is not None else None, value._c if value is not None else None)
        return ret

    def insert(self, key: Connection, value: Pair) -> None:
        ret = self._c.insert(key._c if key is not None else None, value._c if value is not None else None)
        return ret

    def at(self, key: Connection) -> Pair:
        ret = self._c.at(key._c if key is not None else None)
        if ret is None: return None
        return Pair(ret)

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

    def addition(self, other: Vector) -> Vector:
        ret = self._c.addition(other._c if other is not None else None)
        return Vector._from_capi(ret)

    def subtraction(self, other: Vector) -> Vector:
        ret = self._c.subtraction(other._c if other is not None else None)
        return Vector._from_capi(ret)

    def double_multiplication(self, scalar: Any) -> Vector:
        ret = self._c.double_multiplication(scalar)
        return Vector._from_capi(ret)

    def int_multiplication(self, scalar: Any) -> Vector:
        ret = self._c.int_multiplication(scalar)
        return Vector._from_capi(ret)

    def double_division(self, scalar: Any) -> Vector:
        ret = self._c.double_division(scalar)
        return Vector._from_capi(ret)

    def int_division(self, scalar: Any) -> Vector:
        ret = self._c.int_division(scalar)
        return Vector._from_capi(ret)

    def negation(self, ) -> Vector:
        ret = self._c.negation()
        return Vector._from_capi(ret)

    def update_start_from_states(self, state: DeviceVoltageStates) -> Vector:
        ret = self._c.update_start_from_states(state._c if state is not None else None)
        return Vector._from_capi(ret)

    def translate_doubles(self, point: Map, unit: SymbolUnit) -> Vector:
        ret = self._c.translate_doubles(point._c if point is not None else None, unit._c if unit is not None else None)
        return Vector._from_capi(ret)

    def translate_quantities(self, point: Map) -> Vector:
        ret = self._c.translate_quantities(point._c if point is not None else None)
        return Vector._from_capi(ret)

    def translate(self, point: Point) -> Vector:
        ret = self._c.translate(point._c if point is not None else None)
        return Vector._from_capi(ret)

    def translate_to_origin(self, ) -> Vector:
        ret = self._c.translate_to_origin()
        return Vector._from_capi(ret)

    def double_extend(self, extension: Any) -> Vector:
        ret = self._c.double_extend(extension)
        return Vector._from_capi(ret)

    def int_extend(self, extension: Any) -> Vector:
        ret = self._c.int_extend(extension)
        return Vector._from_capi(ret)

    def double_shrink(self, extension: Any) -> Vector:
        ret = self._c.double_shrink(extension)
        return Vector._from_capi(ret)

    def int_shrink(self, extension: Any) -> Vector:
        ret = self._c.int_shrink(extension)
        return Vector._from_capi(ret)

    def unit_vector(self, ) -> Vector:
        ret = self._c.unit_vector()
        return Vector._from_capi(ret)

    def normalize(self, ) -> Vector:
        ret = self._c.normalize()
        return Vector._from_capi(ret)

    def project(self, other: Vector) -> Vector:
        ret = self._c.project(other._c if other is not None else None)
        return Vector._from_capi(ret)

    def update_unit(self, unit: SymbolUnit) -> None:
        ret = self._c.update_unit(unit._c if unit is not None else None)
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

    def __setitem__(self, key, value):
        self.insert_or_assign(key, value)

    def __contains__(self, key):
        return self.contains(key)

    def __repr__(self):
        return f"Vector({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __add__(self, other):
        """Operator overload for +"""
        if isinstance(other, Vector):
            return self.addition(other)
        return NotImplemented

    def __sub__(self, other):
        """Operator overload for -"""
        if isinstance(other, Vector):
            return self.subtraction(other)
        return NotImplemented

    def __mul__(self, other):
        """Operator overload for *"""
        if isinstance(other, float):
            return self.double_multiplication(other)
        if isinstance(other, int):
            return self.int_multiplication(other)
        return NotImplemented

    def __truediv__(self, other):
        """Operator overload for /"""
        if isinstance(other, float):
            return self.double_division(other)
        if isinstance(other, int):
            return self.int_division(other)
        return NotImplemented

    def __neg__(self):
        """Operator overload for unary -"""
        return self.negation()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Vector):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Vector):
            return NotImplemented
        return self.not_equal(other)
