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

    @classmethod
    def __class_getitem__(cls, types):
        if not isinstance(types, tuple) or len(types) != 2:
            raise TypeError("Map[...] requires two type parameters, e.g., Map[int, int]")
        c_map_type = _C_MAP_REGISTRY.get(types)
        if c_map_type is None:
            raise TypeError(f"Map does not support types: {types}")
        return _MapFactory(c_map_type)

    def __getitem__(self, key):
        try:
            return self._c.at(key)
        except ValueError:
            raise KeyError(key)

    def __setitem__(self, key, value):
        if self._c_map_type is None:
            raise TypeError("Cannot modify a Map that was not created with a factory.")
        self._c.insert_or_assign(key, value)

    def __delitem__(self, key):
        if not self._c.contains(key):
            raise KeyError(key)
        self._c.erase(key)

    def __iter__(self):
        # Use JSON serialization for a stable, simple iteration path.
        js = self.to_json()
        if not js:
            return iter(())
        d = json.loads(js)
        return iter(d.keys())

    def __len__(self):
        return self._c.size()

    def keys(self):
        return list(iter(self))

    def values(self):
        js = self.to_json()
        if not js:
            return []
        d = json.loads(js)
        return list(d.values())

    def items(self):
        js = self.to_json()
        if not js:
            return []
        d = json.loads(js)
        return list(d.items())

    def get(self, key, default=None):
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
