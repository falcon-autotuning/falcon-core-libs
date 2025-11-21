from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.labelled_domain import LabelledDomain as _CLabelledDomain
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.math.domains.domain import Domain
from falcon_core.instrument_interfaces.names.instrument_port import InstrumentPort
from falcon_core.physics.units.symbol_unit import SymbolUnit

class LabelledDomain:
    """Python wrapper for LabelledDomain."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def LabelledDomain_create_primitive_knob(cls, default_name: str, min_val: Any, max_val: Any, psuedo_name: Connection, instrument_type: str, lesser_bound_contained: Any, greater_bound_contained: Any, units: SymbolUnit, description: str) -> LabelledDomain:
        return cls(_CLabelledDomain.LabelledDomain_create_primitive_knob(default_name, min_val, max_val, psuedo_name._c, instrument_type, lesser_bound_contained, greater_bound_contained, units._c, description))

    @classmethod
    def LabelledDomain_create_primitive_meter(cls, default_name: str, min_val: Any, max_val: Any, psuedo_name: Connection, instrument_type: str, lesser_bound_contained: Any, greater_bound_contained: Any, units: SymbolUnit, description: str) -> LabelledDomain:
        return cls(_CLabelledDomain.LabelledDomain_create_primitive_meter(default_name, min_val, max_val, psuedo_name._c, instrument_type, lesser_bound_contained, greater_bound_contained, units._c, description))

    @classmethod
    def LabelledDomain_create_primitive_port(cls, default_name: str, min_val: Any, max_val: Any, psuedo_name: Connection, instrument_type: str, lesser_bound_contained: Any, greater_bound_contained: Any, units: SymbolUnit, description: str) -> LabelledDomain:
        return cls(_CLabelledDomain.LabelledDomain_create_primitive_port(default_name, min_val, max_val, psuedo_name._c, instrument_type, lesser_bound_contained, greater_bound_contained, units._c, description))

    @classmethod
    def LabelledDomain_create_from_port(cls, min_val: Any, max_val: Any, instrument_type: str, port: InstrumentPort, lesser_bound_contained: Any, greater_bound_contained: Any) -> LabelledDomain:
        return cls(_CLabelledDomain.LabelledDomain_create_from_port(min_val, max_val, instrument_type, port._c, lesser_bound_contained, greater_bound_contained))

    @classmethod
    def LabelledDomain_create_from_port_and_domain(cls, port: InstrumentPort, domain: Domain) -> LabelledDomain:
        return cls(_CLabelledDomain.LabelledDomain_create_from_port_and_domain(port._c, domain._c))

    @classmethod
    def LabelledDomain_create_from_domain(cls, domain: Domain, default_name: str, psuedo_name: Connection, instrument_type: str, units: SymbolUnit, description: str) -> LabelledDomain:
        return cls(_CLabelledDomain.LabelledDomain_create_from_domain(domain._c, default_name, psuedo_name._c, instrument_type, units._c, description))

    @classmethod
    def LabelledDomain_from_json_string(cls, json: str) -> LabelledDomain:
        return cls(_CLabelledDomain.LabelledDomain_from_json_string(json))

    def port(self, ) -> InstrumentPort:
        ret = self._c.port()
        if ret is None: return None
        return InstrumentPort._from_capi(ret)

    def domain(self, ) -> Domain:
        ret = self._c.domain()
        if ret is None: return None
        return Domain._from_capi(ret)

    def matching_port(self, port: InstrumentPort) -> None:
        ret = self._c.matching_port(port._c)
        return ret

    def lesser_bound(self, ) -> None:
        ret = self._c.lesser_bound()
        return ret

    def greater_bound(self, ) -> None:
        ret = self._c.greater_bound()
        return ret

    def lesser_bound_contained(self, ) -> None:
        ret = self._c.lesser_bound_contained()
        return ret

    def greater_bound_contained(self, ) -> None:
        ret = self._c.greater_bound_contained()
        return ret

    def in(self, value: Any) -> None:
        ret = self._c.in(value)
        return ret

    def range(self, ) -> None:
        ret = self._c.range()
        return ret

    def center(self, ) -> None:
        ret = self._c.center()
        return ret

    def intersection(self, other: LabelledDomain) -> LabelledDomain:
        ret = self._c.intersection(other._c)
        return cls._from_capi(ret)

    def union(self, other: LabelledDomain) -> LabelledDomain:
        ret = self._c.union(other._c)
        return cls._from_capi(ret)

    def is_empty(self, ) -> None:
        ret = self._c.is_empty()
        return ret

    def contains_domain(self, other: LabelledDomain) -> None:
        ret = self._c.contains_domain(other._c)
        return ret

    def shift(self, offset: Any) -> LabelledDomain:
        ret = self._c.shift(offset)
        return cls._from_capi(ret)

    def scale(self, scale: Any) -> LabelledDomain:
        ret = self._c.scale(scale)
        return cls._from_capi(ret)

    def transform(self, other: LabelledDomain, value: Any) -> None:
        ret = self._c.transform(other._c, value)
        return ret

    def equal(self, other: LabelledDomain) -> None:
        ret = self._c.equal(other._c)
        return ret

    def __eq__(self, other: LabelledDomain) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other: LabelledDomain) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __ne__(self, other: LabelledDomain) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
