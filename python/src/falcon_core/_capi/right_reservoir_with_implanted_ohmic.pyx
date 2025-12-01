cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from . cimport connection

cdef class RightReservoirWithImplantedOhmic:
    def __cinit__(self):
        self.handle = <_c_api.RightReservoirWithImplantedOhmicHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.RightReservoirWithImplantedOhmicHandle>0 and self.owned:
            _c_api.RightReservoirWithImplantedOhmic_destroy(self.handle)
        self.handle = <_c_api.RightReservoirWithImplantedOhmicHandle>0


cdef RightReservoirWithImplantedOhmic _right_reservoir_with_implanted_ohmic_from_capi(_c_api.RightReservoirWithImplantedOhmicHandle h):
    if h == <_c_api.RightReservoirWithImplantedOhmicHandle>0:
        return None
    cdef RightReservoirWithImplantedOhmic obj = RightReservoirWithImplantedOhmic.__new__(RightReservoirWithImplantedOhmic)
    obj.handle = h
    obj.owned = True
    return obj

    @classmethod
    def create(cls, str name, Connection left_neighbor, Connection ohmic):
        cdef bytes b_name = name.encode("utf-8")
        cdef StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.RightReservoirWithImplantedOhmicHandle h
        try:
            h = _c_api.RightReservoirWithImplantedOhmic_create(s_name, left_neighbor.handle, ohmic.handle)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise MemoryError("Failed to create RightReservoirWithImplantedOhmic")
        cdef RightReservoirWithImplantedOhmic obj = <RightReservoirWithImplantedOhmic>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def from_json_string(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.RightReservoirWithImplantedOhmicHandle h
        try:
            h = _c_api.RightReservoirWithImplantedOhmic_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.RightReservoirWithImplantedOhmicHandle>0:
            raise MemoryError("Failed to create RightReservoirWithImplantedOhmic")
        cdef RightReservoirWithImplantedOhmic obj = <RightReservoirWithImplantedOhmic>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def name(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.RightReservoirWithImplantedOhmic_name(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def type(self, ):
        cdef StringHandle s_ret
        s_ret = _c_api.RightReservoirWithImplantedOhmic_type(self.handle)
        if s_ret == <StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def ohmic(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.RightReservoirWithImplantedOhmic_ohmic(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def left_neighbor(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.RightReservoirWithImplantedOhmic_left_neighbor(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return connection._connection_from_capi(h_ret)

    def equal(self, RightReservoirWithImplantedOhmic b):
        return _c_api.RightReservoirWithImplantedOhmic_equal(self.handle, b.handle)

    def __eq__(self, RightReservoirWithImplantedOhmic b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.equal(b)

    def not_equal(self, RightReservoirWithImplantedOhmic b):
        return _c_api.RightReservoirWithImplantedOhmic_not_equal(self.handle, b.handle)

    def __ne__(self, RightReservoirWithImplantedOhmic b):
        if not hasattr(b, "handle"):
            return NotImplemented
        return self.not_equal(b)
