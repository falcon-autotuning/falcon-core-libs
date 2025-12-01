cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport connections
from . cimport dot_gate_with_neighbors
from . cimport dot_gates_with_neighbors
from . cimport left_reservoir_with_implanted_ohmic
from . cimport right_reservoir_with_implanted_ohmic

cdef class GateGeometryArray1D:
    def __cinit__(self):
        self.handle = <_c_api.GateGeometryArray1DHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.GateGeometryArray1DHandle>0 and self.owned:
            _c_api.GateGeometryArray1D_destroy(self.handle)
        self.handle = <_c_api.GateGeometryArray1DHandle>0


cdef GateGeometryArray1D _gate_geometry_array1_d_from_capi(_c_api.GateGeometryArray1DHandle h):
    if h == <_c_api.GateGeometryArray1DHandle>0:
        return None
    cdef GateGeometryArray1D obj = GateGeometryArray1D.__new__(GateGeometryArray1D)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, Connections lineararray, Connections screening_gates):
        cdef _c_api.GateGeometryArray1DHandle h
        h = _c_api.GateGeometryArray1D_create(lineararray.handle, screening_gates.handle)
        if h == <_c_api.GateGeometryArray1DHandle>0:
            raise MemoryError("Failed to create GateGeometryArray1D")
        cdef GateGeometryArray1D obj = <GateGeometryArray1D>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def append_central_gate(self, Connection left_neighbor, Connection selected_gate, Connection right_neighbor):
        _c_api.GateGeometryArray1D_append_central_gate(self.handle, left_neighbor.handle, selected_gate.handle, right_neighbor.handle)

    def all_dot_gates(self, ):
        cdef _c_api.DotGatesWithNeighborsHandle h_ret = _c_api.GateGeometryArray1D_all_dot_gates(self.handle)
        if h_ret == <_c_api.DotGatesWithNeighborsHandle>0:
            return None
        return dot_gates_with_neighbors._dot_gates_with_neighbors_from_capi(h_ret)

    def query_neighbors(self, Connection gate):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_query_neighbors(self.handle, gate.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def left_reservoir(self, ):
        cdef _c_api.LeftReservoirWithImplantedOhmicHandle h_ret = _c_api.GateGeometryArray1D_left_reservoir(self.handle)
        if h_ret == <_c_api.LeftReservoirWithImplantedOhmicHandle>0:
            return None
        return left_reservoir_with_implanted_ohmic._left_reservoir_with_implanted_ohmic_from_capi(h_ret)

    def right_reservoir(self, ):
        cdef _c_api.RightReservoirWithImplantedOhmicHandle h_ret = _c_api.GateGeometryArray1D_right_reservoir(self.handle)
        if h_ret == <_c_api.RightReservoirWithImplantedOhmicHandle>0:
            return None
        return right_reservoir_with_implanted_ohmic._right_reservoir_with_implanted_ohmic_from_capi(h_ret)

    def left_barrier(self, ):
        cdef _c_api.DotGateWithNeighborsHandle h_ret = _c_api.GateGeometryArray1D_left_barrier(self.handle)
        if h_ret == <_c_api.DotGateWithNeighborsHandle>0:
            return None
        return dot_gate_with_neighbors._dot_gate_with_neighbors_from_capi(h_ret)

    def right_barrier(self, ):
        cdef _c_api.DotGateWithNeighborsHandle h_ret = _c_api.GateGeometryArray1D_right_barrier(self.handle)
        if h_ret == <_c_api.DotGateWithNeighborsHandle>0:
            return None
        return dot_gate_with_neighbors._dot_gate_with_neighbors_from_capi(h_ret)

    def lineararray(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_lineararray(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def screening_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_screening_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def raw_central_gates(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_raw_central_gates(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def central_dot_gates(self, ):
        cdef _c_api.DotGatesWithNeighborsHandle h_ret = _c_api.GateGeometryArray1D_central_dot_gates(self.handle)
        if h_ret == <_c_api.DotGatesWithNeighborsHandle>0:
            return None
        return dot_gates_with_neighbors._dot_gates_with_neighbors_from_capi(h_ret)

    def ohmics(self, ):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateGeometryArray1D_ohmics(self.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def equal(self, GateGeometryArray1D other):
        return _c_api.GateGeometryArray1D_equal(self.handle, other.handle)

    def __eq__(self, GateGeometryArray1D other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, GateGeometryArray1D other):
        return _c_api.GateGeometryArray1D_not_equal(self.handle, other.handle)

    def __ne__(self, GateGeometryArray1D other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)
