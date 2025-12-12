cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport instrument_port
from . cimport symbol_unit

cdef class AcquisitionContext:
    def __cinit__(self):
        self.handle = <_c_api.AcquisitionContextHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.AcquisitionContextHandle>0 and self.owned:
            _c_api.AcquisitionContext_destroy(self.handle)
        self.handle = <_c_api.AcquisitionContextHandle>0


cdef AcquisitionContext _acquisition_context_from_capi(_c_api.AcquisitionContextHandle h):
    if h == <_c_api.AcquisitionContextHandle>0:
        return None
    cdef AcquisitionContext obj = AcquisitionContext.__new__(AcquisitionContext)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, Connection connection, str instrument_type, SymbolUnit units):
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef _c_api.AcquisitionContextHandle h
        try:
            h = _c_api.AcquisitionContext_create(connection.handle, s_instrument_type, units.handle)
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
        h = _c_api.AcquisitionContext_create_from_port(port.handle)
        if h == <_c_api.AcquisitionContextHandle>0:
            raise MemoryError("Failed to create AcquisitionContext")
        cdef AcquisitionContext obj = <AcquisitionContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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

    def connection(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.AcquisitionContext_connection(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def instrument_type(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.AcquisitionContext_instrument_type(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def units(self, ):
        cdef _c_api.SymbolUnitHandle h_ret = _c_api.AcquisitionContext_units(self.handle)
        if h_ret == <_c_api.SymbolUnitHandle>0:
            return None
        return symbol_unit._symbol_unit_from_capi(h_ret)

    def division_unit(self, SymbolUnit other):
        cdef _c_api.AcquisitionContextHandle h_ret = _c_api.AcquisitionContext_division_unit(self.handle, other.handle)
        if h_ret == <_c_api.AcquisitionContextHandle>0:
            return None
        return _acquisition_context_from_capi(h_ret)

    def division(self, AcquisitionContext other):
        cdef _c_api.AcquisitionContextHandle h_ret = _c_api.AcquisitionContext_division(self.handle, other.handle)
        if h_ret == <_c_api.AcquisitionContextHandle>0:
            return None
        return _acquisition_context_from_capi(h_ret)

    def __truediv__(self, AcquisitionContext other):
        return self.division(other)

    def match_connection(self, Connection other):
        return _c_api.AcquisitionContext_match_connection(self.handle, other.handle)

    def match_instrument_type(self, str other):
        cdef bytes b_other = other.encode("utf-8")
        cdef StringHandle s_other = _c_api.String_create(b_other, len(b_other))
        cdef bool ret_val
        try:
            ret_val = _c_api.AcquisitionContext_match_instrument_type(self.handle, s_other)
        finally:
            _c_api.String_destroy(s_other)
        return ret_val

    def equal(self, AcquisitionContext b):
        return _c_api.AcquisitionContext_equal(self.handle, b.handle)

    def __eq__(self, AcquisitionContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, AcquisitionContext b):
        return _c_api.AcquisitionContext_not_equal(self.handle, b.handle)

    def __ne__(self, AcquisitionContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
