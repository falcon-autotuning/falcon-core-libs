# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .connections cimport Connections
from .interpretation_context cimport InterpretationContext
from .list_connection cimport ListConnection
from .list_double cimport ListDouble
from .list_interpretation_context cimport ListInterpretationContext
from .list_pair_interpretation_context_double cimport ListPairInterpretationContextDouble
from .map_interpretation_context_double cimport MapInterpretationContextDouble
from .symbol_unit cimport SymbolUnit

cdef class InterpretationContainerDouble:
    cdef c_api.InterpretationContainerDoubleHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.InterpretationContainerDoubleHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.InterpretationContainerDoubleHandle>0 and self.owned:
            c_api.InterpretationContainerDouble_destroy(self.handle)
        self.handle = <c_api.InterpretationContainerDoubleHandle>0

    cdef InterpretationContainerDouble from_capi(cls, c_api.InterpretationContainerDoubleHandle h):
        cdef InterpretationContainerDouble obj = <InterpretationContainerDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, map):
        cdef c_api.InterpretationContainerDoubleHandle h
        h = c_api.InterpretationContainerDouble_create(<c_api.MapInterpretationContextDoubleHandle>map.handle)
        if h == <c_api.InterpretationContainerDoubleHandle>0:
            raise MemoryError("Failed to create InterpretationContainerDouble")
        cdef InterpretationContainerDouble obj = <InterpretationContainerDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.InterpretationContainerDoubleHandle h
        try:
            h = c_api.InterpretationContainerDouble_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.InterpretationContainerDoubleHandle>0:
            raise MemoryError("Failed to create InterpretationContainerDouble")
        cdef InterpretationContainerDouble obj = <InterpretationContainerDouble>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def unit(self):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.InterpretationContainerDouble_unit(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def select_by_connection(self, connection):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerDouble_select_by_connection(self.handle, <c_api.ConnectionHandle>connection.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def select_by_connections(self, connections):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerDouble_select_by_connections(self.handle, <c_api.ConnectionsHandle>connections.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def select_by_independent_connection(self, connection):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerDouble_select_by_independent_connection(self.handle, <c_api.ConnectionHandle>connection.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def select_by_dependent_connection(self, connection):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerDouble_select_by_dependent_connection(self.handle, <c_api.ConnectionHandle>connection.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def select_contexts(self, independent_connections, dependent_connections):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerDouble_select_contexts(self.handle, <c_api.ListConnectionHandle>independent_connections.handle, <c_api.ListConnectionHandle>dependent_connections.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def insert_or_assign(self, key, value):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.InterpretationContainerDouble_insert_or_assign(self.handle, <c_api.InterpretationContextHandle>key.handle, value)

    def insert(self, key, value):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.InterpretationContainerDouble_insert(self.handle, <c_api.InterpretationContextHandle>key.handle, value)

    def at(self, key):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerDouble_at(self.handle, <c_api.InterpretationContextHandle>key.handle)

    def erase(self, key):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.InterpretationContainerDouble_erase(self.handle, <c_api.InterpretationContextHandle>key.handle)

    def size(self):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerDouble_size(self.handle)

    def empty(self):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerDouble_empty(self.handle)

    def clear(self):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        c_api.InterpretationContainerDouble_clear(self.handle)

    def contains(self, key):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerDouble_contains(self.handle, <c_api.InterpretationContextHandle>key.handle)

    def keys(self):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListInterpretationContextHandle h_ret
        h_ret = c_api.InterpretationContainerDouble_keys(self.handle)
        if h_ret == <c_api.ListInterpretationContextHandle>0:
            return None
        return ListInterpretationContext.from_capi(ListInterpretationContext, h_ret)

    def values(self):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListDoubleHandle h_ret
        h_ret = c_api.InterpretationContainerDouble_values(self.handle)
        if h_ret == <c_api.ListDoubleHandle>0:
            return None
        return ListDouble.from_capi(ListDouble, h_ret)

    def items(self):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ListPairInterpretationContextDoubleHandle h_ret
        h_ret = c_api.InterpretationContainerDouble_items(self.handle)
        if h_ret == <c_api.ListPairInterpretationContextDoubleHandle>0:
            return None
        return ListPairInterpretationContextDouble.from_capi(ListPairInterpretationContextDouble, h_ret)

    def equal(self, other):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerDouble_equal(self.handle, <c_api.InterpretationContainerDoubleHandle>other.handle)

    def __eq__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, other):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.InterpretationContainerDouble_not_equal(self.handle, <c_api.InterpretationContainerDoubleHandle>other.handle)

    def __ne__(self, other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json_string(self):
        if self.handle == <c_api.InterpretationContainerDoubleHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.InterpretationContainerDouble_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef InterpretationContainerDouble _interpretationcontainerdouble_from_capi(c_api.InterpretationContainerDoubleHandle h):
    cdef InterpretationContainerDouble obj = <InterpretationContainerDouble>InterpretationContainerDouble.__new__(InterpretationContainerDouble)
    obj.handle = h