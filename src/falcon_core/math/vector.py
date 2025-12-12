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
    def new(cls, start: Point, end: Point) -> Vector:
        return cls(_CVector.new(start._c, end._c))

    @classmethod
    def new_from_end(cls, end: Point) -> Vector:
        return cls(_CVector.new_from_end(end._c))

    @classmethod
    def new_from_quantities(cls, start: Map, end: Map) -> Vector:
        return cls(_CVector.new_from_quantities(start._c, end._c))

    @classmethod
    def new_from_end_quantities(cls, end: Map) -> Vector:
        return cls(_CVector.new_from_end_quantities(end._c))

    @classmethod
    def new_from_doubles(cls, start: Map, end: Map, unit: SymbolUnit) -> Vector:
        return cls(_CVector.new_from_doubles(start._c, end._c, unit._c))

    @classmethod
    def new_from_end_doubles(cls, end: Map, unit: SymbolUnit) -> Vector:
        return cls(_CVector.new_from_end_doubles(end._c, unit._c))

    @classmethod
    def new_from_parent(cls, items: Map) -> Vector:
        return cls(_CVector.new_from_parent(items._c))

    @classmethod
    def from_json(cls, json: str) -> Vector:
        return cls(_CVector.from_json(json))

    def endPoint(self, ) -> Point:
        ret = self._c.endPoint()
        if ret is None: return None
        return Point._from_capi(ret)

    def startPoint(self, ) -> Point:
        ret = self._c.startPoint()
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

    def magnitude(self, ) -> None:
        ret = self._c.magnitude()
        return ret

    def insert_or_assign(self, key: Connection, value: Pair) -> None:
        ret = self._c.insert_or_assign(key._c, value._c)
        return ret

    def insert(self, key: Connection, value: Pair) -> None:
        ret = self._c.insert(key._c, value._c)
        return ret

    def at(self, key: Connection) -> Pair:
        ret = self._c.at(key._c)
        if ret is None: return None
        return Pair(ret)

    def erase(self, key: Connection) -> None:
        ret = self._c.erase(key._c)
        return ret

    def size(self, ) -> None:
        ret = self._c.size()
        return ret

    def empty(self, ) -> None:
        ret = self._c.empty()
        return ret

    def clear(self, ) -> None:
        ret = self._c.clear()
        return ret

    def contains(self, key: Connection) -> None:
        ret = self._c.contains(key._c)
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
        ret = self._c.addition(other._c)
        return cls._from_capi(ret)

    def subtraction(self, other: Vector) -> Vector:
        ret = self._c.subtraction(other._c)
        return cls._from_capi(ret)

    def double_multiplication(self, scalar: Any) -> Vector:
        ret = self._c.double_multiplication(scalar)
        return cls._from_capi(ret)

    def int_multiplication(self, scalar: Any) -> Vector:
        ret = self._c.int_multiplication(scalar)
        return cls._from_capi(ret)

    def double_division(self, scalar: Any) -> Vector:
        ret = self._c.double_division(scalar)
        return cls._from_capi(ret)

    def int_division(self, scalar: Any) -> Vector:
        ret = self._c.int_division(scalar)
        return cls._from_capi(ret)

    def negation(self, ) -> Vector:
        ret = self._c.negation()
        return cls._from_capi(ret)

    def update_start_from_states(self, state: DeviceVoltageStates) -> Vector:
        ret = self._c.update_start_from_states(state._c)
        return cls._from_capi(ret)

    def translate_doubles(self, point: Map, unit: SymbolUnit) -> Vector:
        ret = self._c.translate_doubles(point._c, unit._c)
        return cls._from_capi(ret)

    def translate_quantities(self, point: Map) -> Vector:
        ret = self._c.translate_quantities(point._c)
        return cls._from_capi(ret)

    def translate(self, point: Point) -> Vector:
        ret = self._c.translate(point._c)
        return cls._from_capi(ret)

    def translate_to_origin(self, ) -> Vector:
        ret = self._c.translate_to_origin()
        return cls._from_capi(ret)

    def double_extend(self, extension: Any) -> Vector:
        ret = self._c.double_extend(extension)
        return cls._from_capi(ret)

    def int_extend(self, extension: Any) -> Vector:
        ret = self._c.int_extend(extension)
        return cls._from_capi(ret)

    def double_shrink(self, extension: Any) -> Vector:
        ret = self._c.double_shrink(extension)
        return cls._from_capi(ret)

    def int_shrink(self, extension: Any) -> Vector:
        ret = self._c.int_shrink(extension)
        return cls._from_capi(ret)

    def unit_vector(self, ) -> Vector:
        ret = self._c.unit_vector()
        return cls._from_capi(ret)

    def normalize(self, ) -> Vector:
        ret = self._c.normalize()
        return cls._from_capi(ret)

    def project(self, other: Vector) -> Vector:
        ret = self._c.project(other._c)
        return cls._from_capi(ret)

    def update_unit(self, unit: SymbolUnit) -> None:
        ret = self._c.update_unit(unit._c)
        return ret

    def equal(self, b: Vector) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: Vector) -> None:
        ret = self._c.not_equal(b._c)
        return ret

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
