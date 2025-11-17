# cython: language_level=3
from cpython.bytes cimport PyBytes_FromStringAndSize
from . cimport c_api
from .connection cimport Connection as _CConnection
from libc.stddef cimport size_t

# Import the Python class to wrap returned/created Connection objects
from ..physics.device_structures.connection import Connection as PyConnection

cdef class Impedance:
    """Thin Cython wrapper owning an ImpedanceHandle."""
    cdef c_api.ImpedanceHandle handle

    def __cinit__(self):
        self.handle = <c_api.ImpedanceHandle>0

    def __dealloc__(self):
        if self.handle != <c_api.ImpedanceHandle>0:
            c_api.Impedance_destroy(self.handle)
            self.handle = <c_api.ImpedanceHandle>0

    @classmethod
    def new(cls, conn, double resistance, double capacitance):
        """
        Create an Impedance from a Python Connection wrapper (expects the
        Python Connection instance that has a ._c attribute pointing to
        the Cython Connection object).
        """
        # extract the cdef connection wrapper from the Python Connection wrapper
        c_conn = <_CConnection>conn._c
        cdef c_api.ImpedanceHandle h = c_api.Impedance_create(c_conn.handle, resistance, capacitance)
        if h == <c_api.ImpedanceHandle>0:
            raise MemoryError("failed to create Impedance")
        cdef Impedance i = <Impedance>cls.__new__(cls)
        i.handle = h
        return i

    @classmethod
    def from_json(cls, json_str):
        b = json_str.encode("utf-8")
        cdef const char* raw = b
        cdef size_t l = len(b)
        cdef c_api.StringHandle s = c_api.String_create(raw, l)
        try:
            h = c_api.Impedance_from_json_string(s)
        finally:
            c_api.String_destroy(s)
        if h == <c_api.ImpedanceHandle>0:
            cdef Impedance i = <Impedance>cls.__new__(cls)
            i.handle = h
            return i
        raise ValueError("failed to parse Impedance from json")

    def connection(self):
        if self.handle == <c_api.ImpedanceHandle>0:
            return None
        cdef c_api.ConnectionHandle h = c_api.Impedance_connection(self.handle)
        if h == <c_api.ConnectionHandle>0:
            return None
        cdef _CConnection c_conn = _CConnection()
        c_conn.handle = h
        return PyConnection(c_conn)

    def resistance(self):
        return c_api.Impedance_resistance(self.handle)

    def capacitance(self):
        return c_api.Impedance_capacitance(self.handle)

    def to_json(self):
        if self.handle == <c_api.ImpedanceHandle>0:
            return ""
        cdef c_api.StringHandle s = c_api.Impedance_to_json_string(self.handle)
        if s == <c_api.StringHandle>0:
            return ""
        cdef const char* raw = s.raw
        cdef size_t ln = s.length
        try:
            b = PyBytes_FromStringAndSize(raw, ln)
            return b.decode("utf-8")
        finally:
            c_api.String_destroy(s)

    def __richcmp__(self, other, int op):
        if not isinstance(other, Impedance):
            return NotImplemented
        cdef Impedance o = <Impedance>other
        if op == 2:  # ==
            return bool(c_api.Impedance_equal(self.handle, o.handle))
        elif op == 3:  # !=
            return bool(c_api.Impedance_not_equal(self.handle, o.handle))
        return NotImplemented
