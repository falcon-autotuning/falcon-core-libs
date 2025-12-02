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
    def new(cls, connection: Connection, instrument_type: str) -> MeasurementContext:
        return cls(_CMeasurementContext.new(connection._c, instrument_type))

    @classmethod
    def new_from_port(cls, port: InstrumentPort) -> MeasurementContext:
        return cls(_CMeasurementContext.new_from_port(port._c))

    @classmethod
    def from_json(cls, json: str) -> MeasurementContext:
        return cls(_CMeasurementContext.from_json(json))

    def connection(self, ) -> Connection:
        ret = self._c.connection()
        if ret is None: return None
        return Connection._from_capi(ret)

    def instrument_type(self, ) -> str:
        ret = self._c.instrument_type()
        return ret

    def equal(self, b: MeasurementContext) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: MeasurementContext) -> None:
        ret = self._c.not_equal(b._c)
        return ret

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
