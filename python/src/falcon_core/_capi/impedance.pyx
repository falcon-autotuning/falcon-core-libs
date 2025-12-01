cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection

cdef class Impedance:
    def __cinit__(self):
        self.handle = <_c_api.ImpedanceHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.ImpedanceHandle>0 and self.owned:
            _c_api.Impedance_destroy(self.handle)
        self.handle = <_c_api.ImpedanceHandle>0


cdef Impedance _impedance_from_capi(_c_api.ImpedanceHandle h):
    if h == <_c_api.ImpedanceHandle>0:
        return None
    cdef Impedance obj = Impedance.__new__(Impedance)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, Connection connection, double resistance, double capacitance):
        cdef _c_api.ImpedanceHandle h
        h = _c_api.Impedance_create(connection.handle, resistance, capacitance)
        if h == <_c_api.ImpedanceHandle>0:
            raise MemoryError("Failed to create Impedance")
        cdef Impedance obj = <Impedance>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
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
        return connection._connection_from_capi(h_ret)

    def resistance(self, ):
        return _c_api.Impedance_resistance(self.handle)

    def capacitance(self, ):
        return _c_api.Impedance_capacitance(self.handle)

    def equal(self, Impedance b):
        return _c_api.Impedance_equal(self.handle, b.handle)

    def __eq__(self, Impedance b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, Impedance b):
        return _c_api.Impedance_not_equal(self.handle, b.handle)

    def __ne__(self, Impedance b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
