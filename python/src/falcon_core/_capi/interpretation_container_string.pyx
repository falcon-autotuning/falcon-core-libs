cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .connections cimport Connections, _connections_from_capi
from .interpretation_context cimport InterpretationContext, _interpretation_context_from_capi
from .list_connection cimport ListConnection, _list_connection_from_capi
from .list_interpretation_context cimport ListInterpretationContext, _list_interpretation_context_from_capi
from .list_pair_interpretation_context_string cimport ListPairInterpretationContextString, _list_pair_interpretation_context_string_from_capi
from .list_string cimport ListString, _list_string_from_capi
from .map_interpretation_context_string cimport MapInterpretationContextString, _map_interpretation_context_string_from_capi
from .symbol_unit cimport SymbolUnit, _symbol_unit_from_capi

cdef class InterpretationContainerString:
    def __cinit__(self):
        self.handle = <_c_api.InterpretationContainerStringHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.InterpretationContainerStringHandle>0 and self.owned:
            _c_api.InterpretationContainerString_destroy(self.handle)
        self.handle = <_c_api.InterpretationContainerStringHandle>0


    @classmethod
    def new(cls, MapInterpretationContextString contextDoubleMap):
        cdef _c_api.InterpretationContainerStringHandle h
        h = _c_api.InterpretationContainerString_create(contextDoubleMap.handle if contextDoubleMap is not None else <_c_api.MapInterpretationContextStringHandle>0)
        if h == <_c_api.InterpretationContainerStringHandle>0:
            raise MemoryError("Failed to create InterpretationContainerString")
        cdef InterpretationContainerString obj = <InterpretationContainerString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.InterpretationContainerStringHandle h
        try:
            h = _c_api.InterpretationContainerString_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.InterpretationContainerStringHandle>0:
            raise MemoryError("Failed to create InterpretationContainerString")
        cdef InterpretationContainerString obj = <InterpretationContainerString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.InterpretationContainerStringHandle h_ret = _c_api.InterpretationContainerString_copy(self.handle)
        if h_ret == <_c_api.InterpretationContainerStringHandle>0:
            return None
        return _interpretation_container_string_from_capi(h_ret)

    def unit(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.InterpretationContainerString_unit(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret)

    def select_by_connection(self, Connection connection):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerString_select_by_connection(self.handle, connection.handle if connection is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return _list_interpretation_context_from_capi(h_ret)

    def select_by_connections(self, Connections connections):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerString_select_by_connections(self.handle, connections.handle if connections is not None else <_c_api.ConnectionsHandle>0)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return _list_interpretation_context_from_capi(h_ret)

    def select_by_independent_connection(self, Connection connection):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerString_select_by_independent_connection(self.handle, connection.handle if connection is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return _list_interpretation_context_from_capi(h_ret)

    def select_by_dependent_connection(self, Connection connection):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerString_select_by_dependent_connection(self.handle, connection.handle if connection is not None else <_c_api.ConnectionHandle>0)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return _list_interpretation_context_from_capi(h_ret)

    def select_contexts(self, ListConnection independent_connections, ListConnection dependent_connections):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerString_select_contexts(self.handle, independent_connections.handle if independent_connections is not None else <_c_api.ListConnectionHandle>0, dependent_connections.handle if dependent_connections is not None else <_c_api.ListConnectionHandle>0)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return _list_interpretation_context_from_capi(h_ret)

    def insert_or_assign(self, InterpretationContext key, str value):
        cdef bytes b_value = value.encode("utf-8")
        cdef _c_api.StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        _c_api.InterpretationContainerString_insert_or_assign(self.handle, key.handle if key is not None else <_c_api.InterpretationContextHandle>0, s_value)
        _c_api.String_destroy(s_value)

    def insert(self, InterpretationContext key, str value):
        cdef bytes b_value = value.encode("utf-8")
        cdef _c_api.StringHandle s_value = _c_api.String_create(b_value, len(b_value))
        _c_api.InterpretationContainerString_insert(self.handle, key.handle if key is not None else <_c_api.InterpretationContextHandle>0, s_value)
        _c_api.String_destroy(s_value)

    def at(self, InterpretationContext key):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.InterpretationContainerString_at(self.handle, key.handle if key is not None else <_c_api.InterpretationContextHandle>0)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def erase(self, InterpretationContext key):
        _c_api.InterpretationContainerString_erase(self.handle, key.handle if key is not None else <_c_api.InterpretationContextHandle>0)

    def size(self, ):
        return _c_api.InterpretationContainerString_size(self.handle)

    def empty(self, ):
        return _c_api.InterpretationContainerString_empty(self.handle)

    def clear(self, ):
        _c_api.InterpretationContainerString_clear(self.handle)

    def contains(self, InterpretationContext key):
        return _c_api.InterpretationContainerString_contains(self.handle, key.handle if key is not None else <_c_api.InterpretationContextHandle>0)

    def keys(self, ):
        cdef _c_api.ListInterpretationContextHandle h_ret = _c_api.InterpretationContainerString_keys(self.handle)
        if h_ret == <_c_api.ListInterpretationContextHandle>0:
            return None
        return _list_interpretation_context_from_capi(h_ret)

    def values(self, ):
        cdef _c_api.ListStringHandle h_ret = _c_api.InterpretationContainerString_values(self.handle)
        if h_ret == <_c_api.ListStringHandle>0:
            return None
        return _list_string_from_capi(h_ret)

    def items(self, ):
        cdef _c_api.ListPairInterpretationContextStringHandle h_ret = _c_api.InterpretationContainerString_items(self.handle)
        if h_ret == <_c_api.ListPairInterpretationContextStringHandle>0:
            return None
        return _list_pair_interpretation_context_string_from_capi(h_ret)

    def equal(self, InterpretationContainerString other):
        return _c_api.InterpretationContainerString_equal(self.handle, other.handle if other is not None else <_c_api.InterpretationContainerStringHandle>0)

    def __eq__(self, InterpretationContainerString other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, InterpretationContainerString other):
        return _c_api.InterpretationContainerString_not_equal(self.handle, other.handle if other is not None else <_c_api.InterpretationContainerStringHandle>0)

    def __ne__(self, InterpretationContainerString other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.InterpretationContainerString_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def __len__(self):
        return self.size()

    def __getitem__(self, idx):
        ret = self.at(idx)
        if ret is None:
            raise IndexError("Index out of bounds")
        return ret

cdef InterpretationContainerString _interpretation_container_string_from_capi(_c_api.InterpretationContainerStringHandle h, bint owned=True):
    if h == <_c_api.InterpretationContainerStringHandle>0:
        return None
    cdef InterpretationContainerString obj = InterpretationContainerString.__new__(InterpretationContainerString)
    obj.handle = h
    obj.owned = owned
    return obj
