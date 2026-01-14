from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.instrument_port import InstrumentPort as _CInstrumentPort
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.units.symbol_unit import SymbolUnit

class InstrumentPort:
    """Python wrapper for InstrumentPort."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> InstrumentPort:
        return cls(_CInstrumentPort.from_json(json))

    @classmethod
    def new_port(cls, default_name: str, psuedo_name: Connection, instrument_type: str, units: SymbolUnit, description: str) -> InstrumentPort:
        obj = cls(_CInstrumentPort.new_port(default_name, psuedo_name._c if psuedo_name is not None else None, instrument_type, units._c if units is not None else None, description))
        obj._ref_psuedo_name = psuedo_name  # Keep reference alive
        obj._ref_units = units  # Keep reference alive
        return obj

    @classmethod
    def new_knob(cls, default_name: str, psuedo_name: Connection, instrument_type: str, units: SymbolUnit, description: str) -> InstrumentPort:
        obj = cls(_CInstrumentPort.new_knob(default_name, psuedo_name._c if psuedo_name is not None else None, instrument_type, units._c if units is not None else None, description))
        obj._ref_psuedo_name = psuedo_name  # Keep reference alive
        obj._ref_units = units  # Keep reference alive
        return obj

    @classmethod
    def new_meter(cls, default_name: str, psuedo_name: Connection, instrument_type: str, units: SymbolUnit, description: str) -> InstrumentPort:
        obj = cls(_CInstrumentPort.new_meter(default_name, psuedo_name._c if psuedo_name is not None else None, instrument_type, units._c if units is not None else None, description))
        obj._ref_psuedo_name = psuedo_name  # Keep reference alive
        obj._ref_units = units  # Keep reference alive
        return obj

    @classmethod
    def new_timer(cls, ) -> InstrumentPort:
        return cls(_CInstrumentPort.new_timer())

    @classmethod
    def new_execution_clock(cls, ) -> InstrumentPort:
        return cls(_CInstrumentPort.new_execution_clock())

    def copy(self, ) -> InstrumentPort:
        ret = self._c.copy()
        return InstrumentPort._from_capi(ret)

    def equal(self, other: InstrumentPort) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: InstrumentPort) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def default_name(self, ) -> str:
        ret = self._c.default_name()
        return ret

    def psuedo_name(self, ) -> Connection:
        ret = self._c.psuedo_name()
        if ret is None: return None
        return Connection._from_capi(ret)

    def instrument_type(self, ) -> str:
        ret = self._c.instrument_type()
        return ret

    def units(self, ) -> SymbolUnit:
        ret = self._c.units()
        if ret is None: return None
        return SymbolUnit._from_capi(ret)

    def instrument_facing_name(self, ) -> str:
        ret = self._c.instrument_facing_name()
        return ret

    def is_knob(self, ) -> bool:
        ret = self._c.is_knob()
        return ret

    def is_meter(self, ) -> bool:
        ret = self._c.is_meter()
        return ret

    def is_port(self, ) -> bool:
        ret = self._c.is_port()
        return ret

    @property
    def description(self) -> str:
        ret = self._c.description()
        return ret

    def __repr__(self):
        return f"InstrumentPort({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, InstrumentPort):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, InstrumentPort):
            return NotImplemented
        return self.not_equal(other)
