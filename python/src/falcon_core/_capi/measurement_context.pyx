# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection
from .instrument_port cimport InstrumentPort

cdef class MeasurementContext:
    cdef c_api.MeasurementContextHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.MeasurementContextHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.MeasurementContextHandle>0 and self.owned:
            c_api.MeasurementContext_destroy(self.handle)
        self.handle = <c_api.MeasurementContextHandle>0

    cdef MeasurementContext from_capi(cls, c_api.MeasurementContextHandle h):
        cdef MeasurementContext obj = <MeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, connection, instrument_type):
        instrument_type_bytes = instrument_type.encode("utf-8")
        cdef const char* raw_instrument_type = instrument_type_bytes
        cdef size_t len_instrument_type = len(instrument_type_bytes)
        cdef c_api.StringHandle s_instrument_type = c_api.String_create(raw_instrument_type, len_instrument_type)
        cdef c_api.MeasurementContextHandle h
        try:
            h = c_api.MeasurementContext_create(<c_api.ConnectionHandle>connection.handle, s_instrument_type)
        finally:
            c_api.String_destroy(s_instrument_type)
        if h == <c_api.MeasurementContextHandle>0:
            raise MemoryError("Failed to create MeasurementContext")
        cdef MeasurementContext obj = <MeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new_from_port(cls, port):
        cdef c_api.MeasurementContextHandle h
        h = c_api.MeasurementContext_create_from_port(<c_api.InstrumentPortHandle>port.handle)
        if h == <c_api.MeasurementContextHandle>0:
            raise MemoryError("Failed to create MeasurementContext")
        cdef MeasurementContext obj = <MeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.MeasurementContextHandle h
        try:
            h = c_api.MeasurementContext_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.MeasurementContextHandle>0:
            raise MemoryError("Failed to create MeasurementContext")
        cdef MeasurementContext obj = <MeasurementContext>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def connection(self):
        if self.handle == <c_api.MeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.MeasurementContext_connection(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def instrument_type(self):
        if self.handle == <c_api.MeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MeasurementContext_instrument_type(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def equal(self, b):
        if self.handle == <c_api.MeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasurementContext_equal(self.handle, <c_api.MeasurementContextHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.MeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.MeasurementContext_not_equal(self.handle, <c_api.MeasurementContextHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.MeasurementContextHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.MeasurementContext_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef MeasurementContext _measurementcontext_from_capi(c_api.MeasurementContextHandle h):
    cdef MeasurementContext obj = <MeasurementContext>MeasurementContext.__new__(MeasurementContext)
    obj.handle = h