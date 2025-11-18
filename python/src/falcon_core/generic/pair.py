from .._capi.pair_int_int import PairIntInt as _CPairIntInt

# Registry keyed by a tuple (first_type, second_type)
_C_PAIR_REGISTRY = {
    (int, int): _CPairIntInt,
}


class _PairFactory:
    """Helper to construct Pair[A, B] via Pair[A, B](a, b)."""

    def __init__(self, c_pair_type):
        self._c_pair_type = c_pair_type

    def __call__(self, a=None, b=None):
        """Constructs a Pair. If a and b are None, construct a (0,0) default pair."""
        if a is None and b is None:
            c_obj = self._c_pair_type.new(0, 0)
        else:
            c_obj = self._c_pair_type.new(a, b)
        return Pair(c_obj, self._c_pair_type)


class Pair:
    """
    Generic Pair[A, B] wrapper that provides a Pythonic interface on top of
    low-level Cython pair implementations.
    """

    def __init__(self, c_obj, c_pair_type=None):
        if not hasattr(c_obj, "first") or not hasattr(c_obj, "second"):
            raise TypeError("Object must conform to the low-level pair interface.")
        self._c = c_obj
        self._c_pair_type = c_pair_type

    @classmethod
    def __class_getitem__(cls, types):
        """Enable Pair[A, B] factory syntax."""
        if not isinstance(types, tuple) or len(types) != 2:
            raise TypeError("Pair[...] requires two type parameters, e.g., Pair[int, int]")
        c_pair_type = _C_PAIR_REGISTRY.get(types)
        if c_pair_type is None:
            raise TypeError(f"Pair does not support types: {types}")
        return _PairFactory(c_pair_type)

    def first(self):
        return self._c.first()

    def second(self):
        return self._c.second()

    def to_json(self):
        return self._c.to_json()

    @classmethod
    def from_json(cls, json_str, types=None):
        """
        Deserialize a Pair from JSON. If `types` is provided it must be a (A,B)
        tuple matching a registered C pair implementation; otherwise defaults
        to Pair[int, int].
        """
        if types is None:
            c_obj = _CPairIntInt.from_json(json_str)
            return cls(c_obj, _CPairIntInt)
        else:
            if not isinstance(types, tuple) or len(types) != 2:
                raise TypeError("types must be a tuple of (A,B)")
            c_pair_type = _C_PAIR_REGISTRY.get(types)
            if c_pair_type is None:
                raise TypeError(f"Pair does not support types: {types}")
            c_obj = c_pair_type.from_json(json_str)
            return cls(c_obj, c_pair_type)

    def __eq__(self, other):
        if not isinstance(other, Pair):
            return NotImplemented
        return self._c == other._c

    def __repr__(self):
        return f"Pair({self.first()}, {self.second()})"
