from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.acquisition_context import AcquisitionContext as _CAcquisitionContext
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.physics.units.symbol_unit import SymbolUnit

class AcquisitionContext:
    """Python wrapper for AcquisitionContext."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new(cls, connection: Connection, instrument_type: str, units: SymbolUnit) -> AcquisitionContext:
        obj = cls(_CAcquisitionContext.new(connection._c if connection is not None else None, instrument_type, units._c if units is not None else None))
        obj._ref_connection = connection  # Keep reference alive
        obj._ref_units = units  # Keep reference alive
        return obj

    @classmethod
    def new_from_port(cls, port: InstrumentPort) -> AcquisitionContext:
        obj = cls(_CAcquisitionContext.new_from_port(port._c if port is not None else None))
        obj._ref_port = port  # Keep reference alive
        return obj

    @classmethod
    def from_json(cls, json: str) -> AcquisitionContext:
        return cls(_CAcquisitionContext.from_json(json))

    def connection(self, ) -> Connection:
        ret = self._c.connection()
        if ret is None: return None
        return Connection._from_capi(ret)

    def instrument_type(self, ) -> str:
        ret = self._c.instrument_type()
        return ret

    def units(self, ) -> SymbolUnit:
        ret = self._c.units()
        if ret is None: return None
        return SymbolUnit._from_capi(ret)

    def division_unit(self, other: SymbolUnit) -> AcquisitionContext:
        ret = self._c.division_unit(other._c if other is not None else None)
        return AcquisitionContext._from_capi(ret)

    def division(self, other: AcquisitionContext) -> AcquisitionContext:
        ret = self._c.division(other._c if other is not None else None)
        return AcquisitionContext._from_capi(ret)

    def match_connection(self, other: Connection) -> None:
        ret = self._c.match_connection(other._c if other is not None else None)
        return ret

    def match_instrument_type(self, other: str) -> None:
        ret = self._c.match_instrument_type(other)
        return ret

    def equal(self, b: AcquisitionContext) -> None:
        ret = self._c.equal(b._c if b is not None else None)
        return ret

    def not_equal(self, b: AcquisitionContext) -> None:
        ret = self._c.not_equal(b._c if b is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __truediv__(self, other):
        """Operator overload for /"""
        if isinstance(other, (int, float)):
            return self.division(other)
        return NotImplemented

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, AcquisitionContext):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, AcquisitionContext):
            return NotImplemented
        return self.not_equal(other)
