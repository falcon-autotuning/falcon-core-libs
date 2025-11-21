# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .connections cimport Connections
from .list_connection cimport ListConnection
from .list_connections cimport ListConnections
from .list_pair_connection_connections cimport ListPairConnectionConnections

cdef class GateRelations:
    cdef c_api.GateRelationsHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.GateRelationsHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.GateRelationsHandle>0 and self.owned:
            c_api.GateRelations_destroy(self.handle)
        self.handle = <c_api.GateRelationsHandle>0

    cdef GateRelations from_capi(cls, c_api.GateRelationsHandle h):
        cdef GateRelations obj = <GateRelations>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new_empty(cls, ):
        cdef c_api.GateRelationsHandle h
        h = c_api.GateRelations_create_empty()
        if h == <c_api.GateRelationsHandle>0:
            raise MemoryError("Failed to create GateRelations")
        cdef GateRelations obj = <GateRelations>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, items):
        cdef c_api.GateRelationsHandle h
        h = c_api.GateRelations_create(<c_api.ListPairConnectionConnectionsHandle>items.handle)
        if h == <c_api.GateRelationsHandle>0:
            raise MemoryError("Failed to create GateRelations")
        cdef GateRelations obj = <GateRelations>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.GateRelationsHandle h
        try:
            h = c_api.GateRelations_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.GateRelationsHandle>0:
            raise MemoryError("Failed to create GateRelations")
        cdef GateRelations obj = <GateRelations>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.GateRelations_insert_or_assign(self.handle, <c_api.ConnectionHandle>key.handle, <c_api.ConnectionsHandle>value.handle)

    def insert(self, key, value):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.GateRelations_insert(self.handle, <c_api.ConnectionHandle>key.handle, <c_api.ConnectionsHandle>value.handle)

    def at(self, key):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionsHandle h_ret
        h_ret = c_api.GateRelations_at(self.handle, <c_api.ConnectionHandle>key.handle)
        if h_ret == <c_api.ConnectionsHandle>0:
            return None
        return Connections.from_capi(Connections, h_ret)

    def erase(self, key):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.GateRelations_erase(self.handle, <c_api.ConnectionHandle>key.handle)

    def size(self):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.GateRelations_size(self.handle)

    def empty(self):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.GateRelations_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        c_api.GateRelations_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.GateRelations_contains(self.handle, <c_api.ConnectionHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionHandle h_ret
        h_ret = c_api.GateRelations_keys(self.handle)
        if h_ret == <c_api.ListConnectionHandle>0:
            return None
        return ListConnection.from_capi(ListConnection, h_ret)

    def values(self):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListConnectionsHandle h_ret
        h_ret = c_api.GateRelations_values(self.handle)
        if h_ret == <c_api.ListConnectionsHandle>0:
            return None
        return ListConnections.from_capi(ListConnections, h_ret)

    def items(self):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairConnectionConnectionsHandle h_ret
        h_ret = c_api.GateRelations_items(self.handle)
        if h_ret == <c_api.ListPairConnectionConnectionsHandle>0:
            return None
        return ListPairConnectionConnections.from_capi(ListPairConnectionConnections, h_ret)

    def equal(self, b):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.GateRelations_equal(self.handle, <c_api.GateRelationsHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.GateRelations_not_equal(self.handle, <c_api.GateRelationsHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.GateRelationsHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.GateRelations_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef GateRelations _gaterelations_from_capi(c_api.GateRelationsHandle h):
    cdef GateRelations obj = <GateRelations>GateRelations.__new__(GateRelations)
    obj.handle = h