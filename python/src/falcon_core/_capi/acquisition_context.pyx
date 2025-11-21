# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .instrument_port cimport InstrumentPort
from .symbol_unit cimport SymbolUnit

cdef class AcquisitionContext:
    cdef c_api.AcquisitionContextHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.AcquisitionContextHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.AcquisitionContextHandle>0 and self.owned:
            c_api.AcquisitionContext_destroy(self.handle)
        self.handle = <c_api.AcquisitionContextHandle>0

    cdef AcquisitionContext from_capi(cls, c_api.AcquisitionContextHandle h):
        cdef AcquisitionContext obj = <AcquisitionContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, connection, instrument_type, units):
        instrument_type_bytes = instrument_type.encode("utf-8")
        cdef const char* raw_instrument_type = instrument_type_bytes
        cdef size_t len_instrument_type = len(instrument_type_bytes)
        cdef c_api.StringHandle s_instrument_type = c_api.String_create(raw_instrument_type, len_instrument_type)
        cdef c_api.AcquisitionContextHandle h
        try:
            h = c_api.AcquisitionContext_create(<c_api.ConnectionHandle>connection.handle, s_instrument_type, <c_api.SymbolUnitHandle>units.handle)
        finally:
            c_api.String_destroy(s_instrument_type)
        if h == <c_api.AcquisitionContextHandle>0:
            raise MemoryError("Failed to create AcquisitionContext")
        cdef AcquisitionContext obj = <AcquisitionContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_port(cls, port):
        cdef c_api.AcquisitionContextHandle h
        h = c_api.AcquisitionContext_create_from_port(<c_api.InstrumentPortHandle>port.handle)
        if h == <c_api.AcquisitionContextHandle>0:
            raise MemoryError("Failed to create AcquisitionContext")
        cdef AcquisitionContext obj = <AcquisitionContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.AcquisitionContextHandle h
        try:
            h = c_api.AcquisitionContext_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.AcquisitionContextHandle>0:
            raise MemoryError("Failed to create AcquisitionContext")
        cdef AcquisitionContext obj = <AcquisitionContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def connection(self):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.AcquisitionContext_connection(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def instrument_type(self):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.AcquisitionContext_instrument_type(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def units(self):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.SymbolUnitHandle h_ret
        h_ret = c_api.AcquisitionContext_units(self.handle)
        if h_ret == <c_api.SymbolUnitHandle>0:
            return None
        return SymbolUnit.from_capi(SymbolUnit, h_ret)

    def division_unit(self, other):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AcquisitionContextHandle h_ret
        h_ret = c_api.AcquisitionContext_division_unit(self.handle, <c_api.SymbolUnitHandle>other.handle)
        if h_ret == <c_api.AcquisitionContextHandle>0:
            return None
        return AcquisitionContext.from_capi(AcquisitionContext, h_ret)

    def division(self, other):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.AcquisitionContextHandle h_ret
        h_ret = c_api.AcquisitionContext_division(self.handle, <c_api.AcquisitionContextHandle>other.handle)
        if h_ret == <c_api.AcquisitionContextHandle>0:
            return None
        return AcquisitionContext.from_capi(AcquisitionContext, h_ret)

    def __truediv__(self, other):
        return self.division(other)

    def match_connection(self, other):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AcquisitionContext_match_connection(self.handle, <c_api.ConnectionHandle>other.handle)

    def match_instrument_type(self, other):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        other_bytes = other.encode("utf-8")
        cdef const char* raw_other = other_bytes
        cdef size_t len_other = len(other_bytes)
        cdef c_api.StringHandle s_other = c_api.String_create(raw_other, len_other)
        cdef bool ret_val
        try:
            ret_val = c_api.AcquisitionContext_match_instrument_type(self.handle, s_other)
        finally:
            c_api.String_destroy(s_other)
        return ret_val

    def equal(self, b):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AcquisitionContext_equal(self.handle, <c_api.AcquisitionContextHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.AcquisitionContext_not_equal(self.handle, <c_api.AcquisitionContextHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.AcquisitionContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.AcquisitionContext_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef AcquisitionContext _acquisitioncontext_from_capi(c_api.AcquisitionContextHandle h):
    cdef AcquisitionContext obj = <AcquisitionContext>AcquisitionContext.__new__(AcquisitionContext)
    obj.handle = h