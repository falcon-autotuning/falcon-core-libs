from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.measurement_context import MeasurementContext as _CMeasurementContext
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort

class MeasurementContext:
    """Python wrapper for MeasurementContext."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> MeasurementContext:
        return cls(_CMeasurementContext.from_json(json))

    @classmethod
    def new(cls, connection: Connection, instrument_type: str) -> MeasurementContext:
        obj = cls(_CMeasurementContext.new(connection._c if connection is not None else None, instrument_type))
        obj._ref_connection = connection  # Keep reference alive
        return obj

    @classmethod
    def new_from_port(cls, port: InstrumentPort) -> MeasurementContext:
        obj = cls(_CMeasurementContext.new_from_port(port._c if port is not None else None))
        obj._ref_port = port  # Keep reference alive
        return obj

    def copy(self, ) -> MeasurementContext:
        ret = self._c.copy()
        return MeasurementContext._from_capi(ret)

    def equal(self, other: MeasurementContext) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: MeasurementContext) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def connection(self, ) -> Connection:
        ret = self._c.connection()
        if ret is None: return None
        return Connection._from_capi(ret)

    def instrument_type(self, ) -> str:
        ret = self._c.instrument_type()
        return ret

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, MeasurementContext):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, MeasurementContext):
            return NotImplemented
        return self.not_equal(other)
