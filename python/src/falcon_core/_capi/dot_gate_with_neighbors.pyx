# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection

cdef class DotGateWithNeighbors:
    cdef c_api.DotGateWithNeighborsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.DotGateWithNeighborsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.DotGateWithNeighborsHandle>0 and self.owned:
            c_api.DotGateWithNeighbors_destroy(self.handle)
        self.handle = <c_api.DotGateWithNeighborsHandle>0

    cdef DotGateWithNeighbors from_capi(cls, c_api.DotGateWithNeighborsHandle h):
        cdef DotGateWithNeighbors obj = <DotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_plungergatewithneighbors(cls, name, left_neighbor, right_neighbor):
        name_bytes = name.encode("utf-8")
        cdef const char* raw_name = name_bytes
        cdef size_t len_name = len(name_bytes)
        cdef c_api.StringHandle s_name = c_api.String_create(raw_name, len_name)
        cdef c_api.DotGateWithNeighborsHandle h
        try:
            h = c_api.DotGateWithNeighbors_create_plungergatewithneighbors(s_name, <c_api.ConnectionHandle>left_neighbor.handle, <c_api.ConnectionHandle>right_neighbor.handle)
        finally:
            c_api.String_destroy(s_name)
        if h == <c_api.DotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGateWithNeighbors")
        cdef DotGateWithNeighbors obj = <DotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_barriergatewithneighbors(cls, name, left_neighbor, right_neighbor):
        name_bytes = name.encode("utf-8")
        cdef const char* raw_name = name_bytes
        cdef size_t len_name = len(name_bytes)
        cdef c_api.StringHandle s_name = c_api.String_create(raw_name, len_name)
        cdef c_api.DotGateWithNeighborsHandle h
        try:
            h = c_api.DotGateWithNeighbors_create_barriergatewithneighbors(s_name, <c_api.ConnectionHandle>left_neighbor.handle, <c_api.ConnectionHandle>right_neighbor.handle)
        finally:
            c_api.String_destroy(s_name)
        if h == <c_api.DotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGateWithNeighbors")
        cdef DotGateWithNeighbors obj = <DotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.DotGateWithNeighborsHandle h
        try:
            h = c_api.DotGateWithNeighbors_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.DotGateWithNeighborsHandle>0:
            raise MemoryError("Failed to create DotGateWithNeighbors")
        cdef DotGateWithNeighbors obj = <DotGateWithNeighbors>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def equal(self, other):
        if self.handle == <c_api.DotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGateWithNeighbors_equal(self.handle, <c_api.DotGateWithNeighborsHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.DotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGateWithNeighbors_not_equal(self.handle, <c_api.DotGateWithNeighborsHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def name(self):
        if self.handle == <c_api.DotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.DotGateWithNeighbors_name(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def type(self):
        if self.handle == <c_api.DotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.DotGateWithNeighbors_type(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def left_neighbor(self):
        if self.handle == <c_api.DotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.DotGateWithNeighbors_left_neighbor(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def right_neighbor(self):
        if self.handle == <c_api.DotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.DotGateWithNeighbors_right_neighbor(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def is_barrier_gate(self):
        if self.handle == <c_api.DotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGateWithNeighbors_is_barrier_gate(self.handle)

    def is_plunger_gate(self):
        if self.handle == <c_api.DotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.DotGateWithNeighbors_is_plunger_gate(self.handle)

    def to_json_string(self):
        if self.handle == <c_api.DotGateWithNeighborsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.DotGateWithNeighbors_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef DotGateWithNeighbors _dotgatewithneighbors_from_capi(c_api.DotGateWithNeighborsHandle h):
    cdef DotGateWithNeighbors obj = <DotGateWithNeighbors>DotGateWithNeighbors.__new__(DotGateWithNeighbors)
    obj.handle = h