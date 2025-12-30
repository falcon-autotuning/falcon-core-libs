cimport _c_api
from cpython.bytes cimport PyBytes_FromStringAndSize
from libc.stddef cimport size_t
from libc.stdint cimport int8_t, int16_t, int32_t, int64_t, uint8_t, uint16_t, uint32_t, uint64_t
from libcpp cimport bool
from .connection cimport Connection, _connection_from_capi

cdef class LeftReservoirWithImplantedOhmic:
    def __cinit__(self):
        self.handle = <_c_api.LeftReservoirWithImplantedOhmicHandle>0
        self.owned = False

    def __dealloc__(self):
        if self.handle != <_c_api.LeftReservoirWithImplantedOhmicHandle>0 and self.owned:
            _c_api.LeftReservoirWithImplantedOhmic_destroy(self.handle)
        self.handle = <_c_api.LeftReservoirWithImplantedOhmicHandle>0


    @classmethod
    def from_json(cls, str json):
        cdef bytes b_json = json.encode("utf-8")
        cdef _c_api.StringHandle s_json = _c_api.String_create(b_json, len(b_json))
        cdef _c_api.LeftReservoirWithImplantedOhmicHandle h
        try:
            h = _c_api.LeftReservoirWithImplantedOhmic_from_json_string(s_json)
        finally:
            _c_api.String_destroy(s_json)
        if h == <_c_api.LeftReservoirWithImplantedOhmicHandle>0:
            raise MemoryError("Failed to create LeftReservoirWithImplantedOhmic")
        cdef LeftReservoirWithImplantedOhmic obj = <LeftReservoirWithImplantedOhmic>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    @classmethod
    def new(cls, str name, Connection right_neighbor, Connection ohmic):
        cdef bytes b_name = name.encode("utf-8")
        cdef _c_api.StringHandle s_name = _c_api.String_create(b_name, len(b_name))
        cdef _c_api.LeftReservoirWithImplantedOhmicHandle h
        try:
            h = _c_api.LeftReservoirWithImplantedOhmic_create(s_name, right_neighbor.handle if right_neighbor is not None else <_c_api.ConnectionHandle>0, ohmic.handle if ohmic is not None else <_c_api.ConnectionHandle>0)
        finally:
            _c_api.String_destroy(s_name)
        if h == <_c_api.LeftReservoirWithImplantedOhmicHandle>0:
            raise MemoryError("Failed to create LeftReservoirWithImplantedOhmic")
        cdef LeftReservoirWithImplantedOhmic obj = <LeftReservoirWithImplantedOhmic>cls.__new__(cls)
        obj.handle = h
        obj.owned = True
        return obj

    def copy(self, ):
        cdef _c_api.LeftReservoirWithImplantedOhmicHandle h_ret = _c_api.LeftReservoirWithImplantedOhmic_copy(self.handle)
        if h_ret == <_c_api.LeftReservoirWithImplantedOhmicHandle>0:
            return None
        return _left_reservoir_with_implanted_ohmic_from_capi(h_ret)

    def equal(self, LeftReservoirWithImplantedOhmic other):
        return _c_api.LeftReservoirWithImplantedOhmic_equal(self.handle, other.handle if other is not None else <_c_api.LeftReservoirWithImplantedOhmicHandle>0)

    def __eq__(self, LeftReservoirWithImplantedOhmic other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.equal(other)

    def not_equal(self, LeftReservoirWithImplantedOhmic other):
        return _c_api.LeftReservoirWithImplantedOhmic_not_equal(self.handle, other.handle if other is not None else <_c_api.LeftReservoirWithImplantedOhmicHandle>0)

    def __ne__(self, LeftReservoirWithImplantedOhmic other):
        if not hasattr(other, "handle"):
            return NotImplemented
        return self.not_equal(other)

    def to_json(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.LeftReservoirWithImplantedOhmic_to_json_string(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def name(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.LeftReservoirWithImplantedOhmic_name(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def type(self, ):
        cdef _c_api.StringHandle s_ret
        s_ret = _c_api.LeftReservoirWithImplantedOhmic_type(self.handle)
        if s_ret == <_c_api.StringHandle>0:
            return ""
        try:
            return PyBytes_FromStringAndSize(s_ret.raw, s_ret.length).decode("utf-8")
        finally:
            _c_api.String_destroy(s_ret)

    def ohmic(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.LeftReservoirWithImplantedOhmic_ohmic(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret)

    def right_neighbor(self, ):
        cdef _c_api.ConnectionHandle h_ret = _c_api.LeftReservoirWithImplantedOhmic_right_neighbor(self.handle)
        if h_ret == <_c_api.ConnectionHandle>0:
            return None
        return _connection_from_capi(h_ret)

cdef LeftReservoirWithImplantedOhmic _left_reservoir_with_implanted_ohmic_from_capi(_c_api.LeftReservoirWithImplantedOhmicHandle h, bint owned=True):
    if h == <_c_api.LeftReservoirWithImplantedOhmicHandle>0:
        return None
    cdef LeftReservoirWithImplantedOhmic obj = LeftReservoirWithImplantedOhmic.__new__(LeftReservoirWithImplantedOhmic)
    obj.handle = h
    obj.owned = owned
    return obj
