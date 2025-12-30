cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .connections cimport Connections, _connections_from_capi
from .list_connection cimport ListConnection, _list_connection_from_capi
from .list_connections cimport ListConnections, _list_connections_from_capi
from .list_pair_connection_connections cimport ListPairConnectionConnections, _list_pair_connection_connections_from_capi

cdef class GateRelations:
    def __cinit__(self):
        self.handle = <_c_api.GateRelationsHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.GateRelationsHandle>0 and self.owned:
            _c_api.GateRelations_destroy(self.handle)
        self.handle = <_c_api.GateRelationsHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    @classmethod
    def new_empty(cls, ):
        cdef _c_api.GateRelationsHandle h
        h = _c_api.GateRelations_create_empty()
        if h == <_c_api.GateRelationsHandle>0:
            raise MemoryError("Failed to create GateRelations")
        cdef GateRelations obj = <GateRelations>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, ListPairConnectionConnections items):
        cdef _c_api.GateRelationsHandle h
        h = _c_api.GateRelations_create(items.handle if items is not None else <_c_api.ListPairConnectionConnectionsHandle>0)
        if h == <_c_api.GateRelationsHandle>0:
            raise MemoryError("Failed to create GateRelations")
        cdef GateRelations obj = <GateRelations>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.GateRelationsHandle h_ret = _c_api.GateRelations_copy(self.handle)
        if h_ret == <_c_api.GateRelationsHandle>0:
            return None
        return _gate_relations_from_capi(h_ret)

    def equal(self, GateRelations other):
        return _c_api.GateRelations_equal(self.handle, other.handle if other is not None else <_c_api.GateRelationsHandle>0)

    def __eq__(self, GateRelations other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, GateRelations other):
        return _c_api.GateRelations_not_equal(self.handle, other.handle if other is not None else <_c_api.GateRelationsHandle>0)

    def __ne__(self, GateRelations other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.GateRelations_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def insert_or_assign(self, Connection key, Connections value):
        _c_api.GateRelations_insert_or_assign(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0, value.handle if value is not None else <_c_api.ConnectionsHandle>0)

    def insert(self, Connection key, Connections value):
        _c_api.GateRelations_insert(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0, value.handle if value is not None else <_c_api.ConnectionsHandle>0)

    def at(self, Connection key):
        cdef _c_api.ConnectionsHandle h_ret = _c_api.GateRelations_at(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.ConnectionsHandle>0:
            return None
        return _connections_from_capi(h_ret, owned=False)

    def erase(self, Connection key):
        _c_api.GateRelations_erase(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)

    def size(self, ):
        return _c_api.GateRelations_size(self.handle)

    def empty(self, ):
        return _c_api.GateRelations_empty(self.handle)

    def clear(self, ):
        _c_api.GateRelations_clear(self.handle)

    def contains(self, Connection key):
        return _c_api.GateRelations_contains(self.handle, key.handle if key is not None else <_c_api.ConnectionHandle>0)

    def keys(self, ):
        cdef _c_api.ListConnectionHandle h_ret = _c_api.GateRelations_keys(self.handle)
        if h_ret == <_c_api.ListConnectionHandle>0:
            return None
        return _list_connection_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListConnectionsHandle h_ret = _c_api.GateRelations_values(self.handle)
        if h_ret == <_c_api.ListConnectionsHandle>0:
            return None
        return _list_connections_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairConnectionConnectionsHandle h_ret = _c_api.GateRelations_items(self.handle)
        if h_ret == <_c_api.ListPairConnectionConnectionsHandle>0:
            return None
        return _list_pair_connection_connections_from_capi(h_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

cdef GateRelations _gate_relations_from_capi(_c_api.GateRelationsHandle h, bint owned=True):
    if h == <_c_api.GateRelationsHandle>0:
        return None
    cdef GateRelations obj = GateRelations.__new__(GateRelations)
    obj.handle = h
    obj.owned = owned
    return obj
