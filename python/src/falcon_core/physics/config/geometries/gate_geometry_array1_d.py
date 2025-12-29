from __future__ import annotations
from typing import Any, List, Dict, Tuple, Optional
from falcon_core._capi.gate_geometry_array1_d import GateGeometryArray1D as _CGateGeometryArray1D
from falcon_core.physics.device_structures.connection import Connection
from falcon_core.physics.device_structures.connections import Connections
from falcon_core.physics.config.geometries.dot_gate_with_neighbors import DotGateWithNeighbors
from falcon_core.physics.config.geometries.dot_gates_with_neighbors import DotGatesWithNeighbors
from falcon_core.physics.config.geometries.left_reservoir_with_implanted_ohmic import LeftReservoirWithImplantedOhmic
from falcon_core.physics.config.geometries.right_reservoir_with_implanted_ohmic import RightReservoirWithImplantedOhmic

class GateGeometryArray1D:
    """Python wrapper for GateGeometryArray1D."""

    def __init__(self, c_obj):
        self._c = c_obj

    @classmethod
    def _from_capi(cls, c_obj):
        if c_obj is None:
            return None
        return cls(c_obj)

    @classmethod
    def new(cls, lineararray: Connections, screening_gates: Connections) -> GateGeometryArray1D:
        return cls(_CGateGeometryArray1D.new(lineararray._c if lineararray is not None else None, screening_gates._c if screening_gates is not None else None))

    @classmethod
    def from_json(cls, json: str) -> GateGeometryArray1D:
        return cls(_CGateGeometryArray1D.from_json(json))

    def append_central_gate(self, left_neighbor: Connection, selected_gate: Connection, right_neighbor: Connection) -> None:
        ret = self._c.append_central_gate(left_neighbor._c if left_neighbor is not None else None, selected_gate._c if selected_gate is not None else None, right_neighbor._c if right_neighbor is not None else None)
        return ret

    def all_dot_gates(self, ) -> DotGatesWithNeighbors:
        ret = self._c.all_dot_gates()
        if ret is None: return None
        return DotGatesWithNeighbors._from_capi(ret)

    def query_neighbors(self, gate: Connection) -> Connections:
        ret = self._c.query_neighbors(gate._c if gate is not None else None)
        if ret is None: return None
        return Connections._from_capi(ret)

    def left_reservoir(self, ) -> LeftReservoirWithImplantedOhmic:
        ret = self._c.left_reservoir()
        if ret is None: return None
        return LeftReservoirWithImplantedOhmic._from_capi(ret)

    def right_reservoir(self, ) -> RightReservoirWithImplantedOhmic:
        ret = self._c.right_reservoir()
        if ret is None: return None
        return RightReservoirWithImplantedOhmic._from_capi(ret)

    def left_barrier(self, ) -> DotGateWithNeighbors:
        ret = self._c.left_barrier()
        if ret is None: return None
        return DotGateWithNeighbors._from_capi(ret)

    def right_barrier(self, ) -> DotGateWithNeighbors:
        ret = self._c.right_barrier()
        if ret is None: return None
        return DotGateWithNeighbors._from_capi(ret)

    def linear_array(self, ) -> Connections:
        ret = self._c.linear_array()
        if ret is None: return None
        return Connections._from_capi(ret)

    def screening_gates(self, ) -> Connections:
        ret = self._c.screening_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def raw_central_gates(self, ) -> Connections:
        ret = self._c.raw_central_gates()
        if ret is None: return None
        return Connections._from_capi(ret)

    def central_dot_gates(self, ) -> DotGatesWithNeighbors:
        ret = self._c.central_dot_gates()
        if ret is None: return None
        return DotGatesWithNeighbors._from_capi(ret)

    def ohmics(self, ) -> Connections:
        ret = self._c.ohmics()
        if ret is None: return None
        return Connections._from_capi(ret)

    def equal(self, other: GateGeometryArray1D) -> None:
        ret = self._c.equal(other._c if other is not None else None)
        return ret

    def not_equal(self, other: GateGeometryArray1D) -> None:
        ret = self._c.not_equal(other._c if other is not None else None)
        return ret

    def to_json(self, ) -> str:
        ret = self._c.to_json()
        return ret

    def __eq__(self, other):
        """Operator overload for =="""
        if not isinstance(other, GateGeometryArray1D):
            return NotImplemented
        return self.equal(other)

    def __ne__(self, other):
        """Operator overload for !="""
        if not isinstance(other, GateGeometryArray1D):
            return NotImplemented
        return self.not_equal(other)
