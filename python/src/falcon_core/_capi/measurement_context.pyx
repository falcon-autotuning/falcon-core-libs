cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection
from . cimport instrument_port

cdef class MeasurementContext:
    def __cinit__(self):
        self.handle = <_c_api.MeasurementContextHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.MeasurementContextHandle>0 and self.owned:
            _c_api.MeasurementContext_destroy(self.handle)
        self.handle = <_c_api.MeasurementContextHandle>0


cdef MeasurementContext _measurement_context_from_capi(_c_api.MeasurementContextHandle h):
    if h == <_c_api.MeasurementContextHandle>0:
        return None
    cdef MeasurementContext obj = MeasurementContext.__new__(MeasurementContext)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def new(cls, Connection connection, str instrument_type):
        cdef bytes b_instrument_type = instrument_type.encode("utf-8")
        cdef StringHandle s_instrument_type = _c_api.String_create(b_instrument_type, len(b_instrument_type))
        cdef _c_api.MeasurementContextHandle h
        try:
            h = _c_api.MeasurementContext_create(connection.handle, s_instrument_type)
        finally:
            _c_api.String_destroy(s_instrument_type)
        if h == <_c_api.MeasurementContextHandle>0:
            raise MemoryError("Failed to create MeasurementContext")
        cdef MeasurementContext obj = <MeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_port(cls, InstrumentPort port):
        cdef _c_api.MeasurementContextHandle h
        h = _c_api.MeasurementContext_create_from_port(port.handle)
        if h == <_c_api.MeasurementContextHandle>0:
            raise MemoryError("Failed to create MeasurementContext")
        cdef MeasurementContext obj = <MeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.MeasurementContextHandle h
        try:
            h = _c_api.MeasurementContext_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.MeasurementContextHandle>0:
            raise MemoryError("Failed to create MeasurementContext")
        cdef MeasurementContext obj = <MeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def connection(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.MeasurementContext_connection(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def instrument_type(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.MeasurementContext_instrument_type(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def equal(self, MeasurementContext b):
        return _c_api.MeasurementContext_equal(self.handle, b.handle)

    def __eq__(self, MeasurementContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, MeasurementContext b):
        return _c_api.MeasurementContext_not_equal(self.handle, b.handle)

    def __ne__(self, MeasurementContext b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
