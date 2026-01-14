from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.config import Config as _CConfig
from falcon_core.autotuner_interfaces.names.channel import Channel
from falcon_core.autotuner_interfaces.names.channels import Channels
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.physics.device_structures.gate_relations import GateRelations
from falcon_core.autotuner_interfaces.names.gname import Gname
from falcon_core.physics.config.core.group import Group
from falcon_core.physics.device_structures.impedance import Impedance
from falcon_core.physics.device_structures.impedances import Impedances
from falcon_core.generic.list import List
from falcon_core.generic.list import List
from falcon_core.generic.map import Map
from falcon_core.generic.map import Map
from falcon_core.generic.pair import Pair
from falcon_core.physics.config.core.voltage_constraints import VoltageConstraints

class Config:
    """Python wrapper for Config."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def from_json(cls, json: str) -> Config:
        return cls(_CConfig.from_json(json))

    @classmethod
    def new(cls, screening_gates: Connections, plunger_gates: Connections, ohmics: Connections, barrier_gates: Connections, reservoir_gates: Connections, groups: Map, wiring_DC: Impedances, constraints: VoltageConstraints) -> Config:
        obj = cls(_CConfig.new(screening_gates._c if screening_gates is not None else None, plunger_gates._c if plunger_gates is not None else None, ohmics._c if ohmics is not None else None, barrier_gates._c if barrier_gates is not None else None, reservoir_gates._c if reservoir_gates is not None else None, groups._c if groups is not None else None, wiring_DC._c if wiring_DC is not None else None, constraints._c if constraints is not None else None))
        obj._ref_screening_gates = screening_gates  # Keep reference alive
        obj._ref_plunger_gates = plunger_gates  # Keep reference alive
        obj._ref_ohmics = ohmics  # Keep reference alive
        obj._ref_barrier_gates = barrier_gates  # Keep reference alive
        obj._ref_reservoir_gates = reservoir_gates  # Keep reference alive
        obj._ref_groups = groups  # Keep reference alive
        obj._ref_wiring_DC = wiring_DC  # Keep reference alive
        obj._ref_constraints = constraints  # Keep reference alive
        return obj

    def copy(self, ) -> Config:
        ret = self._c.copy()
        return Config._from_capi(ret)

    def equal(self, other: Config) -> bool:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: Config) -> bool:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def num_unique_channels(self, ) -> int:
        ret = self._c.num_unique_channels()
        return ret

    def get_impedance(self, connection: Connection) -> Impedance:
        ret = self._c.get_impedance(connection._c if connection is not None else None)
        if ret is None: return None
        return Impedance._from_capi(ret)

    def has_channel(self, channel: Channel) -> bool:
        ret = self._c.has_channel(channel._c if channel is not None else None)
        return ret

    def has_gname(self, gname: Gname) -> bool:
        ret = self._c.has_gname(gname._c if gname is not None else None)
        return ret

    def select_group(self, gname: Gname) -> Group:
        ret = self._c.select_group(gname._c if gname is not None else None)
        if ret is None: return None
        return Group._from_capi(ret)

    def get_dot_number(self, channel: Channel) -> int:
        ret = self._c.get_dot_number(channel._c if channel is not None else None)
        return ret

    def ohmic_in_charge_sensor(self, ohmic: Connection) -> bool:
        ret = self._c.ohmic_in_charge_sensor(ohmic._c if ohmic is not None else None)
        return ret

    def get_associated_ohmic(self, reservoir_gate: Connection) -> Connection:
        ret = self._c.get_associated_ohmic(reservoir_gate._c if reservoir_gate is not None else None)
        if ret is None: return None
        return Connection._from_capi(ret)

    def get_gname(self, channel: Channel) -> Gname:
        ret = self._c.get_gname(channel._c if channel is not None else None)
        if ret is None: return None
        return Gname._from_capi(ret)

    def get_group_barrier_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_barrier_gates(gname._c if gname is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_plunger_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_plunger_gates(gname._c if gname is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_reservoir_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_reservoir_gates(gname._c if gname is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_screening_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_screening_gates(gname._c if gname is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_dot_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_dot_gates(gname._c if gname is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_gates(gname._c if gname is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_barrier_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_barrier_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_plunger_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_plunger_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_reservoir_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_reservoir_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_screening_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_screening_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_dot_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_dot_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_ohmics(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_ohmics(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_order_no_ohmics(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_order_no_ohmics(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def return_channels_from_gate(self, gate: Connection) -> Channels:
        ret = self._c.return_channels_from_gate(gate._c if gate is not None else None)
        if ret is None: return None
        return Channels._from_capi(ret)

    def return_channel_from_gate(self, gate: Connection) -> Channel:
        ret = self._c.return_channel_from_gate(gate._c if gate is not None else None)
        if ret is None: return None
        return Channel._from_capi(ret)

    def ohmic_in_channel(self, ohmic: Connection, channel: Channel) -> bool:
        ret = self._c.ohmic_in_channel(ohmic._c if ohmic is not None else None, channel._c if channel is not None else None)
        return ret

    def get_dot_channel_neighbors(self, dot_gate: Connection) -> Pair:
        ret = self._c.get_dot_channel_neighbors(dot_gate._c if dot_gate is not None else None)
        if ret is None: return None
        return Pair(ret)

    def get_shared_channel_barrier_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_barrier_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_plunger_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_plunger_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_reservoir_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_reservoir_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_screening_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_screening_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_dot_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_dot_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_barrier_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_barrier_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_plunger_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_plunger_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_reservoir_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_reservoir_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_screening_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_screening_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_dot_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_dot_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_gates(channel._c if channel is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def generate_gate_relations(self, ) -> GateRelations:
        ret = self._c.generate_gate_relations()
        if ret is None: return None
        return GateRelations._from_capi(ret)

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
    def all_gnames(self) -> List:
        ret = self._c.get_all_gnames()
        if ret is None: return None
        return List(ret)

    @property
    def all_groups(self) -> List:
        ret = self._c.get_all_groups()
        if ret is None: return None
        return List(ret)

    @property
    def barrier_gate(self) -> Connection:
        ret = self._c.get_barrier_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    @property
    def barrier_gate_dict(self) -> Map:
        ret = self._c.get_barrier_gate_dict()
        if ret is None: return None
        return Map(ret)

    @property
    def barrier_gates(self) -> Connections:
        ret = self._c.barrier_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def channels(self) -> Channels:
        ret = self._c.channels()
        if ret is None: return None
        return Channels._from_capi(ret)

    @property
    def charge_sense_groups(self) -> List:
        ret = self._c.get_charge_sense_groups()
        if ret is None: return None
        return List(ret)

    @property
    def current_channels(self) -> Channels:
        ret = self._c.get_current_channels()
        if ret is None: return None
        return Channels._from_capi(ret)

    @property
    def dot_gate(self) -> Connection:
        ret = self._c.get_dot_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    @property
    def dot_gate_dict(self) -> Map:
        ret = self._c.get_dot_gate_dict()
        if ret is None: return None
        return Map(ret)

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
    def gate_dict(self) -> Map:
        ret = self._c.get_gate_dict()
        if ret is None: return None
        return Map(ret)

    @property
    def groups(self) -> Map:
        ret = self._c.groups()
        if ret is None: return None
        return Map(ret)

    @property
    def isolated_barrier_gates(self) -> Connections:
        ret = self._c.get_isolated_barrier_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def isolated_barrier_gates_by_channel(self) -> Map:
        ret = self._c.get_isolated_barrier_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    @property
    def isolated_dot_gates(self) -> Connections:
        ret = self._c.get_isolated_dot_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def isolated_dot_gates_by_channel(self) -> Map:
        ret = self._c.get_isolated_dot_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    @property
    def isolated_gates(self) -> Connections:
        ret = self._c.get_isolated_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def isolated_gates_by_channel(self) -> Map:
        ret = self._c.get_isolated_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    @property
    def isolated_plunger_gates(self) -> Connections:
        ret = self._c.get_isolated_plunger_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def isolated_plunger_gates_by_channel(self) -> Map:
        ret = self._c.get_isolated_plunger_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    @property
    def isolated_reservoir_gates(self) -> Connections:
        ret = self._c.get_isolated_reservoir_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def isolated_reservoir_gates_by_channel(self) -> Map:
        ret = self._c.get_isolated_reservoir_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    @property
    def isolated_screening_gates(self) -> Connections:
        ret = self._c.get_isolated_screening_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def isolated_screening_gates_by_channel(self) -> Map:
        ret = self._c.get_isolated_screening_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    @property
    def num_unique_channels(self) -> int:
        ret = self._c.get_num_unique_channels()
        return ret

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
    def plunger_gate_dict(self) -> Map:
        ret = self._c.get_plunger_gate_dict()
        if ret is None: return None
        return Map(ret)

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
    def reservoir_gate_dict(self) -> Map:
        ret = self._c.get_reservoir_gate_dict()
        if ret is None: return None
        return Map(ret)

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
    def screening_gate_dict(self) -> Map:
        ret = self._c.get_screening_gate_dict()
        if ret is None: return None
        return Map(ret)

    @property
    def screening_gates(self) -> Connections:
        ret = self._c.screening_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def shared_barrier_gates(self) -> Connections:
        ret = self._c.get_shared_barrier_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def shared_dot_gates(self) -> Connections:
        ret = self._c.get_shared_dot_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def shared_gates(self) -> Connections:
        ret = self._c.get_shared_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def shared_plunger_gates(self) -> Connections:
        ret = self._c.get_shared_plunger_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def shared_reservoir_gates(self) -> Connections:
        ret = self._c.get_shared_reservoir_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def shared_screening_gates(self) -> Connections:
        ret = self._c.get_shared_screening_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    @property
    def voltage_constraints(self) -> VoltageConstraints:
        ret = self._c.voltage_constraints()
        if ret is None: return None
        return VoltageConstraints._from_capi(ret)

    @property
    def wiring_DC(self) -> Impedances:
        ret = self._c.wiring_DC()
        if ret is None: return None
        return Impedances._from_capi(ret)

    def __repr__(self):
        return f"Config({self.to_json()})"

    def __str__(self):
        return self.to_json()

    def __hash__(self):
        """Hash based on JSON representation"""
        return hash(self.to_json())

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, Config):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, Config):
            return NotImplemented
        return self.not_equal(other)
