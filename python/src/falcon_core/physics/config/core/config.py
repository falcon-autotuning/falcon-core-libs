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
    def Config_create(cls, screening_gates: Connections, plunger_gates: Connections, ohmics: Connections, barrier_gates: Connections, reservoir_gates: Connections, groups: Map, wiring_DC: Impedances, constraints: VoltageConstraints) -> Config:
        return cls(_CConfig.Config_create(screening_gates._c, plunger_gates._c, ohmics._c, barrier_gates._c, reservoir_gates._c, groups._c, wiring_DC._c, constraints._c))

    @classmethod
    def Config_from_json_string(cls, json: str) -> Config:
        return cls(_CConfig.Config_from_json_string(json))

    def num_unique_channels(self, ) -> None:
        ret = self._c.num_unique_channels()
        return ret

    def voltage_constraints(self, ) -> VoltageConstraints:
        ret = self._c.voltage_constraints()
        if ret is None: return None
        return VoltageConstraints._from_capi(ret)

    def groups(self, ) -> Map:
        ret = self._c.groups()
        if ret is None: return None
        return Map(ret)

    def wiring_DC(self, ) -> Impedances:
        ret = self._c.wiring_DC()
        if ret is None: return None
        return Impedances._from_capi(ret)

    def channels(self, ) -> Channels:
        ret = self._c.channels()
        if ret is None: return None
        return Channels._from_capi(ret)

    def get_impedance(self, connection: Connection) -> Impedance:
        ret = self._c.get_impedance(connection._c)
        if ret is None: return None
        return Impedance._from_capi(ret)

    def get_all_gnames(self, ) -> List:
        ret = self._c.get_all_gnames()
        if ret is None: return None
        return List(ret)

    def get_all_groups(self, ) -> List:
        ret = self._c.get_all_groups()
        if ret is None: return None
        return List(ret)

    def has_channel(self, channel: Channel) -> None:
        ret = self._c.has_channel(channel._c)
        return ret

    def has_gname(self, gname: Gname) -> None:
        ret = self._c.has_gname(gname._c)
        return ret

    def select_group(self, gname: Gname) -> Group:
        ret = self._c.select_group(gname._c)
        if ret is None: return None
        return Group._from_capi(ret)

    def get_dot_number(self, channel: Channel) -> None:
        ret = self._c.get_dot_number(channel._c)
        return ret

    def get_charge_sense_groups(self, ) -> List:
        ret = self._c.get_charge_sense_groups()
        if ret is None: return None
        return List(ret)

    def ohmic_in_charge_sensor(self, ohmic: Connection) -> None:
        ret = self._c.ohmic_in_charge_sensor(ohmic._c)
        return ret

    def get_associated_ohmic(self, reservoir_gate: Connection) -> Connection:
        ret = self._c.get_associated_ohmic(reservoir_gate._c)
        if ret is None: return None
        return Connection._from_capi(ret)

    def get_current_channels(self, ) -> Channels:
        ret = self._c.get_current_channels()
        if ret is None: return None
        return Channels._from_capi(ret)

    def get_gname(self, channel: Channel) -> Gname:
        ret = self._c.get_gname(channel._c)
        if ret is None: return None
        return Gname._from_capi(ret)

    def get_group_barrier_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_barrier_gates(gname._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_plunger_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_plunger_gates(gname._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_reservoir_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_reservoir_gates(gname._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_screening_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_screening_gates(gname._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_dot_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_dot_gates(gname._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_group_gates(self, gname: Gname) -> Connections:
        ret = self._c.get_group_gates(gname._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_barrier_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_barrier_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_plunger_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_plunger_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_reservoir_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_reservoir_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_screening_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_screening_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_dot_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_dot_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_ohmics(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_ohmics(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_channel_order_no_ohmics(self, channel: Channel) -> Connections:
        ret = self._c.get_channel_order_no_ohmics(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_num_unique_channels(self, ) -> None:
        ret = self._c.get_num_unique_channels()
        return ret

    def return_channels_from_gate(self, gate: Connection) -> Channels:
        ret = self._c.return_channels_from_gate(gate._c)
        if ret is None: return None
        return Channels._from_capi(ret)

    def return_channel_from_gate(self, gate: Connection) -> Channel:
        ret = self._c.return_channel_from_gate(gate._c)
        if ret is None: return None
        return Channel._from_capi(ret)

    def ohmic_in_channel(self, ohmic: Connection, channel: Channel) -> None:
        ret = self._c.ohmic_in_channel(ohmic._c, channel._c)
        return ret

    def get_dot_channel_neighbors(self, dot_gate: Connection) -> Pair:
        ret = self._c.get_dot_channel_neighbors(dot_gate._c)
        if ret is None: return None
        return Pair(ret)

    def get_barrier_gate_dict(self, ) -> Map:
        ret = self._c.get_barrier_gate_dict()
        if ret is None: return None
        return Map(ret)

    def get_plunger_gate_dict(self, ) -> Map:
        ret = self._c.get_plunger_gate_dict()
        if ret is None: return None
        return Map(ret)

    def get_reservoir_gate_dict(self, ) -> Map:
        ret = self._c.get_reservoir_gate_dict()
        if ret is None: return None
        return Map(ret)

    def get_screening_gate_dict(self, ) -> Map:
        ret = self._c.get_screening_gate_dict()
        if ret is None: return None
        return Map(ret)

    def get_dot_gate_dict(self, ) -> Map:
        ret = self._c.get_dot_gate_dict()
        if ret is None: return None
        return Map(ret)

    def get_gate_dict(self, ) -> Map:
        ret = self._c.get_gate_dict()
        if ret is None: return None
        return Map(ret)

    def get_isolated_barrier_gates(self, ) -> Connections:
        ret = self._c.get_isolated_barrier_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_plunger_gates(self, ) -> Connections:
        ret = self._c.get_isolated_plunger_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_reservoir_gates(self, ) -> Connections:
        ret = self._c.get_isolated_reservoir_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_screening_gates(self, ) -> Connections:
        ret = self._c.get_isolated_screening_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_dot_gates(self, ) -> Connections:
        ret = self._c.get_isolated_dot_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_gates(self, ) -> Connections:
        ret = self._c.get_isolated_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_barrier_gates(self, ) -> Connections:
        ret = self._c.get_shared_barrier_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_plunger_gates(self, ) -> Connections:
        ret = self._c.get_shared_plunger_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_reservoir_gates(self, ) -> Connections:
        ret = self._c.get_shared_reservoir_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_screening_gates(self, ) -> Connections:
        ret = self._c.get_shared_screening_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_dot_gates(self, ) -> Connections:
        ret = self._c.get_shared_dot_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_gates(self, ) -> Connections:
        ret = self._c.get_shared_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_barrier_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_barrier_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_plunger_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_plunger_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_reservoir_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_reservoir_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_screening_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_screening_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_dot_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_dot_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_shared_channel_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_shared_channel_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_barrier_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_barrier_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_plunger_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_plunger_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_reservoir_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_reservoir_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_screening_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_screening_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_dot_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_dot_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_channel_gates(self, channel: Channel) -> Connections:
        ret = self._c.get_isolated_channel_gates(channel._c)
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_isolated_barrier_gates_by_channel(self, ) -> Map:
        ret = self._c.get_isolated_barrier_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    def get_isolated_plunger_gates_by_channel(self, ) -> Map:
        ret = self._c.get_isolated_plunger_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    def get_isolated_reservoir_gates_by_channel(self, ) -> Map:
        ret = self._c.get_isolated_reservoir_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    def get_isolated_screening_gates_by_channel(self, ) -> Map:
        ret = self._c.get_isolated_screening_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    def get_isolated_dot_gates_by_channel(self, ) -> Map:
        ret = self._c.get_isolated_dot_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    def get_isolated_gates_by_channel(self, ) -> Map:
        ret = self._c.get_isolated_gates_by_channel()
        if ret is None: return None
        return Map(ret)

    def generate_gate_relations(self, ) -> GateRelations:
        ret = self._c.generate_gate_relations()
        if ret is None: return None
        return GateRelations._from_capi(ret)

    def screening_gates(self, ) -> Connections:
        ret = self._c.screening_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def reservoir_gates(self, ) -> Connections:
        ret = self._c.reservoir_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def plunger_gates(self, ) -> Connections:
        ret = self._c.plunger_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def barrier_gates(self, ) -> Connections:
        ret = self._c.barrier_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def ohmics(self, ) -> Connections:
        ret = self._c.ohmics()
        if ret is None: return None
        return Connections._from_capi(ret)

    def dot_gates(self, ) -> Connections:
        ret = self._c.dot_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_ohmic(self, ) -> Connection:
        ret = self._c.get_ohmic()
        if ret is None: return None
        return Connection._from_capi(ret)

    def get_barrier_gate(self, ) -> Connection:
        ret = self._c.get_barrier_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    def get_plunger_gate(self, ) -> Connection:
        ret = self._c.get_plunger_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    def get_reservoir_gate(self, ) -> Connection:
        ret = self._c.get_reservoir_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    def get_screening_gate(self, ) -> Connection:
        ret = self._c.get_screening_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    def get_dot_gate(self, ) -> Connection:
        ret = self._c.get_dot_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    def get_gate(self, ) -> Connection:
        ret = self._c.get_gate()
        if ret is None: return None
        return Connection._from_capi(ret)

    def get_all_gates(self, ) -> Connections:
        ret = self._c.get_all_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def get_all_connections(self, ) -> Connections:
        ret = self._c.get_all_connections()
        if ret is None: return None
        return Connections._from_capi(ret)

    def has_ohmic(self, ohmic: Connection) -> None:
        ret = self._c.has_ohmic(ohmic._c)
        return ret

    def has_gate(self, gate: Connection) -> None:
        ret = self._c.has_gate(gate._c)
        return ret

    def has_barrier_gate(self, barrier_gate: Connection) -> None:
        ret = self._c.has_barrier_gate(barrier_gate._c)
        return ret

    def has_plunger_gate(self, plunger_gate: Connection) -> None:
        ret = self._c.has_plunger_gate(plunger_gate._c)
        return ret

    def has_reservoir_gate(self, reservoir_gate: Connection) -> None:
        ret = self._c.has_reservoir_gate(reservoir_gate._c)
        return ret

    def has_screening_gate(self, screening_gate: Connection) -> None:
        ret = self._c.has_screening_gate(screening_gate._c)
        return ret

    def equal(self, other: Config) -> None:
        ret = self._c.equal(other._c)
        return ret

    def __eq__(self, other: Config) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other: Config) -> None:
        ret = self._c.not_equal(other._c)
        return ret

    def __ne__(self, other: Config) -> None:
        if not hasattr(other, "_c"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self, ) -> str:
        ret = self._c.to_json_string()
        return ret
