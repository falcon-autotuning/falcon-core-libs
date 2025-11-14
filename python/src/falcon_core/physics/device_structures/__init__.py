from ..._capi.connection import Connection as _CConnection


class Connection:
    """Lightweight Python wrapper around the Cython Connection class."""

    def __init__(self, cobj):
        self._c = cobj

    @classmethod
    def new_barrier(cls, name: str):
        return cls(_CConnection.new_barrier(name))

    @classmethod
    def new_plunger(cls, name: str):
        return cls(_CConnection.new_plunger(name))

    @classmethod
    def new_reservoir(cls, name: str):
        return cls(_CConnection.new_reservoir(name))

    @classmethod
    def new_screening(cls, name: str):
        return cls(_CConnection.new_screening(name))

    @classmethod
    def new_ohmic(cls, name: str):
        return cls(_CConnection.new_ohmic(name))

    @classmethod
    def from_json(cls, json_str: str):
        return cls(_CConnection.from_json(json_str))

    def name(self) -> str:
        return self._c.name()

    def type(self) -> str:
        return self._c.type()

    def to_json(self) -> str:
        return self._c.to_json()

    def close(self):
        self._c.close()

    def is_plunger_gate(self) -> bool:
        return self._c.is_plunger_gate()

    def is_barrier_gate(self) -> bool:
        return self._c.is_barrier_gate()

    def is_screening_gate(self) -> bool:
        return self._c.is_screening_gate()

    def is_reservoir_gate(self) -> bool:
        return self._c.is_reservoir_gate()

    def is_ohmic(self) -> bool:
        return self._c.is_ohmic()

    def __eq__(self, other):
        if not isinstance(other, Connection):
            raise TypeError(
                f"Equality is not defined between Connection and {type(other)}"
            )
        return self._c == other._c
