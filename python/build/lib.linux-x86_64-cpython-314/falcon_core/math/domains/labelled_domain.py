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
    def from_json(cls, json: str) -> LabelledDomain:
        return cls(_CLabelledDomain.from_json(json))

    @classmethod
    def new_primitive_knob(cls, default_name: str, min_val: Any, max_val: Any, psuedo_name: Connection, instrument_type: str, lesser_bound_contained: Any, greater_bound_contained: Any, units: SymbolUnit, description: str) -> LabelledDomain:
        obj = cls(_CLabelledDomain.new_primitive_knob(default_name, min_val, max_val, psuedo_name._c if psuedo_name is not None else None, instrument_type, lesser_bound_contained, greater_bound_contained, units._c if units is not None else None, description))
        obj._ref_psuedo_name = psuedo_name  # Keep reference alive
        obj._ref_units = units  # Keep reference alive
        return obj

    @classmethod
    def new_primitive_meter(cls, default_name: str, min_val: Any, max_val: Any, psuedo_name: Connection, instrument_type: str, lesser_bound_contained: Any, greater_bound_contained: Any, units: SymbolUnit, description: str) -> LabelledDomain:
        obj = cls(_CLabelledDomain.new_primitive_meter(default_name, min_val, max_val, psuedo_name._c if psuedo_name is not None else None, instrument_type, lesser_bound_contained, greater_bound_contained, units._c if units is not None else None, description))
        obj._ref_psuedo_name = psuedo_name  # Keep reference alive
        obj._ref_units = units  # Keep reference alive
        return obj

    @classmethod
    def new_primitive_port(cls, default_name: str, min_val: Any, max_val: Any, psuedo_name: Connection, instrument_type: str, lesser_bound_contained: Any, greater_bound_contained: Any, units: SymbolUnit, description: str) -> LabelledDomain:
        obj = cls(_CLabelledDomain.new_primitive_port(default_name, min_val, max_val, psuedo_name._c if psuedo_name is not None else None, instrument_type, lesser_bound_contained, greater_bound_contained, units._c if units is not None else None, description))
        obj._ref_psuedo_name = psuedo_name  # Keep reference alive
        obj._ref_units = units  # Keep reference alive
        return obj

    @classmethod
    def new_from_port(cls, min_val: Any, max_val: Any, port: InstrumentPort, lesser_bound_contained: Any, greater_bound_contained: Any) -> LabelledDomain:
        obj = cls(_CLabelledDomain.new_from_port(min_val, max_val, port._c if port is not None else None, lesser_bound_contained, greater_bound_contained))
        obj._ref_port = port  # Keep reference alive
        return obj

    @classmethod
    def new_from_port_and_domain(cls, port: InstrumentPort, domain: Domain) -> LabelledDomain:
        obj = cls(_CLabelledDomain.new_from_port_and_domain(port._c if port is not None else None, domain._c if domain is not None else None))
        obj._ref_port = port  # Keep reference alive
        obj._ref_domain = domain  # Keep reference alive
        return obj

    @classmethod
    def new_from_domain(cls, domain: Domain, default_name: str, psuedo_name: Connection, instrument_type: str, units: SymbolUnit, description: str) -> LabelledDomain:
        obj = cls(_CLabelledDomain.new_from_domain(domain._c if domain is not None else None, default_name, psuedo_name._c if psuedo_name is not None else None, instrument_type, units._c if units is not None else None, description))
        obj._ref_domain = domain  # Keep reference alive
        obj._ref_psuedo_name = psuedo_name  # Keep reference alive
        obj._ref_units = units  # Keep reference alive
        return obj

    def copy(self, ) -> LabelledDomain:
        ret = self._c.copy()
        return LabelledDomain._from_capi(ret)

    def equal(self, other: LabelledDomain) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: LabelledDomain) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def port(self, ) -> InstrumentPort:
        ret = self._c.port()
        if ret is None: return None
        return InstrumentPort._from_capi(ret)

    def domain(self, ) -> Domain:
        ret = self._c.domain()
        if ret is None: return None
        return Domain._from_capi(ret)

    def matching_port(self, port: InstrumentPort) -> bool:
        ret = self._c.matching_port(port._c if port is not None else None)
        return ret

    def lesser_bound(self, ) -> float:
        ret = self._c.lesser_bound()
        return ret

    def greater_bound(self, ) -> float:
        ret = self._c.greater_bound()
        return ret

    def lesser_bound_contained(self, ) -> bool:
        ret = self._c.lesser_bound_contained()
        return ret

    def greater_bound_contained(self, ) -> bool:
        ret = self._c.greater_bound_contained()
        return ret

    def contains(self, value: Any) -> bool:
        ret = self._c.contains(value)
        return ret

    def center(self, ) -> float:
        ret = self._c.center()
        return ret

    def intersection(self, other: LabelledDomain) -> LabelledDomain:
        ret = self._c.intersection(other._c if other is not None else None)
        return LabelledDomain._from_capi(ret)

    def union(self, other: LabelledDomain) -> LabelledDomain:
        ret = self._c.union(other._c if other is not None else None)
        return LabelledDomain._from_capi(ret)

    def is_empty(self, ) -> bool:
        ret = self._c.is_empty()
        return ret

    def contains_domain(self, other: LabelledDomain) -> bool:
        ret = self._c.contains_domain(other._c if other is not None else None)
        return ret

    def shift(self, offset: Any) -> LabelledDomain:
        ret = self._c.shift(offset)
        return LabelledDomain._from_capi(ret)

    def scale(self, scale: Any) -> LabelledDomain:
        ret = self._c.scale(scale)
        return LabelledDomain._from_capi(ret)

    def transform(self, other: LabelledDomain, value: Any) -> float:
        ret = self._c.transform(other._c if other is not None else None, value)
        return ret

    @property
    def range(self) -> float:
        ret = self._c.get_range()
        return ret

    def __repr__(self):
        return f"LabelledDomain({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, LabelledDomain):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, LabelledDomain):
            return NotImplemented
        return self.not_equal(other)
