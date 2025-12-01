from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.port_transform import PortTransform as _CPortTransform
from falcon_core.math.analytic_function import AnalyticFunction
from falcon_core.generic.f_array_double import FArrayDouble
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
    def PortTransform_create(cls, port: InstrumentPort, transform: AnalyticFunction) -> PortTransform:
        return cls(_CPortTransform.PortTransform_create(port._c, transform._c))

    @classmethod
    def PortTransform_create_constant_transform(cls, port: InstrumentPort, value: Any) -> PortTransform:
        return cls(_CPortTransform.PortTransform_create_constant_transform(port._c, value))

    @classmethod
    def PortTransform_create_identity_transform(cls, port: InstrumentPort) -> PortTransform:
        return cls(_CPortTransform.PortTransform_create_identity_transform(port._c))

    @classmethod
    def PortTransform_from_json_string(cls, json: str) -> PortTransform:
        return cls(_CPortTransform.PortTransform_from_json_string(json))

    def port(self, ) -> InstrumentPort:
        ret = self._c.port()
        if ret is None: return None
        return InstrumentPort._from_capi(ret)

    def labels(self, ) -> List:
        ret = self._c.labels()
        if ret is None: return None
        return List(ret)

    def evaluate(self, args: Map, time: Any) -> None:
        ret = self._c.evaluate(args._c, time)
        return ret

    def evaluate_arraywise(self, args: Map, deltaT: Any, maxTime: Any) -> FArrayDouble:
        ret = self._c.evaluate_arraywise(args._c, deltaT, maxTime)
        if ret is None: return None
        return FArrayDouble._from_capi(ret)

    def equal(self, b: PortTransform) -> None:
        ret = self._c.equal(b._c)
        return ret

    def not_equal(self, b: PortTransform) -> None:
        ret = self._c.not_equal(b._c)
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, PortTransform):
            return NotImplemented
        return self.equality(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, PortTransform):
            return NotImplemented
        return self.notequality(other)
