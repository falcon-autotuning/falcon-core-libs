cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .connections cimport Connections, _connections_from_capi
from .dot_gate_with_neighbors cimport DotGateWithNeighbors, _dot_gate_with_neighbors_from_capi
from .dot_gates_with_neighbors cimport DotGatesWithNeighbors, _dot_gates_with_neighbors_from_capi
from .left_reservoir_with_implanted_ohmic cimport LeftReservoirWithImplantedOhmic, _left_reservoir_with_implanted_ohmic_from_capi
from .right_reservoir_with_implanted_ohmic cimport RightReservoirWithImplantedOhmic, _right_reservoir_with_implanted_ohmic_from_capi

cdef class GateGeometryArray1D:
    def __cinit__(self):
        self.handle = <_c_api.GateGeometryArray1DHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.GateGeometryArray1DHandle>0 and self.owned:
            _c_api.GateGeometryArray1D_destroy(self.handle)
        self.handle = <_c_api.GateGeometryArray1DHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.GateGeometryArray1DHandle h
        try:
            h = _c_api.GateGeometryArray1D_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.GateGeometryArray1DHandle>0:
            raise MemoryError("Failed to create GateGeometryArray1D")
        cdef GateGeometryArray1D obj = <GateGeometryArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, Connections lineararray, Connections screening_gates):
        cdef _c_api.GateGeometryArray1DHandle h
        h = _c_api.GateGeometryArray1D_create(lineararray.handle if lineararray is not None else <_c_api.ConnectionsHandle>0, screening_gates.handle if screening_gates is not None else <_c_api.ConnectionsHandle>0)
        if h == <_c_api.GateGeometryArray1DHandle>0:
            raise MemoryError("Failed to create GateGeometryArray1D")
        cdef GateGeometryArray1D obj = <GateGeometryArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.GateGeometryArray1DHandle h_ret = _c_api.GateGeometryArray1D_copy(self.handle)
        if h_ret == <_c_api.GateGeometryArray1DHandle>0:
            return None
        return _gate_geometry_array1_d_from_capi(h_ret)

    def equal(self, GateGeometryArray1D other):
        return _c_api.GateGeometryArray1D_equal(self.handle, other.handle if other is not None else <_c_api.GateGeometryArray1DHandle>0)

    def __eq__(self, GateGeometryArray1D other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, GateGeometryArray1D other):
        return _c_api.GateGeometryArray1D_not_equal(self.handle, other.handle if other is not None else <_c_api.GateGeometryArray1DHandle>0)

    def __ne__(self, GateGeometryArray1D other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.GateGeometryArray1D_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def append_central_gate(self, Connection left_neighbor, Connection selected_gate, Connection right_neighbor):
        _c_api.GateGeometryArray1D_append_central_gate(self.handle, left_neighbor.handle if left_neighbor is not None else <_c_api.ConnectionHandle>0, selected_gate.handle if selected_gate is not None else <_c_api.ConnectionHandle>0, right_neighbor.handle if right_neighbor is not None else <_c_api.ConnectionHandle>0)

    def all_dot_gates(self, ):
        cdef _c_api.DotGatesWithNeighborsHandle h_ret = _c_api.GateGeometryArray1D_all_dot_gates(self.handle)
        if h_ret == <_c_api.DotGatesWithNeighborsHandle>0:
            return None
        return _dot_gates_with_neighbors_from_capi(h_ret)

    def query_neighbors(self, Connection gate):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_query_neighbors(self.handle, gate.handle if gate is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def left_reservoir(self, ):
        cdef _c_api.LeftReservoirWithImplantedOhmicHandle h_ret = _c_api.GateGeometryArray1D_left_reservoir(self.handle)
        if h_ret == <_c_api.LeftReservoirWithImplantedOhmicHandle>0:
            return None
        return _left_reservoir_with_implanted_ohmic_from_capi(h_ret)

    def right_reservoir(self, ):
        cdef _c_api.RightReservoirWithImplantedOhmicHandle h_ret = _c_api.GateGeometryArray1D_right_reservoir(self.handle)
        if h_ret == <_c_api.RightReservoirWithImplantedOhmicHandle>0:
            return None
        return _right_reservoir_with_implanted_ohmic_from_capi(h_ret)

    def left_barrier(self, ):
        cdef _c_api.DotGateWithNeighborsHandle h_ret = _c_api.GateGeometryArray1D_left_barrier(self.handle)
        if h_ret == <_c_api.DotGateWithNeighborsHandle>0:
            return None
        return _dot_gate_with_neighbors_from_capi(h_ret)

    def right_barrier(self, ):
        cdef _c_api.DotGateWithNeighborsHandle h_ret = _c_api.GateGeometryArray1D_right_barrier(self.handle)
        if h_ret == <_c_api.DotGateWithNeighborsHandle>0:
            return None
        return _dot_gate_with_neighbors_from_capi(h_ret)

    def linear_array(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_linear_array(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def raw_central_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_raw_central_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

    def central_dot_gates(self, ):
        cdef _c_api.DotGatesWithNeighborsHandle h_ret = _c_api.GateGeometryArray1D_central_dot_gates(self.handle)
        if h_ret == <_c_api.DotGatesWithNeighborsHandle>0:
            return None
        return _dot_gates_with_neighbors_from_capi(h_ret)

    def ohmics(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_ohmics(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret)

cdef GateGeometryArray1D _gate_geometry_array1_d_from_capi(_c_api.GateGeometryArray1DHandle h, bint owned=True):
    if h == <_c_api.GateGeometryArray1DHandle>0:
        return None
    cdef GateGeometryArray1D obj = GateGeometryArray1D.__new__(GateGeometryArray1D)
    obj.handle = h
    obj.owned = owned
    return obj
