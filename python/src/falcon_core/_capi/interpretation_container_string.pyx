# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .connections cimport Connections
from .interpretation_context cimport InterpretationContext
from .list_connection cimport ListConnection
from .list_interpretation_context cimport ListInterpretationContext
from .list_pair_interpretation_context_string cimport ListPairInterpretationContextString
from .list_string cimport ListString
from .map_interpretation_context_string cimport MapInterpretationContextString
from .symbol_unit cimport SymbolUnit

cdef class InterpretationContainerString:
    cdef c_api.InterpretationContainerStringHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.InterpretationContainerStringHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.InterpretationContainerStringHandle>0 and self.owned:
            c_api.InterpretationContainerString_destroy(self.handle)
        self.handle = <c_api.InterpretationContainerStringHandle>0

    cdef InterpretationContainerString from_capi(cls, c_api.InterpretationContainerStringHandle h):
        cdef InterpretationContainerString obj = <InterpretationContainerString>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, map):
        cdef c_api.InterpretationContainerStringHandle h
        h = c_api.InterpretationContainerString_create(<c_api.MapInterpretationContextStringHandle>map.handle)
        if h == <c_api.InterpretationContainerStringHandle>0:
            raise MemoryError("Failed to create InterpretationContainerString")
        cdef InterpretationContainerString obj = <InterpretationContainerString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.InterpretationContainerStringHandle h
        try:
            h = c_api.InterpretationContainerString_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.InterpretationContainerStringHandle>0:
            raise MemoryError("Failed to create InterpretationContainerString")
        cdef InterpretationContainerString obj = <InterpretationContainerString>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def unit(self):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.InterpretationContainerString_unit(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def select_by_connection(self, connection):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerString_select_by_connection(self.handle, <c_api.ConnectionHandle>connection.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def select_by_connections(self, connections):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerString_select_by_connections(self.handle, <c_api.ConnectionsHandle>connections.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def select_by_independent_connection(self, connection):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerString_select_by_independent_connection(self.handle, <c_api.ConnectionHandle>connection.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def select_by_dependent_connection(self, connection):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerString_select_by_dependent_connection(self.handle, <c_api.ConnectionHandle>connection.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def select_contexts(self, independent_connections, dependent_connections):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerString_select_contexts(self.handle, <c_api.ListConnectionHandle>independent_connections.handle, <c_api.ListConnectionHandle>dependent_connections.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        try:
            c_api.InterpretationContainerString_insert_or_assign(self.handle, <c_api.InterpretationContextHandle>key.handle, s_value)
        finally:
            c_api.String_destroy(s_value)

    def insert(self, key, value):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        value_bytes = value.encode("utf-8")
        cdef const char* raw_value = value_bytes
        cdef size_t len_value = len(value_bytes)
        cdef c_api.StringHandle s_value = c_api.String_create(raw_value, len_value)
        try:
            c_api.InterpretationContainerString_insert(self.handle, <c_api.InterpretationContextHandle>key.handle, s_value)
        finally:
            c_api.String_destroy(s_value)

    def at(self, key):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.InterpretationContainerString_at(self.handle, <c_api.InterpretationContextHandle>key.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def erase(self, key):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.InterpretationContainerString_erase(self.handle, <c_api.InterpretationContextHandle>key.handle)

    def size(self):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerString_size(self.handle)

    def empty(self):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerString_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        c_api.InterpretationContainerString_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerString_contains(self.handle, <c_api.InterpretationContextHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerString_keys(self.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def values(self):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListStringHandle h_ret
        h_ret = c_api.InterpretationContainerString_values(self.handle)
        if h_ret == <c_api.ListStringHandle>0:
            return None
        return ListString.from_capi(ListString, h_ret)

    def items(self):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairInterpretationContextStringHandle h_ret
        h_ret = c_api.InterpretationContainerString_items(self.handle)
        if h_ret == <c_api.ListPairInterpretationContextStringHandle>0:
            return None
        return ListPairInterpretationContextString.from_capi(ListPairInterpretationContextString, h_ret)

    def equal(self, other):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerString_equal(self.handle, <c_api.InterpretationContainerStringHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerString_not_equal(self.handle, <c_api.InterpretationContainerStringHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.InterpretationContainerStringHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.InterpretationContainerString_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef InterpretationContainerString _interpretationcontainerstring_from_capi(c_api.InterpretationContainerStringHandle h):
    cdef InterpretationContainerString obj = <InterpretationContainerString>InterpretationContainerString.__new__(InterpretationContainerString)
    obj.handle = h