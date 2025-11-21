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
    def MeasurementContext_create(cls, connection: Connection, instrument_type: str) -> MeasurementContext:
        return cls(_CMeasurementContext.MeasurementContext_create(connection._c, instrument_type))

    @classmethod
    def MeasurementContext_create_from_port(cls, port: InstrumentPort) -> MeasurementContext:
        return cls(_CMeasurementContext.MeasurementContext_create_from_port(port._c))

    @classmethod
    def MeasurementContext_from_json_string(cls, json: str) -> MeasurementContext:
        return cls(_CMeasurementContext.MeasurementContext_from_json_string(json))

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

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, MeasurementContext):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, MeasurementContext):
            return NotImplemented
        return self.notequality(other)
