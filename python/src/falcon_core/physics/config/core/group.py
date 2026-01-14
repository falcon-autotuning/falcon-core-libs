from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.group import Group as _CGroup
from falcon_core.autotuner_interfaces.names.channel import Channel
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.physics.config.geometries.gate_geometry_array1_d import GateGeometryArray1D

class Group:
    """Python wrapper for Group."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> Group:
        return cls(_CGroup.from_json(json))

    @classmethod
    def new(cls, name: Channel, num_dots: Any, screening_gates: Connections, reservoir_gates: Connections, plunger_gates: Connections, barrier_gates: Connections, order: Connections) -> Group:
        obj = cls(_CGroup.new(name._c if name is not None else None, num_dots, screening_gates._c if screening_gates is not None else None, reservoir_gates._c if reservoir_gates is not None else None, plunger_gates._c if plunger_gates is not None else None, barrier_gates._c if barrier_gates is not None else None, order._c if order is not None else None))
        obj._ref_name = name  # Keep reference alive
        obj._ref_screening_gates = screening_gates  # Keep reference alive
        obj._ref_reservoir_gates = reservoir_gates  # Keep reference alive
        obj._ref_plunger_gates = plunger_gates  # Keep reference alive
        obj._ref_barrier_gates = barrier_gates  # Keep reference alive
        obj._ref_order = order  # Keep reference alive
        return obj

    def copy(self, ) -> Group:
        ret = self._c.copy()
        return Group._from_capi(ret)

    def equal(self, other: Group) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Group) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def num_dots(self, ) -> int:
        ret = self._c.num_dots()
        return ret

    def order(self, ) -> GateGeometryArray1D:
        ret = self._c.order()
        if ret is None: return None
        return GateGeometryArray1D._from_capi(ret)

    def has_channel(self, channel: Channel) -> bool:
        ret = self._c.has_channel(channel._c if channel is not None else None)
        return ret

    def is_charge_sensor(self, ) -> bool:
        ret = self._c.is_charge_sensor()
        return ret

    def has_ohmic(self, ohmic: Connection) -> bool:
        ret = self._c.has_ohmic(ohmic._c if ohmic is not None else None)
        return ret

    def has_gate(self, gate: Connection) -> bool:
        ret = self._c.has_gate(gate._c if gate is not None else None)
        return ret

    def has_barrier_gate(self, barrier_gate: Connection) -> bool:
        ret = self._c.has_barrier_gate(barrier_gate._c if barrier_gate is not None else None)
        return ret

    def has_plunger_gate(self, plunger_gate: Connection) -> bool:
        ret = self._c.has_plunger_gate(plunger_gate._c if plunger_gate is not None else None)
        return ret

    def has_reservoir_gate(self, reservoir_gate: Connection) -> bool:
        ret = self._c.has_reservoir_gate(reservoir_gate._c if reservoir_gate is not None else None)
        return ret

    def has_screening_gate(self, screening_gate: Connection) -> bool:
        ret = self._c.has_screening_gate(screening_gate._c if screening_gate is not None else None)
        return ret

    @property
    def all_channel_gates(self) -> Connections:
        ret = self._c.get_all_channel_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def all_connections(self) -> Connections:
        ret = self._c.get_all_connections()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def all_gates(self) -> Connections:
        ret = self._c.get_all_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def barrier_gate(self) -> Connection:
        ret = self._c.get_barrier_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    @property
    def barrier_gates(self) -> Connections:
        ret = self._c.barrier_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def dot_gate(self) -> Connection:
        ret = self._c.get_dot_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    @property
    def dot_gates(self) -> Connections:
        ret = self._c.dot_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def gate(self) -> Connection:
        ret = self._c.get_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    @property
    def name(self) -> Channel:
        ret = self._c.name()
        if ret is None: return None
        return Channel._from_capi(ret)

    @property
    def ohmic(self) -> Connection:
        ret = self._c.get_ohmic()
        if ret is None: return None
        return Connection._from_capi(ret)

    @property
    def ohmics(self) -> Connections:
        ret = self._c.ohmics()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def plunger_gate(self) -> Connection:
        ret = self._c.get_plunger_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    @property
    def plunger_gates(self) -> Connections:
        ret = self._c.plunger_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def reservoir_gate(self) -> Connection:
        ret = self._c.get_reservoir_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    @property
    def reservoir_gates(self) -> Connections:
        ret = self._c.reservoir_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def screening_gate(self) -> Connection:
        ret = self._c.get_screening_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    @property
    def screening_gates(self) -> Connections:
        ret = self._c.screening_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def __repr__(self):
        return f"Group({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Group):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Group):
            return NotImplemented
        return self.not_equal(other)
