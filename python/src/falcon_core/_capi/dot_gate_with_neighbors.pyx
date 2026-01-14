cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi

cdef class DotGateWithNeighbors:
    def __cinit__(self):
        self.handle = <_c_api.DotGateWithNeighborsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.DotGateWithNeighborsHandle>0 and self.owned:
            _c_api.DotGateWithNeighbors_destroy(self.handle)
        self.handle = <_c_api.DotGateWithNeighborsHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.DotGateWithNeighborsHandle h
        try:
            h = _c_api.DotGateWithNeighbors_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.DotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGateWithNeighbors")
        cdef DotGateWithNeighbors obj = <DotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_plunger_gate_with_neighbors(cls, str name, Connection left_neighbor, Connection right_neighbor):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.DotGateWithNeighborsHandle h
        try:
            h = _c_api.DotGateWithNeighbors_create_plunger_gate_with_neighbors(s_name, left_neighbor.handle if left_neighbor is not None else <_c_api.ConnectionHandle>0, right_neighbor.handle if right_neighbor is not None else <_c_api.ConnectionHandle>0)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.DotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGateWithNeighbors")
        cdef DotGateWithNeighbors obj = <DotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_barrier_gate_with_neighbors(cls, str name, Connection left_neighbor, Connection right_neighbor):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.DotGateWithNeighborsHandle h
        try:
            h = _c_api.DotGateWithNeighbors_create_barrier_gate_with_neighbors(s_name, left_neighbor.handle if left_neighbor is not None else <_c_api.ConnectionHandle>0, right_neighbor.handle if right_neighbor is not None else <_c_api.ConnectionHandle>0)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.DotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGateWithNeighbors")
        cdef DotGateWithNeighbors obj = <DotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self):
        cdef _c_api.DotGateWithNeighborsHandle h_ret = _c_api.DotGateWithNeighbors_copy(self.handle)
        if h_ret == <_c_api.DotGateWithNeighborsHandle>0: return None
        return _dot_gate_with_neighbors_from_capi(h_ret, owned=(h_ret != <_c_api.DotGateWithNeighborsHandle>self.handle))

    def equal(self, DotGateWithNeighbors other):
        return _c_api.DotGateWithNeighbors_equal(self.handle, other.handle if other is not None else <_c_api.DotGateWithNeighborsHandle>0)

    def __eq__(self, DotGateWithNeighbors other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.equal(other)

    def not_equal(self, DotGateWithNeighbors other):
        return _c_api.DotGateWithNeighbors_not_equal(self.handle, other.handle if other is not None else <_c_api.DotGateWithNeighborsHandle>0)

    def __ne__(self, DotGateWithNeighbors other):
        if not hasattr(other, "handle"): return NotImplemented
        return self.not_equal(other)

    def to_json(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.DotGateWithNeighbors_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def name(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.DotGateWithNeighbors_name(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def type(self):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.DotGateWithNeighbors_type(self.handle)
        if s_ret == <_c_api.StringHandle>0: return ""
        try: return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally: _c_api.String_destroy(s_ret)

    def left_neighbor(self):
        cdef _c_api.ConnectionHandle h_ret = _c_api.DotGateWithNeighbors_left_neighbor(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0: return None
        return _connection_from_capi(h_ret, owned=True)

    def right_neighbor(self):
        cdef _c_api.ConnectionHandle h_ret = _c_api.DotGateWithNeighbors_right_neighbor(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0: return None
        return _connection_from_capi(h_ret, owned=True)

    def is_barrier_gate(self):
        return _c_api.DotGateWithNeighbors_is_barrier_gate(self.handle)

    def is_plunger_gate(self):
        return _c_api.DotGateWithNeighbors_is_plunger_gate(self.handle)

    def __repr__(self):
        return f"{self.__class__.__name__}({self.to_json()})"

    def __str__(self):
        return self.to_json()

cdef DotGateWithNeighbors _dot_gate_with_neighbors_from_capi(_c_api.DotGateWithNeighborsHandle h, bint owned=True):
    if h == <_c_api.DotGateWithNeighborsHandle>0:
        return None
    cdef DotGateWithNeighbors obj = DotGateWithNeighbors.__new__(DotGateWithNeighbors)
    obj.handle = h
    obj.owned = owned
    return obj
