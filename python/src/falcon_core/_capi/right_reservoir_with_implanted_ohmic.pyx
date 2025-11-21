# cython: language_level=3
from . cimport c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdbool cimport bool
from .connection cimport Connection

cdef class RightReservoirWithImplantedOhmic:
    cdef c_api.RightReservoirWithImplantedOhmicHandle handle
    cdef bint owned

    def __cinit__(self):
        self.handle = <c_api.RightReservoirWithImplantedOhmicHandle>0
        self.owned = True

    def __dealloc__(self):
        if self.handle != <c_api.RightReservoirWithImplantedOhmicHandle>0 and self.owned:
            c_api.RightReservoirWithImplantedOhmic_destroy(self.handle)
        self.handle = <c_api.RightReservoirWithImplantedOhmicHandle>0

    cdef RightReservoirWithImplantedOhmic from_capi(cls, c_api.RightReservoirWithImplantedOhmicHandle h):
        cdef RightReservoirWithImplantedOhmic obj = <RightReservoirWithImplantedOhmic>cls.__new__(cls)
        obj.handle = h
        obj.owned = False
        return obj

    @classmethod
    def new(cls, name, left_neighbor, ohmic):
        name_bytes = name.encode("utf-8")
        cdef const char* raw_name = name_bytes
        cdef size_t len_name = len(name_bytes)
        cdef c_api.StringHandle s_name = c_api.String_create(raw_name, len_name)
        cdef c_api.RightReservoirWithImplantedOhmicHandle h
        try:
            h = c_api.RightReservoirWithImplantedOhmic_create(s_name, <c_api.ConnectionHandle>left_neighbor.handle, <c_api.ConnectionHandle>ohmic.handle)
        finally:
            c_api.String_destroy(s_name)
        if h == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise MemoryError("Failed to create RightReservoirWithImplantedOhmic")
        cdef RightReservoirWithImplantedOhmic obj = <RightReservoirWithImplantedOhmic>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json(cls, json):
        json_bytes = json.encode("utf-8")
        cdef const char* raw_json = json_bytes
        cdef size_t len_json = len(json_bytes)
        cdef c_api.StringHandle s_json = c_api.String_create(raw_json, len_json)
        cdef c_api.RightReservoirWithImplantedOhmicHandle h
        try:
            h = c_api.RightReservoirWithImplantedOhmic_from_json_string(s_json)
        finally:
            c_api.String_destroy(s_json)
        if h == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise MemoryError("Failed to create RightReservoirWithImplantedOhmic")
        cdef RightReservoirWithImplantedOhmic obj = <RightReservoirWithImplantedOhmic>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def name(self):
        if self.handle == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.RightReservoirWithImplantedOhmic_name(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def type(self):
        if self.handle == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.RightReservoirWithImplantedOhmic_type(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

    def ohmic(self):
        if self.handle == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.RightReservoirWithImplantedOhmic_ohmic(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def left_neighbor(self):
        if self.handle == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.ConnectionHandle h_ret
        h_ret = c_api.RightReservoirWithImplantedOhmic_left_neighbor(self.handle)
        if h_ret == <c_api.ConnectionHandle>0:
            return None
        return Connection.from_capi(Connection, h_ret)

    def equal(self, b):
        if self.handle == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.RightReservoirWithImplantedOhmic_equal(self.handle, <c_api.RightReservoirWithImplantedOhmicHandle>b.handle)

    def __eq__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, b):
        if self.handle == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise RuntimeError("Handle is null")
        return c_api.RightReservoirWithImplantedOhmic_not_equal(self.handle, <c_api.RightReservoirWithImplantedOhmicHandle>b.handle)

    def __ne__(self, b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)

    def to_json_string(self):
        if self.handle == <c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise RuntimeError("Handle is null")
        cdef c_api.StringHandle s_ret
        s_ret = c_api.RightReservoirWithImplantedOhmic_to_json_string(self.handle)
        if s_ret == <c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            c_api.String_destroy(s_ret)

cdef RightReservoirWithImplantedOhmic _rightreservoirwithimplantedohmic_from_capi(c_api.RightReservoirWithImplantedOhmicHandle h):
    cdef RightReservoirWithImplantedOhmic obj = <RightReservoirWithImplantedOhmic>RightReservoirWithImplantedOhmic.__new__(RightReservoirWithImplantedOhmic)
    obj.handle = h