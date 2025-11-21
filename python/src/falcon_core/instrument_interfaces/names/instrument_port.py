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
    def InstrumentPort_create_port(cls, default_name: str, psuedo_name: Connection, instrument_type: str, units: SymbolUnit, description: str) -> InstrumentPort:
        return cls(_CInstrumentPort.InstrumentPort_create_port(default_name, psuedo_name._c, instrument_type, units._c, description))

    @classmethod
    def InstrumentPort_create_knob(cls, default_name: str, psuedo_name: Connection, instrument_type: str, units: SymbolUnit, description: str) -> InstrumentPort:
        return cls(_CInstrumentPort.InstrumentPort_create_knob(default_name, psuedo_name._c, instrument_type, units._c, description))

    @classmethod
    def InstrumentPort_create_meter(cls, default_name: str, psuedo_name: Connection, instrument_type: str, units: SymbolUnit, description: str) -> InstrumentPort:
        return cls(_CInstrumentPort.InstrumentPort_create_meter(default_name, psuedo_name._c, instrument_type, units._c, description))

    @classmethod
    def InstrumentPort_create_timer(cls, ) -> InstrumentPort:
        return cls(_CInstrumentPort.InstrumentPort_create_timer())

    @classmethod
    def InstrumentPort_create_execution_clock(cls, ) -> InstrumentPort:
        return cls(_CInstrumentPort.InstrumentPort_create_execution_clock())

    @classmethod
    def InstrumentPort_from_json_string(cls, json: str) -> InstrumentPort:
        return cls(_CInstrumentPort.InstrumentPort_from_json_string(json))

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

    def description(self, ) -> str:
        ret = self._c.description()
        return ret

    def instrument_facing_name(self, ) -> str:
        ret = self._c.instrument_facing_name()
        return ret

    def is_knob(self, ) -> None:
        ret = self._c.is_knob()
        return ret

    def is_meter(self, ) -> None:
        ret = self._c.is_meter()
        return ret

    def is_port(self, ) -> None:
        ret = self._c.is_port()
        return ret

    def equal(self, other: InstrumentPort) -> None:
        ret = self._c.equal(other._c)
        return ret

    def not_equal(self, other: InstrumentPort) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, InstrumentPort):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, InstrumentPort):
            return NotImplemented
        return self.notequality(other)
