import json
import collections.abc
from .._capi.map_int_int import MapIntInt as _CMapIntInt

# Registry keyed by a tuple (key_type, value_type)
_C_MAP_REGISTRY = {
    (int, int): _CMapIntInt,
}


class _MapFactory:
    """Helper to construct Map[K, V] via Map[K, V](initial)."""

    def __init__(self, c_map_type):
        self._c_map_type = c_map_type

    def __call__(self, initial=None):
        """
        Construct a Map. `initial` can be None, a dict, or an iterable of
        (k, v) pairs.
        """
        c_obj = self._c_map_type.create_empty()
        m = Map(c_obj, self._c_map_type)
        if initial is None:
            return m
        # Accept dict or iterable of pairs
        if isinstance(initial, dict):
            items = initial.items()
        else:
            items = initial
        for k, v in items:
            m[k] = v
        return m


class Map(collections.abc.MutableMapping):
    """A generic mapping wrapper backed by low-level Map implementations."""

    def __init__(self, c_obj, c_map_type=None):
        if not hasattr(c_obj, "at") or not hasattr(c_obj, "insert_or_assign"):
            raise TypeError("Object must conform to the low-level map interface.")
        self._c = c_obj
        self._c_map_type = c_map_type

    def _coerce_key(self, key):
        # Currently only support int keys for the MapIntInt implementation.
        if self._c_map_type is _CMapIntInt:
            return int(key)
        # return key

    @classmethod
    def __class_getitem__(cls, types):
        if not isinstance(types, tuple) or len(types) != 2:
            raise TypeError(
                "Map[...] requires two type parameters, e.g., Map[int, int]"
            )
        c_map_type = _C_MAP_REGISTRY.get(types)
        if c_map_type is None:
            raise TypeError(f"Map does not support types: {types}")
        return _MapFactory(c_map_type)

    def __getitem__(self, key):
        key = self._coerce_key(key)
        # Use contains to ensure we raise KeyError for missing keys.
        if not self._c.contains(key):
            raise KeyError(key)
        return self._c.at(key)

    def __setitem__(self, key, value):
        if self._c_map_type is None:
            raise TypeError("Cannot modify a Map that was not created with a factory.")
        key = self._coerce_key(key)
        # For int,int map coerce value as well
        if self._c_map_type is _CMapIntInt:
            value = int(value)
        self._c.insert_or_assign(key, value)

    def __delitem__(self, key):
        key = self._coerce_key(key)
        if not self._c.contains(key):
            raise KeyError(key)
        self._c.erase(key)

    def __iter__(self):
        # Prefer low-level keys() if available (returns Python list)
        if hasattr(self._c, "keys"):
            return iter(self._c.keys())
        # Fallback to JSON parsing
        js = self.to_json()
        if not js:
            return iter(())
        d = json.loads(js)
        # For int-key maps, convert keys back to ints
        if self._c_map_type is _CMapIntInt:
            return iter(int(k) for k in d.keys())
        return iter(d.keys())

    def __len__(self):
        return self._c.size()

    def keys(self):
        if hasattr(self._c, "keys"):
            return list(self._c.keys())
        return list(iter(self))

    def values(self):
        if hasattr(self._c, "values"):
            return list(self._c.values())
        js = self.to_json()
        if not js:
            return []
        d = json.loads(js)
        return list(d.values())

    def items(self):
        # Use low-level keys/values if available for correct typing
        if hasattr(self._c, "keys") and hasattr(self._c, "values"):
            ks = self._c.keys()
            vs = self._c.values()
            return list(zip(ks, vs))
        js = self.to_json()
        if not js:
            return []
        d = json.loads(js)
        if self._c_map_type is _CMapIntInt:
            return [(int(k), v) for k, v in d.items()]
        return list(d.items())

    def get(self, key, default=None):
        key = self._coerce_key(key)
        if self._c.contains(key):
            return self._c.at(key)
        return default

    def to_json(self):
        return self._c.to_json()

    @classmethod
    def from_json(cls, json_str, types=None):
        if types is None:
            c_obj = _CMapIntInt.from_json(json_str)
            return cls(c_obj, _CMapIntInt)
        else:
            if not isinstance(types, tuple) or len(types) != 2:
                raise TypeError("types must be a tuple of (K,V)")
            c_map_type = _C_MAP_REGISTRY.get(types)
            if c_map_type is None:
                raise TypeError(f"Map does not support types: {types}")
            c_obj = c_map_type.from_json(json_str)
            return cls(c_obj, c_map_type)

    def __eq__(self, other):
        if not isinstance(other, Map):
            return NotImplemented
        return self._c == other._c

    def __repr__(self):
        return f"Map({dict(self.items())})"
