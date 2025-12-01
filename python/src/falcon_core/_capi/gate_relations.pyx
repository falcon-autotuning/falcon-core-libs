cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport connections
from . cimport list_connection
from . cimport list_connections
from . cimport list_pair_connection_connections

cdef class GateRelations:
    def __cinit__(self):
        self.handle = <_c_api.GateRelationsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.GateRelationsHandle>0 and self.owned:
            _c_api.GateRelations_destroy(self.handle)
        self.handle = <_c_api.GateRelationsHandle>0


cdef GateRelations _gate_relations_from_capi(_c_api.GateRelationsHandle h):
    if h == <_c_api.GateRelationsHandle>0:
        return None
    cdef GateRelations obj = GateRelations.__new__(GateRelations)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def empty(cls, ):
        cdef _c_api.GateRelationsHandle h
        h = _c_api.GateRelations_create_empty()
        if h == <_c_api.GateRelationsHandle>0:
            raise MemoryError("Failed to create GateRelations")
        cdef GateRelations obj = <GateRelations>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def create(cls, ListPairConnectionConnections items):
        cdef _c_api.GateRelationsHandle h
        h = _c_api.GateRelations_create(items.handle)
        if h == <_c_api.GateRelationsHandle>0:
            raise MemoryError("Failed to create GateRelations")
        cdef GateRelations obj = <GateRelations>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.GateRelationsHandle h
        try:
            h = _c_api.GateRelations_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.GateRelationsHandle>0:
            raise MemoryError("Failed to create GateRelations")
        cdef GateRelations obj = <GateRelations>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def insert_or_assign(self, Connection key, Connections value):
        _c_api.GateRelations_insert_or_assign(self.handle, key.handle, value.handle)

    def insert(self, Connection key, Connections value):
        _c_api.GateRelations_insert(self.handle, key.handle, value.handle)

    def at(self, Connection key):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateRelations_at(self.handle, key.handle)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return connections._connections_from_capi(h_ret)

    def erase(self, Connection key):
        _c_api.GateRelations_erase(self.handle, key.handle)

    def size(self, ):
        return _c_api.GateRelations_size(self.handle)

    def empty(self, ):
        return _c_api.GateRelations_empty(self.handle)

    def clear(self, ):
        _c_api.GateRelations_clear(self.handle)

    def contains(self, Connection key):
        return _c_api.GateRelations_contains(self.handle, key.handle)

    def keys(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.GateRelations_keys(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return list_connection._list_connection_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListConnectionsHandle h_ret = _c_api.GateRelations_values(self.handle)
        if h_ret == <_c_api.ListConnectionsHandle>0:
            return None
        return list_connections._list_connections_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairConnectionConnectionsHandle h_ret = _c_api.GateRelations_items(self.handle)
        if h_ret == <_c_api.ListPairConnectionConnectionsHandle>0:
            return None
        return list_pair_connection_connections._list_pair_connection_connections_from_capi(h_ret)

    def equal(self, GateRelations b):
        return _c_api.GateRelations_equal(self.handle, b.handle)

    def __eq__(self, GateRelations b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, GateRelations b):
        return _c_api.GateRelations_not_equal(self.handle, b.handle)

    def __ne__(self, GateRelations b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
