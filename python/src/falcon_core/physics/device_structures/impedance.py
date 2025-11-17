from ..._capi.impedance import Impedance as _CImpedance


class Impedance:
    """Lightweight Python wrapper around the Cython Impedance class."""

    def __init__(self, cobj):
        self._c = cobj

    @classmethod
    def new(cls, conn, resistance: float, capacitance: float):
        return cls(_CImpedance.new(conn, resistance, capacitance))

    @classmethod
    def from_json(cls, json_str: str):
        return cls(_CImpedance.from_json(json_str))

    def connection(self):
        return self._c.connection()

    def resistance(self) -> float:
        return self._c.resistance()

    def capacitance(self) -> float:
        return self._c.capacitance()

    def to_json(self) -> str:
        return self._c.to_json()

    def __eq__(self, other):
        if not isinstance(other, Impedance):
            raise TypeError(f"Equality is not defined between Impedance and {type(other)}")
        return self._c == other._c

    def __ne__(self, other):
        if not isinstance(other, Impedance):
            raise TypeError(f"Equality is not defined between Impedance and {type(other)}")
        return self._c != other._c
