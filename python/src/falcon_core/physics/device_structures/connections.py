from ..._capi.connections import Connections as _CConnections
from ..._capi.list_connection import ListConnection as _CListConnection
from ...generic.list import List as GenericList
from .connection import Connection as PyConnection


class Connections:
    """
    High-level Python wrapper that behaves like a list of Connection while delegating
    storage and many operations to the underlying _capi.Connections (C API backed).
    """

    def __init__(self, cobj):
        # cobj is the low-level Cython Connections instance
        self._c = cobj
        # Build a generic.List wrapper around the low-level object so Pythonic
        # list ops (iteration, indexing) work. We intentionally do not pass
        # a c_list_type because modifications should be delegated to the
        # Connections backend.
        self._list = GenericList(self._c)

    @classmethod
    def new_empty(cls):
        return cls(_CConnections.create_empty())

    @classmethod
    def from_list(cls, conn_list: list):
        # Accept a list of Python-level Connection wrappers
        return cls(_CConnections.from_list(conn_list))

    def append(self, conn: PyConnection):
        self._c.push_back(conn)

    def __len__(self):
        return len(self._list)

    def __getitem__(self, idx):
        return self._list[idx]

    def __iter__(self):
        return iter(self._list)

    def __contains__(self, item):
        # let low-level contains handle comparisons
        return self._c.contains(item)

    def index(self, item):
        return self._c.index(item)

    def erase_at(self, idx: int):
        self._c.erase_at(idx)

    def clear(self):
        self._c.clear()

    def intersection(self, other: "Connections"):
        return Connections(self._c.intersection(other._c))

    def to_json(self) -> str:
        return self._c.to_json()

    @classmethod
    def from_json(cls, json_str: str):
        return cls(_CConnections.from_json(json_str))

    # convenience accessors delegating to low-level impl
    def is_gates(self):
        return self._c.is_gates()

    def is_ohmics(self):
        return self._c.is_ohmics()

    def is_dot_gates(self):
        return self._c.is_dot_gates()

    def is_plunger_gates(self):
        return self._c.is_plunger_gates()

    def is_barrier_gates(self):
        return self._c.is_barrier_gates()

    def is_reservoir_gates(self):
        return self._c.is_reservoir_gates()

    def is_screening_gates(self):
        return self._c.is_screening_gates()

    def __eq__(self, other):
        if not isinstance(other, Connections):
            raise TypeError(f"Equality is not defined between Connections and {type(other)}")
        return self._c == other._c

    def __ne__(self, other):
        if not isinstance(other, Connections):
            raise TypeError(f"Equality is not defined between Connections and {type(other)}")
        return self._c != other._c

    def items(self):
        # Return a Generic List wrapper built from a low-level ListConnection
        c_list = self._c.items()
        return GenericList(c_list)
