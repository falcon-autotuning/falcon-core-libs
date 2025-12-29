cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi

cdef class Impedance:
    def __cinit__(self):
        self.handle = <_c_api.ImpedanceHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ImpedanceHandle>0 and self.owned:
            _c_api.Impedance_destroy(self.handle)
        self.handle = <_c_api.ImpedanceHandle>0


    @classmethod
    def new(cls, Connection connection, double resistance, double capacitance):
        cdef _c_api.ImpedanceHandle h
        h = _c_api.Impedance_create(connection.handle if connection is not None else <_c_api.ConnectionHandle>0, resistance, capacitance)
        if h == <_c_api.ImpedanceHandle>0:
            raise MemoryError("Failed to create Impedance")
        cdef Impedance obj = <Impedance>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.ImpedanceHandle h
        try:
            h = _c_api.Impedance_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.ImpedanceHandle>0:
            raise MemoryError("Failed to create Impedance")
        cdef Impedance obj = <Impedance>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def connection(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.Impedance_connection(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret, owned=False)

    def resistance(self, ):
        return _c_api.Impedance_resistance(self.handle)

    def capacitance(self, ):
        return _c_api.Impedance_capacitance(self.handle)

    def equal(self, Impedance other):
        return _c_api.Impedance_equal(self.handle, other.handle if other is not None else <_c_api.ImpedanceHandle>0)

    def __eq__(self, Impedance other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, Impedance other):
        return _c_api.Impedance_not_equal(self.handle, other.handle if other is not None else <_c_api.ImpedanceHandle>0)

    def __ne__(self, Impedance other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.Impedance_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

cdef Impedance _impedance_from_capi(_c_api.ImpedanceHandle h, bint owned=True):
    if h == <_c_api.ImpedanceHandle>0:
        return None
    cdef Impedance obj = Impedance.__new__(Impedance)
    obj.handle = h
    obj.owned = owned
    return obj
