cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi
from .instrument_port cimport InstrumentPort, _instrument_port_from_capi
from .symbol_unit cimport SymbolUnit, _symbol_unit_from_capi

cdef class AcquisitionContext:
    def __cinit__(self):
        self.handle = <_c_api.AcquisitionContextHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AcquisitionContextHandle>0 and self.owned:
            _c_api.AcquisitionContext_destroy(self.handle)
        self.handle = <_c_api.AcquisitionContextHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.AcquisitionContextHandle h
        try:
            h = _c_api.AcquisitionContext_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.AcquisitionContextHandle>0:
            raise MemoryError("Failed to create AcquisitionContext")
        cdef AcquisitionContext obj = <AcquisitionContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, Connection connection, str instrument_type, SymbolUnit units):
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef _c_api.StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef _c_api.AcquisitionContextHandle h
        try:
            h = _c_api.AcquisitionContext_create(connection.handle if connection is not None else <_c_api.ConnectionHandle>0, s_instrument_type, units.handle if units is not None else <_c_api.SymbolUnitHandle>0)
        finally:
            _c_api.String_destroy(s_instrument_type)
        if h == <_c_api.AcquisitionContextHandle>0:
            raise MemoryError("Failed to create AcquisitionContext")
        cdef AcquisitionContext obj = <AcquisitionContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_port(cls, InstrumentPort port):
        cdef _c_api.AcquisitionContextHandle h
        h = _c_api.AcquisitionContext_create_from_port(port.handle if port is not None else <_c_api.InstrumentPortHandle>0)
        if h == <_c_api.AcquisitionContextHandle>0:
            raise MemoryError("Failed to create AcquisitionContext")
        cdef AcquisitionContext obj = <AcquisitionContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.AcquisitionContextHandle h_ret = _c_api.AcquisitionContext_copy(self.handle)
        if h_ret == <_c_api.AcquisitionContextHandle>0:
            return None
        return _acquisition_context_from_capi(h_ret, owned=(h_ret != <_c_api.AcquisitionContextHandle>self.handle))

    def equal(self, AcquisitionContext other):
        return _c_api.AcquisitionContext_equal(self.handle, other.handle if other is not None else <_c_api.AcquisitionContextHandle>0)

    def __eq__(self, AcquisitionContext other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, AcquisitionContext other):
        return _c_api.AcquisitionContext_not_equal(self.handle, other.handle if other is not None else <_c_api.AcquisitionContextHandle>0)

    def __ne__(self, AcquisitionContext other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.AcquisitionContext_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def connection(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.AcquisitionContext_connection(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def instrument_type(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.AcquisitionContext_instrument_type(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def units(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.AcquisitionContext_units(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return _symbol_unit_from_capi(h_ret, owned=True)

    def division_unit(self, SymbolUnit other):
        cdef _c_api.AcquisitionContextHandle h_ret = _c_api.AcquisitionContext_division_unit(self.handle, other.handle if other is not None else <_c_api.SymbolUnitHandle>0)
        if h_ret == <_c_api.AcquisitionContextHandle>0:
            return None
        return _acquisition_context_from_capi(h_ret, owned=(h_ret != <_c_api.AcquisitionContextHandle>self.handle))

    def division(self, AcquisitionContext other):
        cdef _c_api.AcquisitionContextHandle h_ret = _c_api.AcquisitionContext_division(self.handle, other.handle if other is not None else <_c_api.AcquisitionContextHandle>0)
        if h_ret == <_c_api.AcquisitionContextHandle>0:
            return None
        return _acquisition_context_from_capi(h_ret, owned=(h_ret != <_c_api.AcquisitionContextHandle>self.handle))

    def __truediv__(self, AcquisitionContext other):
        return self.division(other)

    def match_connection(self, Connection other):
        return _c_api.AcquisitionContext_match_connection(self.handle, other.handle if other is not None else <_c_api.ConnectionHandle>0)

    def match_instrument_type(self, str other):
        cdef bytes b_other = other.encode("utf-8")
        cdef _c_api.StringHandle s_other = _c_api.String_create(b_other, len(b_other))
        cdef bint ret_val
        try:
            ret_val = _c_api.AcquisitionContext_match_instrument_type(self.handle, s_other)
        finally:
            _c_api.String_destroy(s_other)
        return ret_val

cdef AcquisitionContext _acquisition_context_from_capi(_c_api.AcquisitionContextHandle h, bint owned=True):
    if h == <_c_api.AcquisitionContextHandle>0:
        return None
    cdef AcquisitionContext obj = AcquisitionContext.__new__(AcquisitionContext)
    obj.handle = h
    obj.owned = owned
    return obj
