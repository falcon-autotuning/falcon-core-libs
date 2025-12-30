from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.port_transform import PortTransform as _CPortTransform
from falcon_core.math.analytic_function import AnalyticFunction
from falcon_core.generic.f_array import FArray
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.generic.list import List
from falcon_core.generic.map import Map

class PortTransform:
    """Python wrapper for PortTransform."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> PortTransform:
        return cls(_CPortTransform.from_json(json))

    @classmethod
    def new(cls, port: InstrumentPort, transform: AnalyticFunction) -> PortTransform:
        obj = cls(_CPortTransform.new(port._c if port is not None else None, transform._c if transform is not None else None))
        obj._ref_port = port  # Keep reference alive
        obj._ref_transform = transform  # Keep reference alive
        return obj

    @classmethod
    def new_constant_transform(cls, port: InstrumentPort, value: Any) -> PortTransform:
        obj = cls(_CPortTransform.new_constant_transform(port._c if port is not None else None, value))
        obj._ref_port = port  # Keep reference alive
        return obj

    @classmethod
    def new_identity_transform(cls, port: InstrumentPort) -> PortTransform:
        obj = cls(_CPortTransform.new_identity_transform(port._c if port is not None else None))
        obj._ref_port = port  # Keep reference alive
        return obj

    def copy(self, ) -> PortTransform:
        ret = self._c.copy()
        return PortTransform._from_capi(ret)

    def equal(self, other: PortTransform) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: PortTransform) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def port(self, ) -> InstrumentPort:
        ret = self._c.port()
        if ret is None: return None
        return InstrumentPort._from_capi(ret)

    def labels(self, ) -> List:
        ret = self._c.labels()
        if ret is None: return None
        return List(ret)

    def evaluate(self, args: Map, time: Any) -> None:
        ret = self._c.evaluate(args._c if args is not None else None, time)
        return ret

    def evaluate_arraywise(self, args: Map, deltaT: Any, maxTime: Any) -> FArray:
        ret = self._c.evaluate_arraywise(args._c if args is not None else None, deltaT, maxTime)
        if ret is None: return None
        return FArray(ret)

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, PortTransform):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, PortTransform):
            return NotImplemented
        return self.not_equal(other)
