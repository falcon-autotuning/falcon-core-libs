# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .connections cimport Connections
from .dot_gate_with_neighbors cimport DotGateWithNeighbors
from .dot_gates_with_neighbors cimport DotGatesWithNeighbors
from .left_reservoir_with_implanted_ohmic cimport LeftReservoirWithImplantedOhmic
from .right_reservoir_with_implanted_ohmic cimport RightReservoirWithImplantedOhmic

cdef class GateGeometryArray1D:
    cdef c_api.GateGeometryArray1DHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.GateGeometryArray1DHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.GateGeometryArray1DHandle>0 and self.owned:
            c_api.GateGeometryArray1D_destroy(self.handle)
        self.handle = <c_api.GateGeometryArray1DHandle>0

    cdef GateGeometryArray1D from_capi(cls, c_api.GateGeometryArray1DHandle h):
        cdef GateGeometryArray1D obj = <GateGeometryArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, lineararray, screening_gates):
        cdef c_api.GateGeometryArray1DHandle h
        h = c_api.GateGeometryArray1D_create(<c_api.ConnectionsHandle>lineararray.handle, <c_api.ConnectionsHandle>screening_gates.handle)
        if h == <c_api.GateGeometryArray1DHandle>0:
            raise MemoryError("Failed to create GateGeometryArray1D")
        cdef GateGeometryArray1D obj = <GateGeometryArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.GateGeometryArray1DHandle h
        try:
            h = c_api.GateGeometryArray1D_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.GateGeometryArray1DHandle>0:
            raise MemoryError("Failed to create GateGeometryArray1D")
        cdef GateGeometryArray1D obj = <GateGeometryArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def append_central_gate(self, left_neighbor, selected_gate, right_neighbor):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        c_api.GateGeometryArray1D_append_central_gate(self.handle, <c_api.ConnectionHandle>left_neighbor.handle, <c_api.ConnectionHandle>selected_gate.handle, <c_api.ConnectionHandle>right_neighbor.handle)

    def all_dot_gates(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DotGatesWithNeighborsHandle h_ret
        h_ret = c_api.GateGeometryArray1D_all_dot_gates(self.handle)
        if h_ret == <c_api.DotGatesWithNeighborsHandle>0:
            return None
        return DotGatesWithNeighbors.from_capi(DotGatesWithNeighbors, h_ret)

    def query_neighbors(self, gate):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.GateGeometryArray1D_query_neighbors(self.handle, <c_api.ConnectionHandle>gate.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def left_reservoir(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.LeftReservoirWithImplantedOhmicHandle h_ret
        h_ret = c_api.GateGeometryArray1D_left_reservoir(self.handle)
        if h_ret == <c_api.LeftReservoirWithImplantedOhmicHandle>0:
            return None
        return LeftReservoirWithImplantedOhmic.from_capi(LeftReservoirWithImplantedOhmic, h_ret)

    def right_reservoir(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.RightReservoirWithImplantedOhmicHandle h_ret
        h_ret = c_api.GateGeometryArray1D_right_reservoir(self.handle)
        if h_ret == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            return None
        return RightReservoirWithImplantedOhmic.from_capi(RightReservoirWithImplantedOhmic, h_ret)

    def left_barrier(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DotGateWithNeighborsHandle h_ret
        h_ret = c_api.GateGeometryArray1D_left_barrier(self.handle)
        if h_ret == <c_api.DotGateWithNeighborsHandle>0:
            return None
        return DotGateWithNeighbors.from_capi(DotGateWithNeighbors, h_ret)

    def right_barrier(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DotGateWithNeighborsHandle h_ret
        h_ret = c_api.GateGeometryArray1D_right_barrier(self.handle)
        if h_ret == <c_api.DotGateWithNeighborsHandle>0:
            return None
        return DotGateWithNeighbors.from_capi(DotGateWithNeighbors, h_ret)

    def lineararray(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.GateGeometryArray1D_lineararray(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def screening_gates(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.GateGeometryArray1D_screening_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def raw_central_gates(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.GateGeometryArray1D_raw_central_gates(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def central_dot_gates(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.DotGatesWithNeighborsHandle h_ret
        h_ret = c_api.GateGeometryArray1D_central_dot_gates(self.handle)
        if h_ret == <c_api.DotGatesWithNeighborsHandle>0:
            return None
        return DotGatesWithNeighbors.from_capi(DotGatesWithNeighbors, h_ret)

    def ohmics(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.GateGeometryArray1D_ohmics(self.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def equal(self, other):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.GateGeometryArray1D_equal(self.handle, <c_api.GateGeometryArray1DHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.GateGeometryArray1D_not_equal(self.handle, <c_api.GateGeometryArray1DHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.GateGeometryArray1DHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.GateGeometryArray1D_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef GateGeometryArray1D _gategeometryarray1d_from_capi(c_api.GateGeometryArray1DHandle h):
    cdef GateGeometryArray1D obj = <GateGeometryArray1D>GateGeometryArray1D.__new__(GateGeometryArray1D)
    obj.handle = h