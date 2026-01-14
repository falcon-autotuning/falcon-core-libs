from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.domain import Domain as _CDomain

class Domain:
    """Python wrapper for Domain."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> Domain:
        return cls(_CDomain.from_json(json))

    @classmethod
    def new(cls, min_val: Any, max_val: Any, lesser_bound_contained: Any, greater_bound_contained: Any) -> Domain:
        return cls(_CDomain.new(min_val, max_val, lesser_bound_contained, greater_bound_contained))

    def copy(self, ) -> Domain:
        ret = self._c.copy()
        return Domain._from_capi(ret)

    def equal(self, other: Domain) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Domain) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
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

    def intersection(self, other: Domain) -> Domain:
        ret = self._c.intersection(other._c if other is not None else None)
        return Domain._from_capi(ret)

    def union(self, other: Domain) -> Domain:
        ret = self._c.union(other._c if other is not None else None)
        return Domain._from_capi(ret)

    def is_empty(self, ) -> bool:
        ret = self._c.is_empty()
        return ret

    def contains_domain(self, other: Domain) -> bool:
        ret = self._c.contains_domain(other._c if other is not None else None)
        return ret

    def shift(self, offset: Any) -> Domain:
        ret = self._c.shift(offset)
        return Domain._from_capi(ret)

    def scale(self, scale: Any) -> Domain:
        ret = self._c.scale(scale)
        return Domain._from_capi(ret)

    def transform(self, other: Domain, value: Any) -> float:
        ret = self._c.transform(other._c if other is not None else None, value)
        return ret

    @property
    def range(self) -> float:
        ret = self._c.get_range()
        return ret

    def __repr__(self):
        return f"Domain({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Domain):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Domain):
            return NotImplemented
        return self.not_equal(other)
